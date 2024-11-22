import 'package:advertisement/admin_dashhh.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

void main() {
// needed if you intend to initialize in the `main` function
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(

    // The top level function, aka callbackDispatcher
      callbackDispatcher,

      // If enabled it will post a notification whenever
      // the task is running. Handy for debugging tasks
      isInDebugMode: true);
// Periodic task registration
  Workmanager().registerPeriodicTask(
    "2",

    //This is the value that will be
    // returned in the callbackDispatcher
    "simplePeriodicTask",

    // When no frequency is provided
    // the default 15 minutes is set.
    // Minimum frequency is 15 min.
    // Android will automatically change
    // your frequency to 15 min
    // if you have configured a lower frequency.
    frequency: Duration(seconds: 15),
  );
  runApp(MyApp());
}

void callbackDispatcher(String message) {
  print("hiii");

  // Workmanager().executeTask((task, inputData) {
  // initialise the plugin of flutterlocalnotifications.
  FlutterLocalNotificationsPlugin flip =
  new FlutterLocalNotificationsPlugin();

  // app_icon needs to be a added as a drawable
  // resource to the Android head project.
  var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
  // var IOS = new IOSInitializationSettings();

  // initialise settings for both Android and iOS device.
  var settings = new InitializationSettings(android: android);
  flip.initialize(settings);
  _showNotificationWithDefaultSound(flip, message);
  // return Future.value(true);
  // });
}

Future _showNotificationWithDefaultSound(flip,String message) async {
// Show a notification after every 15 minute with the first
// appearance happening a minute after invoking the method
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your channel id', 'your channel name',
      importance: Importance.max, priority: Priority.high);

// initialise channel platform for both Android and iOS device.
  var platformChannelSpecifics =
  new NotificationDetails(android: androidPlatformChannelSpecifics);
  await flip.show(
      0,
      'REMINDER',
      message,
      platformChannelSpecifics,
      payload: 'Default_Sound');
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PaymentPage1(),
    );
  }
}


class PaymentPage1 extends StatefulWidget {
  @override
  State<PaymentPage1> createState() => _PaymentPage1State();
}
class _PaymentPage1State extends State<PaymentPage1> {
  String id_ = "";
  String idk_ = "";
  String namel_ = '';
  String place_ = '';
  String price_ = "";
  String photo_ = "";
  String phonenum = "";
  String category="";
  String location="";
  String phone="";
  String payid="";
  String worker="";

  Future<void> shared() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      phonenum = prefs.getString("phoneii1")!;
      id_ = prefs.getString("selectedAdId1")!;
      price_ = prefs.getString("price1")!;
      namel_ = prefs.getString("name1")!;
      photo_ = prefs.getString("photo1")!;
      phone=prefs.getString("phone1").toString();
      category=prefs.getString("category1").toString();
      location=prefs.getString("location1").toString();
      place_=prefs.getString("place1").toString();
      worker=prefs.getString("worker").toString();
      idk_=prefs.getString("completed").toString();
    });
  }

  Future<void> Addpayments() async {
    CollectionReference firbd = FirebaseFirestore.instance.collection("paymentsworker");
    CollectionReference firedk=FirebaseFirestore.instance.collection("completed");
    firedk.doc(idk_).update({"payment":"Paid"});

    DocumentReference firedj = FirebaseFirestore.instance.collection("advertisement").doc(id_);
    firbd.add({"amount": price_, "adreference": firedj, "paid to": worker,"payment id":payid, "Date":DateFormat.yMMMEd().format(DateTime.now()).toString(),"createdAt":FieldValue.serverTimestamp()});
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
            _buildDetailRow('phone', phone),
            _buildDetailRow('worker phone',worker),
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
                backgroundColor: Colors.blue,
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
    Navigator.push(context, MaterialPageRoute(builder: (context)=>Admin_dasboard()));
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
      payid=payurr!;
    });
    showAlertDialog(context, "Payment Successful", "Payment ID: ${response.paymentId}");
    Addpayments();
    Navigator.push(context, MaterialPageRoute(builder: (context)=>Admin_dasboard()));
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
