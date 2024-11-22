import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:advertisement/Bottom_nav_history.dart';
import 'package:advertisement/admin_ad_view.dart';
import 'package:advertisement/admin_booked_ads.dart';
import 'package:advertisement/admin_view_completed.dart';
import 'package:advertisement/admin_view_users.dart';
import 'package:advertisement/admin_view_workers.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

import 'Accepted works.dart';
import 'ad_spots.dart';
import 'admin_view_work_requests.dart';
import 'firebase_options.dart';
import 'login_new.dart';

Future<void> main() async {
  runApp(test1());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
      'PAYMENT RECEIVED',
      message,
      platformChannelSpecifics,
      payload: 'Default_Sound');
}

class test1 extends StatelessWidget {
  const test1({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Admin_dasboard(),
    );
  }
}

class Admin_dasboard extends StatefulWidget {
  const Admin_dasboard({super.key});

  @override
  State<Admin_dasboard> createState() => _Admin_dasboardState();
}

class _Admin_dasboardState extends State<Admin_dasboard> {
  Timer? _timer; // Timer variable
  _Admin_dasboardState() {
    collect1();
  }
  String adcount = "";
  String completedw = "";
  String usercount = "";
  String workercount = "";
  String workrequests = "";
  String bookedads = "";
  Timer? _timer1;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    // Set up a timer to call collect1() every 10 seconds
    _timer = Timer.periodic(Duration(seconds: 10), (Timer t) => collect1());
    Paycheck();
    startPaymentCheckTimer();
  }

  Future<void> collect1() async {
    CollectionReference adsRef =
        FirebaseFirestore.instance.collection("advertisement");
    CollectionReference adsRef1 =
        FirebaseFirestore.instance.collection("completed");
    CollectionReference adsRef2 =
        FirebaseFirestore.instance.collection("userdetails");
    CollectionReference adsRef3 =
        FirebaseFirestore.instance.collection("workerdetails");
    CollectionReference adsRef4 =
        FirebaseFirestore.instance.collection("requests");
    QuerySnapshot qr1 = await adsRef4.get();
    QuerySnapshot querySnapshot = await adsRef
        .where("status", isEqualTo: "Booked")
        .where("assigned", isEqualTo: "requested")
        .get();
    QuerySnapshot querySnapshot1 = await adsRef
        .where("status", isEqualTo: "Booked")
        .where("assigned", isEqualTo: "pending")
        .get();
    QuerySnapshot qd = await adsRef.get();
    QuerySnapshot qd1 = await adsRef1.get();
    QuerySnapshot qd2 = await adsRef2.get();
    QuerySnapshot qd3 = await adsRef3.get();
    final dataii = qd.docs;
    final dataii2 = qd1.docs;
    final dataii3 = qd2.docs;
    final dataii4 = qd3.docs;
    final dataii5 = querySnapshot.docs;
    final dataii6 = querySnapshot1.docs;
    final dataii7 = qr1.docs;
    print(dataii.length);
    setState(() {
      adcount = dataii.length.toString();
      completedw = dataii2.length.toString();
      usercount = dataii3.length.toString();
      workercount = dataii4.length.toString();
      workrequests = dataii5.length.toString();
      workrequests = dataii7.length.toString();
      bookedads = dataii6.length.toString();
    });
  }
  Future<void> Paycheck() async {
    var prefs = await SharedPreferences.getInstance();
    // Clear the last processed ID
    // Retrieve the last processed document ID
    String? lastProcessedId = prefs.getString("lastProcessedPaymentId1");


    // Fluttertoast.showToast(msg: "hiiiiii"+lastProcessedId.toString());


    FirebaseFirestore.instance
        .collection("payments")
        .orderBy("createdAt", descending: true)
        .limit(1)
        .get()
        .then((snapshot) async {
      if (snapshot.docs.isNotEmpty) {
        var latestPaymentDoc = snapshot.docs.first;
        var latestPaymentId = latestPaymentDoc.id;

        // Check if this document has already been processed
        if (latestPaymentId == lastProcessedId) {
          print("No new payment document to process.");
          return;
        }

        var latestPayment = latestPaymentDoc.data();
        if (latestPayment.containsKey('amount') && latestPayment.containsKey('createdAt')) {
          // Extract fields
          var paymentAmount = latestPayment['amount'];
          var createdAtTimestamp = latestPayment['createdAt'];

          // Convert createdAt to string
          var createdAtString = createdAtTimestamp is Timestamp
              ? createdAtTimestamp.toDate().toString()
              : createdAtTimestamp.toString();

          // Store in strings
          String paymentDetails = 'Amount: $paymentAmount, Date: $createdAtString';

          print(paymentDetails);
          String? s= await prefs.getString("type");
          if(s=="admin") {
            callbackDispatcher("\u20B9 :" + paymentAmount);
            await prefs.setString("lastProcessedPaymentId1", latestPaymentId);
          }

          // Save the processed document ID

        } else {
          print('The "amount" or "createdAt" field is missing in the document.');
        }
      } else {
        print('No documents found for the given phone.');
      }
    }).catchError((error) {
      print('Error fetching payment data: $error');
    });
  }
  void startPaymentCheckTimer() {
    const duration = Duration(seconds: 30); // Set the interval to 1 minute
    _timer1 = Timer.periodic(duration, (timer) {



      Paycheck(); // Call the Paycheck function periodically
    });
  }

  void stopPaymentCheckTimer() {
    _timer1?.cancel(); // Stop the timer
    _timer1 = null;
  }


  @override
  void deactivate() {
    _timer?.cancel();
  stopPaymentCheckTimer();
    super.deactivate();
  }
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool exitApp = await _showExitDialog(context);
        if (exitApp) {
          SystemNavigator.pop();  // Exit the app
        }
        return false;

      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          height: MediaQuery.of(context).size.height*1,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/back2.jpg"), fit: BoxFit.cover)),
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadiusDirectional.circular(16),border: Border.all(width: 1,color: Colors.white)),
                  height: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(width: 20.0, height: 100.0),
                      Text(
                        'WELCOME BACK',
                        style: GoogleFonts.dmSans(fontSize: 20,color: Colors.white),
                      ),
                      SizedBox(width: 20.0, height: 100.0),
                      AnimatedTextKit(
                        repeatForever: true,
                        animatedTexts: [
                          WavyAnimatedText(
                            "ADMIN",
                            textStyle: GoogleFonts.dmSans(color: Colors.cyanAccent,
                                fontSize: 20,
                                letterSpacing: 5,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 40,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: AnimatedTextKit(repeatForever: true, animatedTexts: [
                    FadeAnimatedText(
                      "STANDOUT",
                      textStyle: GoogleFonts.dmSans(color: Colors.cyanAccent,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 5),
                    ),
                    FadeAnimatedText(
                      "YOUR",
                      textStyle: GoogleFonts.dmSans(color: Colors.cyanAccent,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 5),
                    ),
                    FadeAnimatedText(
                      "PRODUCT",
                      textStyle: GoogleFonts.dmSans(color: Colors.cyanAccent,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 5),
                    ),
                    FadeAnimatedText(
                      "WITH",
                      textStyle: GoogleFonts.dmSans(color: Colors.cyanAccent,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 5),
                    ),
                    FadeAnimatedText(
                      "AD-VISOR",
                      textStyle: GoogleFonts.dmSans(color: Colors.cyanAccent,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 5),
                    ),
                  ]),
                ),
              ),
              GridView.count(
                physics: NeverScrollableScrollPhysics(),
                mainAxisSpacing: 2,
                crossAxisSpacing: 5,
                shrinkWrap: true,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ViewUsers()));
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: BorderSide(color: Colors.white, width: 1)),
                      elevation: 0,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: Column(
                          children: [
                            Text(
                              usercount,
                              style: GoogleFonts.teko(
                                  fontSize: 25, color: Colors.white),
                            ),
                            Icon(
                              Icons.person,color: Colors.white,
                              size: 30,
                            ),
                            Text(
                              "Users",
                              style: GoogleFonts.montserrat(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      color: Colors.transparent,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AdminViewWorkers()));
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: BorderSide(color: Colors.white, width: 1)),
                      elevation: 0,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: Column(
                          children: [
                            Text(
                              workercount,
                              style: GoogleFonts.teko(
                                  fontSize: 25, color: Colors.white),
                            ),
                            Icon(
                              Icons.home_repair_service,color: Colors.white,
                              size: 30,
                            ),
                            Text(
                              "Workers",
                              style: GoogleFonts.montserrat(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      color: Colors.transparent,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AdminViewCompleted()));
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: BorderSide(color: Colors.white, width: 1)),
                      elevation: 0,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: Column(
                          children: [
                            Text(
                              completedw,
                              style: GoogleFonts.teko(
                                  fontSize: 25, color: Colors.white),
                            ),
                            Icon(
                              Icons.done_all_outlined,color: Colors.white,
                              size: 30,
                            ),
                            Text(
                              "Completed",
                              style: GoogleFonts.montserrat(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      color: Colors.transparent,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ViewWorkRequests()));
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: BorderSide(color: Colors.white, width: 1)),
                      elevation: 0,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: Column(
                          children: [
                            Text(
                              workrequests,
                              style: GoogleFonts.teko(
                                  fontSize: 25, color: Colors.white),
                            ),
                            Icon(
                              Icons.notifications_active_outlined,color:Colors.white,
                              size: 30,
                            ),
                            Text(
                              "Requests",
                              style: GoogleFonts.montserrat(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      color: Colors.transparent,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AdminBookedAds()));
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: BorderSide(color: Colors.white, width: 1)),
                      elevation: 0,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.002),
                        child: Column(
                          children: [
                            Text(
                              bookedads,
                              style: GoogleFonts.teko(
                                  fontSize: 25, color: Colors.white),
                            ),
                            Icon(
                              Icons.bookmark_added_outlined,color: Colors.white,
                              size: 30,
                            ),
                            Text(
                              "Booked Ads",
                              style: GoogleFonts.montserrat(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      color: Colors.transparent,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ViewAdsA()));
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: BorderSide(color: Colors.white, width: 1)),
                      elevation: 0,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: Column(
                          children: [
                            Text(
                              adcount,
                              style: GoogleFonts.teko(
                                  fontSize: 25, color: Colors.white),
                            ),
                            Icon(
                              Icons.leaderboard_outlined,color: Colors.white,
                              size: 30,
                            ),
                            Text(
                              "Total Ads",
                              style: GoogleFonts.montserrat(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      color: Colors.transparent,
                    ),
                  ),
                ],
                crossAxisCount: 3,
              ),
              Container(
                height: MediaQuery.of(context).size.height*0.44,
                child: ListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    _createTile(context, "Payment History",
                        Icons.history_sharp, _history),
                    _createTile(context, "Add Ads", Icons.add, _addAds),
                    _createTile(context, "Accepted Works", Icons.check_circle,
                        _viewAcceptedWorks),
                    _createTile(context, "Logout", Icons.logout, _logout),
                  ],
                ),
                // height: 500,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _createTile(
      BuildContext context, String title, IconData icon, Function onPressed) {
    return Card(color: Colors.transparent,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      // color: Colors.tealAccent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15),side: BorderSide(width: 1,color: Colors.white)),
      elevation:0,
      margin: EdgeInsets.symmetric(vertical: 10), // Reduce vertical margin
      child: InkWell(
        onTap: () => onPressed(context),
        child: Padding(
          padding: EdgeInsets.all(18.0), // Reduce padding
          child: Row(
            children: [
              Icon(
                icon,
                size: 30,color: Colors.white,
              ), // Reduced icon size
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.montserrat(color: Colors.white,
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addAds(BuildContext context) {
    // Navigate to Add Ads page
    Navigator.push(context, MaterialPageRoute(builder: (context) => Ad_spot()));
  }

  void _history(BuildContext context) {
    // Navigate to Add Ads page
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => bottom_navigation()));
  }

  void _viewAcceptedWorks(BuildContext context) {
    // Navigate to Accepted Works page
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Accepted()));
  }
  void _logout(BuildContext context) {
    // Show a confirmation dialog before logging out
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Log Out'),
          content: Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();  // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                stopPaymentCheckTimer();
                deactivate();
                // Close the dialog
                // Proceed with the logout action
                SharedPreferences shred=await SharedPreferences.getInstance();
                shred.setString("type", "").toString();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                );
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  Future<bool> _showExitDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Exit App'),
          content: Text('Are you sure you want to exit the app?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);  // Don't exit
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);  // Exit the app
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    ) ?? false;  // Default to false if dialog is dismissed without an option
  }
}
