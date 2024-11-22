import 'package:advertisement/ad_booked_user.dart';
import 'package:advertisement/user_bottom_nav.dart';
import 'package:advertisement/user_home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentPage extends StatefulWidget {
  @override
  State<PaymentPage> createState() => _PaymentPageState();
}
class _PaymentPageState extends State<PaymentPage> {
  String id_ = "";
  String namel_ = '';
  String place_ = '';
  String price_ = "";
  String photo_ = "";
  String phonenum = "";
  String category="";
  String location="";
  String phone="";
  String? payid="";

  Future<void> shared() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      phonenum = prefs.getString("phoneii")!;
      id_ = prefs.getString("selectedAdId")!;
      price_ = prefs.getString("price")!;
      namel_ = prefs.getString("name")!;
      photo_ = prefs.getString("photo")!;
      phone=prefs.getString("phone").toString();
      category=prefs.getString("category").toString();
      location=prefs.getString("location").toString();
      place_=prefs.getString("place").toString();
    });
  }

  Future<void> Addpayments() async {
    CollectionReference firbd = FirebaseFirestore.instance.collection("payments");
    DocumentReference firedj = FirebaseFirestore.instance.collection("advertisement").doc(id_);
    firbd.add({"amount": price_, "adreference": firedj, "purchased by": phonenum,"payment id":payid, "Date":DateFormat.yMMMEd().format(DateTime.now()).toString(),"createdAt":FieldValue.serverTimestamp()});
  }
  Future<void>UpdateAd()async{
    CollectionReference firedb=FirebaseFirestore.instance.collection("advertisement");
    firedb.doc(id_).update({
      "status":"Booked",
      "assigned":"pending",
      "customerph":phonenum,
      "worker":"not selected",
      "Date":DateFormat.yMMMEd().format(DateTime.now()).toString()
    });
  }

  @override
  void initState() {
    super.initState();
    shared();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Confirm Payment',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20.0,
            fontWeight: FontWeight.w400,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image with a minimal frame and rounded edges
            AspectRatio(
              aspectRatio: 16 / 9,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Image.network(
                  photo_,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: Icon(
                        Icons.broken_image,
                        color: Colors.grey[500],
                        size: 50.0,
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 24.0),
            // Item name and location with a minimal aesthetic
            Text(
              namel_,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              place_,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey[600],
              ),
            ),
            _buildDetailRow('Category', category),
            _buildDetailRow('place', place_),
            _buildDetailRow('phone', phone),
            Spacer(),
            // Price and total section with subtle divider
            Divider(
              color: Colors.grey[300],
              thickness: 1.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    '$price_',
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            // Pay button with a flat design
            ElevatedButton(
              onPressed: (){
                Razorpay razorpay = Razorpay();
                var options = {
                  'key': 'rzp_live_ILgsfZCZoFIKMb',
                  'amount': 100,
                  'name': 'Acme Corp.',
                  'description': 'Fine T-Shirt',
                  'retry': {'enabled': true, 'max_count': 1},
                  'send_sms_hash': true,
                  'prefill': {'contact': '9946262047', 'email': 'sahadulla2002@gmail.com'},
                  'external': {
                    'wallets': ['paytm']
                  }
                };
                razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
                razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
                razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
                razorpay.open(options);
              },
              child: Text(
                'Pay Now',
                style: TextStyle(fontSize: 16.0, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                elevation: 0,
                minimumSize: Size(double.infinity, 50.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
            SizedBox(height: 20.0),
          ],
        ),
      ),
    );

  }
  void handlePaymentErrorResponse(PaymentFailureResponse response){
    /*
    * PaymentFailureResponse contains three values:
    * 1. Error Code
    * 2. Error Description
    * 3. Metadata
    * */
    showAlertDialog(context, "Payment Failed", "Code: ${response.code}\nDescription: ${response.message}\nMetadata:${response.error.toString()}");
    Navigator.push(context, MaterialPageRoute(builder: (context)=>UserHome()));
    Alert(
      context: context,
      title: "Payment Failed",style: AlertStyle(isButtonVisible: false,
        titleStyle: GoogleFonts.dmSans(fontSize: 15)),
      image: Image.asset("assets/paymentf.png",height: 70,),
    ).show();

  }
  void handlePaymentSuccessResponse(PaymentSuccessResponse response){

    /*
    * Payment Success Response contains three values:
    * 1. Order ID
    * 2. Payment ID
    * 3. Signature
    * */
    String? payurr=response.paymentId;
    setState(() {
      payid=payurr;
    });
    Addpayments();
    UpdateAd();
    Navigator.push(context, MaterialPageRoute(builder: (context)=>UserHome()));
    Alert(
      context: context,
      title: "Payment Success",style: AlertStyle(isButtonVisible: false,
        titleStyle: GoogleFonts.dmSans(fontSize: 15)),
      image: Image.asset("assets/payment.png",height: 70,),
    ).show();

  }

  void handleExternalWalletSelected(ExternalWalletResponse response){
    showAlertDialog(context, "External Wallet Selected", "${response.walletName}");
  }
  void showAlertDialog(BuildContext context, String title, String message){
    // set up the buttons
    Widget continueButton = ElevatedButton(
      child: const Text("Continue"),
      onPressed:  () {

      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  Widget _buildDetailRow(String title, String detail) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.grey[600],
            ),
          ),
          Text(
            detail,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
