import 'package:flutter/material.dart';
import 'package:n_reach_nsbm/pages/btmnavbar.dart';
import 'package:n_reach_nsbm/pages/sidebar.dart';

class Medical extends StatefulWidget {
  const Medical({Key? key}) : super(key: key);

  @override
  State<Medical> createState() => _MedicalState();
}

class _MedicalState extends State<Medical> {
  void _onItemTapped(int index) {}
  final List<String> _items = ['Apple', 'Banana', 'Orange', 'Pear'];
  final String _selectedValue = '';
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
          title: const Text(
            'Medical Appointment',
            style: TextStyle(color: primaryColor),
          ),
          titleSpacing: 1.0,
          automaticallyImplyLeading: true,
          backgroundColor: white,
          iconTheme: const IconThemeData(
            color: Colors.black, // Change the color of the leading icon here
          ),
          elevation: 0),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              'assets/lib.jpeg',
              height: height * 0.25,
              width: width,
              fit: BoxFit.cover,
            ),
            Container(
              padding: EdgeInsets.all(width * 0.04),
              child: Column(
                children: [
                  const Text(
                    'NSBM Medical Centre',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: width * 0.01,
                  ),
                  const Text(
                    'NSBM provides free medical services to students and staffs\nBook your appointment and consult our doctor.\nWorking hours : 9.00 a.m - 5.00 p.m',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12),
                  ),
                  SizedBox(
                    height: width * 0.01,
                  ),
                  const Divider(
                    color: Colors.black, // Specify the color of the line
                    thickness: 1.0, // Specify the thickness of the line
                    indent: 70.0, // Specify the start indentation of the line
                    endIndent: 70.0, // Specify the end indentation of the line
                  ),
                  SizedBox(
                    height: width * 0.06,
                  ),
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Book an appointment',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: width * 0.01,
                  ),
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Fill out the details below and select the book now option to book an appointment',
                      style: TextStyle(fontSize: 12),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  SizedBox(
                    height: width * 0.03,
                  ),
                  Container(
                    padding: EdgeInsets.only(
                        left: width * 0.05,
                        right: width * 0.05,
                        bottom: width * 0.05),
                    width: width,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 243, 243, 243),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        const TextField(
                          decoration: InputDecoration(
                              labelText: 'Medical illness/reason: '),
                        ),
                        const TextField(
                          decoration: InputDecoration(
                              labelText: 'Date of appointment: '),
                        ),
                        const TextField(
                          decoration: InputDecoration(
                              labelText: 'Preferred time slot: '),
                        ),
                        const TextField(
                          decoration:
                              InputDecoration(labelText: 'Medical history: '),
                        ),
                        SizedBox(
                          height: width * 0.019,
                        ),
                        const Text(
                            'Note - You will be contacted by the medical centre for the available time slot and confirmation of the appointment. ',
                            textAlign: TextAlign.center)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        //width:
        onPressed: () {
          print('Floating action button pressed');
        },
        icon: const Icon(Icons.add_box_rounded),
        label: const Text(
          'Book Now',
          style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'DM Sans'),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        backgroundColor: Colors.green,
      ),
      bottomNavigationBar: BtmNavBar(
        currentIndex: 2,
        onItemSelected: _onItemTapped,
      ),
    );
  }

  BoxShadow shadowcard() {
    return BoxShadow(
      color:
          const Color.fromARGB(255, 0, 0, 0).withOpacity(0.25), // Shadow color
      spreadRadius: -1, // How much the shadow should spread
      blurRadius: 6, // How blurry the shadow should be
      offset: const Offset(0, 4), // Offset from the container
    );
  }
}
