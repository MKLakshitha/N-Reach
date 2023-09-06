import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:n_reach_nsbm/pages/add_paymentcard_page.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../components/constants.dart';
import '../model/auth_controller.dart';
import '../widgets/green_intro_widget.dart';
import 'btmnavbar.dart';
import 'pay.dart';
import 'sidebar.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return WalletPageState();
  }
}

class WalletPageState extends State<WalletPage> {
  String id = '';
  Map<String, dynamic>? paymentIntent;
  TextEditingController controller = TextEditingController();
  void makePayment() async {
    try {
      final userEmail = FirebaseAuth.instance.currentUser!.email;
      final umisId = await fetchUMISID();
      final customerId = await createStripeCustomer(umisId);
      paymentIntent = await createPaymentIntent(customerId);
      var gpay = const PaymentSheetGooglePay(
          merchantCountryCode: "US", currencyCode: "USD", testEnv: true);

      Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent!["client_secret"],
          style: ThemeMode.light,
          merchantDisplayName: "N - Reach",
          googlePay: gpay,
        ),
      );
      displayPaymentSheet();
    } catch (e) {}
  }

  Future<void> generatePaymentReceiptPdf(String amount, String feeType) async {
    PdfDocument document = PdfDocument();
    final page = document.pages.add();

    final PdfFont titleFont = PdfStandardFont(PdfFontFamily.helvetica, 30);
    final PdfFont subtitleFont = PdfStandardFont(PdfFontFamily.helvetica, 18);
    final PdfFont headerFont = PdfStandardFont(PdfFontFamily.helvetica, 14);
    final PdfFont cellFont = PdfStandardFont(PdfFontFamily.helvetica, 12);

    // Title
    page.graphics.drawString('Payment Receipt', titleFont,
        format: PdfStringFormat(alignment: PdfTextAlignment.left),
        brush: PdfSolidBrush(PdfColor(0, 0, 0, 1)));

    // Image
    final Uint8List imageData = await _readImageData('assets/nreach.png');
    final PdfImage image = PdfBitmap(imageData);
    page.graphics.drawImage(image, const Rect.fromLTWH(30, 50, 100, 100));

    // Subtitle
    page.graphics.drawString('Payment Details', subtitleFont,
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        bounds: const Rect.fromLTWH(30, 160, 0, 0));

    // Grid Style Settings
    PdfGrid grid = PdfGrid();
    grid.style = PdfGridStyle(
      font: cellFont,
      cellPadding: PdfPaddings(left: 10, right: 10, top: 5, bottom: 5),
      backgroundBrush: PdfSolidBrush(PdfColor(230, 230, 230)),
      textBrush: PdfSolidBrush(PdfColor(0, 0, 0)),
    );

    grid.columns.add(count: 3);
    grid.headers.add(1);

    // Header Cell Settings
    PdfGridRow header = grid.headers[0];
    header.cells[0].value = 'Student Number';
    header.cells[1].value = 'Fee Type';
    header.cells[2].value = 'Amount';
    header.cells[0].style = PdfGridCellStyle(
      font: headerFont,
      backgroundBrush: PdfSolidBrush(PdfColor(180, 180, 180)),
    );
    header.cells[1].style = PdfGridCellStyle(
      font: headerFont,
      backgroundBrush: PdfSolidBrush(PdfColor(180, 180, 180)),
    );
    header.cells[2].style = PdfGridCellStyle(
      font: headerFont,
      backgroundBrush: PdfSolidBrush(PdfColor(180, 180, 180)),
    );

    // Data Row
    PdfGridRow row = grid.rows.add();
    String umisId = await fetchUMISID();
    row.cells[0].value = umisId;
    row.cells[1].value = feeType;
    row.cells[2].value = '\$$amount.00';

    // Drawing the Grid
    grid.draw(page: page, bounds: const Rect.fromLTWH(30, 200, 0, 0));

    // Footer
    page.graphics.drawString('All rights reserved. Terms & conditions apply.',
        PdfStandardFont(PdfFontFamily.helvetica, 8),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        bounds: const Rect.fromLTWH(30, 500, 0, 0));

    List<int> bytes = await document.save();
    document.dispose();

    saveAndLaunchFile(bytes, 'NReachInvoice.pdf');
  }

  Future<Uint8List> _readImageData(String name) async {
    final data = await rootBundle.load(name);
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }

  void displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      controller.text = "";
      _showSuccessSnackbar("Payment Successful!");
      generatePaymentReceiptPdf(enteredAmount, selectedFeeType);

// Navigate to PDFView
    } catch (e) {
      _showErrorSnackbar("Payment Failed!");
    }
  }

  Future<String> createStripeCustomer(String umisId) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.stripe.com/v1/customers'),
        body: {
          'description': umisId, // Use UMIS_ID as metadata
        },
        headers: {
          'Authorization':
              'Bearer sk_test_51NkLR4LO1mW4ni4mJicTIjUBT9vutdldwx8ahmXWqTbRhvJtrDzizTbKI2crczF4G061R1Pi7vUVwPh64jvbyVvs00f59rB77c',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );
      final data = json.decode(response.body);
      return data['id'];
    } catch (e) {
      throw Exception('Error creating Stripe customer: ${e.toString()}');
    }
  }

  createPaymentIntent(String customerId) async {
    try {
      Map<String, dynamic> body = {
        "amount": (int.parse(controller.text) * 100).toString(),
        "currency": "USD",
        "customer": customerId,
        "description": selectedFeeType.toString(), // Description of the payment
      };
      http.Response response = await http.post(
          Uri.parse("https://api.stripe.com/v1/payment_intents"),
          body: body,
          headers: {
            "Authorization":
                "Bearer sk_test_51NkLR4LO1mW4ni4mJicTIjUBT9vutdldwx8ahmXWqTbRhvJtrDzizTbKI2crczF4G061R1Pi7vUVwPh64jvbyVvs00f59rB77c",
            "Content-Type": "application/x-www-form-urlencoded",
          });
      return json.decode(response.body);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  late Future<String> umisIdFuture;

  List<String> feeTypes = [
    'Gym Fee',
    'Swimming Fee',
    'Library Fee',
    'Semester Fee',
  ];

  void _onItemTapped(int index) {}
  String cardNumber = '5555 55555 5555 4444';
  String expiryDate = '12/25';
  String cardHolderName = 'Kavindu Lakshitha';
  String cvvCode = '123';
  bool isCvvFocused = false;
  bool useGlassMorphism = false;
  bool useBackgroundImage = false;
  OutlineInputBorder? border;
  String selectedFeeType = 'Gym Fee';
  String enteredAmount = '';
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final AuthController authController = Get.put(AuthController());

  @override
  void initState() {
    Stripe.publishableKey =
        'pk_test_51NkLR4LO1mW4ni4muH7miIdwvWaYhAAN8GnZhza9gJjNh2LamyPIsWojEysf7udLC2QLgGV7HsjinosD3Si1GGpZ00xflWcMFE';
    authController.getUserCards();
    umisIdFuture = fetchUMISID();
    border = OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey.withOpacity(0.7),
        width: 2.0,
      ),
    );
    super.initState();
  }

  Future<String> fetchUMISID() async {
    // Replace this with your Firebase data fetching logic for UMIS_ID
    // For example:
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    return snapshot['UMIS_ID'] ?? '';
// Placeholder value, replace with actual fetched data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text(
              'N - WALLET',
              style: TextStyle(color: primaryColor),
            ),
            titleSpacing: 1.0,
            automaticallyImplyLeading: true,
            backgroundColor: white,
            iconTheme: const IconThemeData(
              color: Colors.black, // Change the color of the leading icon here
            ),
            elevation: 0),
        resizeToAvoidBottomInset: false,
        body: SizedBox(
          width: Get.width,
          height: Get.height,
          child: Stack(
            children: <Widget>[
              greenIntroWidgetWithoutLogos(title: 'My Cards'),
              Positioned(
                top: 80,
                left: 0,
                right: 0,
                bottom: 0,
                child: Obx(() => ListView(
                      scrollDirection: Axis
                          .horizontal, // Set the scroll direction to horizontal
                      children: authController.userCards.map((cardData) {
                        String cardNumber = cardData.get('number') ?? '';
                        String expiryDate = cardData.get('expiry') ?? '';
                        String cardHolderName = cardData.get('name') ?? '';
                        String cvvCode = cardData.get('cvv') ?? '';

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CreditCardWidget(
                            cardBgColor: Colors.black,
                            cardNumber: cardNumber,
                            expiryDate: expiryDate,
                            cardHolderName: cardHolderName,
                            cvvCode: cvvCode,
                            bankName: '',
                            showBackView: isCvvFocused,
                            obscureCardNumber: true,
                            obscureCardCvv: true,
                            isHolderNameVisible: true,
                            isSwipeGestureEnabled: true,
                            onCreditCardWidgetChange:
                                (CreditCardBrand creditCardBrand) {},
                          ),
                        );
                      }).toList(),
                    )),
              ),
              Positioned(
                top: 320,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 25, right: 25, top: 10, bottom: 10),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Payment Details',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Text(
                                "Student's NSBM ID No",
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(
                                width: 150,
                              ),
                              FutureBuilder<String>(
                                future: umisIdFuture,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  } else if (snapshot.hasData) {
                                    return Text(
                                      ' ${snapshot.data}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    );
                                  } else {
                                    return const Text(
                                      ' No Data',
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Text(
                                'Select Fee Type',
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(
                                width: 120,
                              ),
                              SizedBox(
                                child: DropdownButton<String>(
                                  value: selectedFeeType,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedFeeType = value!;
                                    });
                                  },
                                  items: feeTypes.map((feeType) {
                                    return DropdownMenuItem<String>(
                                      value: feeType,
                                      child: Text(feeType),
                                    );
                                  }).toList(),
                                  style: const TextStyle(
                                      color: Colors.black), // Text color
                                  dropdownColor:
                                      Colors.green, // Dropdown background color
                                  elevation: 3, // Dropdown elevation
                                  // Expand dropdown to fill width
                                  icon: const Icon(
                                      Icons.arrow_drop_down), // Dropdown icon
                                  iconEnabledColor: Colors.green, // Icon color
                                  underline: Container(
                                    // Remove underline
                                    height: 1,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 350,
                            child: TextField(
                              controller: controller,
                              decoration: InputDecoration(
                                labelText: 'Enter Amount',
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 12.0, horizontal: 12),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.green, width: 2.0),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.green, width: 1.0),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                suffixIcon: const Icon(
                                  Icons.attach_money, // Dollar icon
                                  color: Colors.green, // Icon color
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  enteredAmount = value;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            width: 150,
                            child: ElevatedButton(
                              onPressed: () {
                                // Perform payment logic here
                                makePayment();
                                // You can add more payment logic here
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Colors.green, // Background color
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      20.0), // Rounded corners
                                ),
                              ),
                              child: const Text('Pay Here',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 10,
                right: 10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Add new card",
                      style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.greenColor),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    FloatingActionButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const AddPaymentCardScreen()), // Replace AnotherPage with the page you want to navigate to
                        );
                      },
                      backgroundColor: AppColors.greenColor,
                      child: const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BtmNavBar(
          currentIndex: 3,
          onItemSelected: _onItemTapped,
        ));
  }
}
