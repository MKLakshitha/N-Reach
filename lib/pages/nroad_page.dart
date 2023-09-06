import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart'; // Import geolocator package
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location;
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher package

import '../components/constants.dart';
import 'btmnavbar.dart';
import 'sidebar.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController googleMapController;
  final Completer<GoogleMapController> _controller = Completer();
  final location.Location _location = location.Location();
  static const CameraPosition initialCameraPosition = CameraPosition(
      target: LatLng(6.821352258043743, 80.04158421542863), zoom: 17.8);
  late LatLng currentLocation = const LatLng(
      6.821352258043743, 80.04158421542863); // Default current location
  late LatLng destination = const LatLng(0, 0); // Default destination

  late LatLng _center = const LatLng(0, 0);
  late Position locationsd;
  Future<Position> locateUser() async {
    return Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> getUserLocation() async {
    LocationPermission permission;
    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!isLocationServiceEnabled) {
      // Handle case where location service is disabled
      // You can show a message to the user or take appropriate action.
      return;
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        // Handle case where location permission is denied
        // You can show a message to the user or take appropriate action.
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Handle case where location permission is permanently denied
      // You can show a message to the user or take appropriate action.
      return;
    }

    try {
      final locationData = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _center = LatLng(locationData.latitude, locationData.longitude);
      });
      print('Center $_center');
    } catch (e) {
      // Handle location retrieval errors here
      print('Error getting user location: $e');
      // You can show a message to the user or take appropriate action based on the error.
    }
  }

  Map<String, LatLng> places = {
    'Library': const LatLng(6.820891544853209, 80.03943558537321),
    'FOC': const LatLng(6.820228581844217, 80.03951036646042),
    'FOB': const LatLng(6.8206051449459, 80.03901360638112),
    'FOE': const LatLng(6.821032515629329, 80.03901359010301),
    'Student Center': const LatLng(6.820795067614276, 80.0402764100182),
    'Swimming Pool': const LatLng(6.821908894957894, 80.0398387695898),
    'NSBM Ground': const LatLng(6.821818989708539, 80.04021604582152),
    'Hostel Complex': const LatLng(6.8210098417048695, 80.03814857207169),
    'Edge': const LatLng(6.821478306053568, 80.03814411768971),
    'Admin Office': const LatLng(6.821005080503783, 80.03961100626087),
    'Car Park': const LatLng(6.820590939033528, 80.04175208603368),
    'Auditorium': const LatLng(6.820952766025354, 80.04081140061204),
    'BOC Bank': const LatLng(6.820841217680457, 80.04104857018505),
    'Medical Center': const LatLng(6.820694743168106, 80.04020913047262),
  };
  Set<Polyline> polylines = {}; // To store polylines

  @override
  void initState() {
    super.initState();
    getUserLocation();
  }

  Future<void> _getCurrentLocation() async {
    LocationPermission permission;
    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!isLocationServiceEnabled) {
      // Handle case where location service is disabled
      return;
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        // Handle case where location permission is denied
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Handle case where location permission is permanently denied
      return;
    }

    Position position = await Geolocator.getCurrentPosition();

    setState(() {
      currentLocation = LatLng(position.latitude, position.longitude);
    });
  }

  Future<void> getPolyPoints() async {
    PolylinePoints polylinepoints = PolylinePoints();
    PolylineResult result = await polylinepoints.getRouteBetweenCoordinates(
      google_api_key,
      PointLatLng(currentLocation.latitude, currentLocation.longitude),
      PointLatLng(destination.latitude, destination.longitude),
    );

    if (result.points.isNotEmpty) {
      polylines.clear();
      List<LatLng> polylineCoordinates = [];

      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }

      setState(() {
        polylines.add(Polyline(
          polylineId: const PolylineId('route'),
          color: primaryColor,
          points: polylineCoordinates,
          width: 6,
        ));
      });
    }
  }

  GeocodingPlatform geocodingPlatform = GeocodingPlatform.instance;
  Future<List<LatLng>> searchPlace(String placeName) async {
    if (places.containsKey(placeName)) {
      return [
        LatLng(places[placeName]!.latitude, places[placeName]!.longitude)
      ];
    } else {
      List<geocoding.Location> locations =
          await geocodingPlatform.locationFromAddress(placeName);
      List<LatLng> coordinates =
          locations.map((loc) => LatLng(loc.latitude, loc.longitude)).toList();
      return coordinates;
    }
  }

  @override
  Widget build(BuildContext context) {
    TextField searchTextField = TextField(
      decoration: InputDecoration(
        hintText: 'Search...',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onSubmitted: (value) async {
        List locations = await searchPlace(value);
        if (locations.isNotEmpty) {
          setState(() {
            destination =
                LatLng(locations.first.latitude!, locations.first.longitude!);
            getPolyPoints();
          });
        }
        googleMapController.animateCamera(
          CameraUpdate.newLatLngZoom(destination, 17.8),
        );
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'N - MAP',
          style: TextStyle(color: primaryColor),
        ),
        titleSpacing: 1.0,
        automaticallyImplyLeading: true,
        backgroundColor: white,
        iconTheme: const IconThemeData(
          color: Colors.black, // Change the color of the leading icon here
        ),
        elevation: 0,
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: initialCameraPosition,
            mapType: MapType.satellite,
            onMapCreated: (GoogleMapController controller) {
              googleMapController = controller;
            },
            polylines: polylines,
            markers: {
              Marker(
                markerId: const MarkerId("source"),
                position: currentLocation,
              ),
              Marker(
                markerId: const MarkerId("destination"),
                position: destination,
              ),
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TypeAheadField(
              textFieldConfiguration: TextFieldConfiguration(
                decoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle: const TextStyle(color: Colors.white),
                  prefixIcon: const Icon(Icons.search, color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              suggestionsCallback: (pattern) async {
                List<String> suggestions = places.keys.where((place) {
                  return place.toLowerCase().contains(pattern.toLowerCase());
                }).toList();
                return suggestions;
              },
              itemBuilder: (context, suggestion) {
                return ListTile(
                  title: Text(suggestion),
                );
              },
              onSuggestionSelected: (suggestion) async {
                List locations = await searchPlace(suggestion);
                if (locations.isNotEmpty) {
                  setState(() {
                    destination = LatLng(
                        locations.first.latitude!, locations.first.longitude!);
                    getPolyPoints();
                  });
                }
                googleMapController.animateCamera(
                  CameraUpdate.newLatLngZoom(destination, 17.8),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 28.0),
          child: FloatingActionButton(
            onPressed: () {
              launchDirections();
            },
            backgroundColor:
                Colors.white, // Set the background color of the button
            child: const Icon(Icons.directions,
                color: primaryColor), // Icon for directions
          ),
        ),
      ),
      bottomNavigationBar: BtmNavBar(
        currentIndex: 1,
        onItemSelected: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    // TODO: Handle bottom navigation bar item tap
  }

  void launchDirections() async {
    final url =
        "https://www.google.com/maps/dir/?api=1&origin=${currentLocation.latitude},${currentLocation.longitude}&destination=${destination.latitude},${destination.longitude}&travelmode=driving";

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      // Handle the case where the user can't open Google Maps.
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Could not launch Google Maps.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
