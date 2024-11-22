import 'dart:async';

import 'package:advertisement/payment%20history_worker.dart';
import 'package:advertisement/worker_ad_view.dart';
import 'package:advertisement/worker_changepassword.dart';
import 'package:advertisement/worker_edit%20profile.dart';
import 'package:advertisement/worker_view_Accepted%20work.dart';
import 'package:advertisement/worker_view_completed.dart';
import 'package:advertisement/worker_view_own_request.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import 'firebase_options.dart';
import 'login_new.dart';
Future<void> main() async {

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
  runApp(const MyApp());
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const WorkerHome(),
    );
  }
}

class WorkerHome extends StatefulWidget {
  const WorkerHome({super.key});

  @override
  State<WorkerHome> createState() => _WorkerHomeState();
}

class _WorkerHomeState extends State<WorkerHome> {
  String id = "";
  String photo = "";
  String qualification = "";
  String place = '';
  String name = "";
  String phone = "";
  String refer = "";
  String pass="";
  Timer? _timer;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    viewData();
    Paycheck();
    startPaymentCheckTimer();
  }

  Future<void> viewData() async {
    try {
      var prefs = await SharedPreferences.getInstance();
      CollectionReference firedb = FirebaseFirestore.instance.collection('workerdetails');
      // Ensure that 'lid' is not null before making a query
      if (prefs.getString("lid11").toString() != null) {
        QuerySnapshot querySnapshot = await firedb.where("phone", isEqualTo: prefs.getString('phonenum').toString()).get();
        final doc2=querySnapshot.docs.first.id;

        if (querySnapshot.docs.isNotEmpty) {
          final _doc = querySnapshot.docs;
          final d = _doc[0];

          setState(() {
            photo = d['photo'] ?? '';
            qualification = d["qualification"] ?? '';
            name = d['name'] ?? '';
            place = d['place'] ?? '';
            phone = d["phone"] ?? '';
            pass = d["password"] ?? '';
            id=doc2;
          });
        } else {
          // Handle case where no documents are found
          print("No user details found.");
        }
      } else {
        // Handle case where lid is null
        print("User lid not found in SharedPreferences.");
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }
  Future<void> Paycheck() async {
    var prefs = await SharedPreferences.getInstance();
    // Clear the last processed ID


    // Retrieve the last processed document ID
    String? lastProcessedId = prefs.getString("lastProcessedPaymentId");

    FirebaseFirestore.instance
        .collection("paymentsworker")
        .where("paid to", isEqualTo: prefs.get("phonenum").toString())
        .orderBy("createdAt", descending: true)
        .limit(1)
        .get()
        .then((snapshot) async {
      if (snapshot.docs.isNotEmpty) {
        var latestPaymentDoc = snapshot.docs.first;
        var latestPaymentId = latestPaymentDoc.id;

        // Check if this document has already been processed
        if (latestPaymentId == lastProcessedId) {
          print("No new payment document to process.........");
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
          if(s=="worker") {
            callbackDispatcher("\u20B9 :" + paymentAmount);
            await prefs.setString("lastProcessedPaymentId", latestPaymentId);
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
    const duration = Duration(seconds: 20); // Set the interval to 1 minute
    _timer = Timer.periodic(duration, (timer) {
      Paycheck(); // Call the Paycheck function periodically
    });
  }

  void stopPaymentCheckTimer() {
    _timer?.cancel(); // Stop the timer
    _timer = null;
  }
  @override
  void deactivate() {
    stopPaymentCheckTimer();
    _timer?.cancel();
    super.deactivate();
  }





  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
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
        body: SingleChildScrollView(
          child: Container(decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/back2.jpg"),fit: BoxFit.cover)),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
            children:  [SizedBox(height: 30,),
              Container(
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadiusDirectional.circular(16),border: Border.all(color: Colors.white,width: 1)),
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
                    Expanded(
                      child: AnimatedTextKit(repeatForever: false,
                        animatedTexts: [
                          TyperAnimatedText(
                            name.toUpperCase(),speed: Durations.medium2,
                            textStyle: GoogleFonts.dmSans(color: Colors.tealAccent,
                                fontSize: 18,
                                letterSpacing: 5,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                        onTap: () {
                          print("Tap Event");
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Card(elevation: 6,clipBehavior: Clip.antiAliasWithSaveLayer,
                  shape: CircleBorder(side: BorderSide(width: 2,color: Colors.tealAccent)),
                  child: CircleAvatar(
                    radius: 80,
                    backgroundImage: NetworkImage(
                      photo.isNotEmpty
                          ? photo
                          : 'https://via.placeholder.com/150', // Placeholder image if photo is empty
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Card(color: Colors.transparent,
                margin: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),side: BorderSide(color: Colors.white,width: 1)),
                elevation: 0,
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  child: Column(
                    children: [
                      ProfileDetailRow(
                          icon: Icons.business_outlined, label: "Qualification", value: qualification),
                      const Divider(),
                      ProfileDetailRow(
                          icon: Icons.phone_android_outlined, label: "Phone", value: phone),
                      const Divider(),
                      ProfileDetailRow(
                          icon: Icons.location_on_outlined, label: "Place", value: place),
                    ],
                  ),
                ),
              ),
              GridView.count(physics: NeverScrollableScrollPhysics(),
                mainAxisSpacing:0,
                crossAxisSpacing: 5,
                shrinkWrap: true,
                children: [
                  InkWell(onTap: () async {
                    SharedPreferences shiqq=await SharedPreferences.getInstance();
                    shiqq.setString("nameofworker", name);
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Workerview()));

                  },
                    child: Card(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25),side: BorderSide(width: 1,color: Colors.white)),
                      elevation: 0,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Padding(
                        padding: EdgeInsets.only(top: 15),
                        child: Column(
                          children: [
                            Icon(Icons.work_outline,size:30 ,color: Colors.tealAccent,),
                            Text(
                              "Works",
                              style: GoogleFonts.montserrat(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      color: Colors.transparent,
                    ),
                  ),
                  InkWell(onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>AcceptedW()));


                  },
                    child: Card(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25),side: BorderSide(color: Colors.white,width: 1)),
                      elevation: 0,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Padding(
                        padding: EdgeInsets.only(top: 15),
                        child: Column(
                          children: [

                            Icon(Icons.handshake_outlined,size:30 ,color: Colors.tealAccent,),
                            Text(
                              "Approved",
                              style: GoogleFonts.montserrat(fontSize: 13,fontWeight: FontWeight.bold,color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      color: Colors.transparent,
                    ),),
                  InkWell(onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>  BookedAdsW()));


                  },
                    child: Card(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25),side: BorderSide(color: Colors.white,width: 1)),
                      elevation: 0,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Padding(
                        padding: EdgeInsets.only(top: 15),
                        child: Column(
                          children: [
                            Icon(Icons.done_all_outlined,size:30 ,color: Colors.tealAccent,),
                            Text(
                              "Completed",
                              style: GoogleFonts.montserrat(fontSize: 12,fontWeight: FontWeight.bold,color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      color: Colors.transparent,
                    ),),
                  InkWell(onTap: () async {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>payhisW()));

                  },
                    child: Card(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25),side: BorderSide(color: Colors.white,width: 1)),
                      elevation: 0,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Padding(
                        padding: EdgeInsets.only(top: 15),
                        child: Column(
                          children: [

                            Icon(Icons.history,size:30 ,color: Colors.tealAccent,),
                            Text(
                              "Payment",
                              style: GoogleFonts.montserrat(fontSize: 12,fontWeight: FontWeight.bold,color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      color: Colors.transparent,
                    ),),
                ],
                crossAxisCount: 4,
              ),
              Container(height: 370,
                child: ListView(physics: NeverScrollableScrollPhysics(),
                  children: [
                    _createTile(context, "View My Work Request", Icons.work, _viewWorkRequest),
                    _createTile(context, "Change Password", Icons.password_outlined, _changepassword),
                    _createTile(context, "Edit profile", Icons.edit, _editprofile),
                    _createTile(context, "Logout", Icons.logout, _logout),

                  ],
                ),
              ),


                ],
              ),
            ),
          ),
        ),
      ),
    );

  }
  void _viewWorkRequest(BuildContext context) {
    // Navigate to View Work Request page
    Navigator.push(context, MaterialPageRoute(builder: (context) => WorkerViewOwnRequest()));
  }
  Future<void> _editprofile(BuildContext context) async {
    SharedPreferences sh1 = await SharedPreferences.getInstance();
    sh1.setString("id1", id);
    sh1.setString("business1", qualification);
    sh1.setString("place1", place);
    sh1.setString("name1", name);
    sh1.setString("phone1", phone);
    sh1.setString("photo1", photo);
    sh1.setString("password1", pass);
    print(id);
    print(photo);
    Navigator.push(context, MaterialPageRoute(builder: (context)=>  worker_edit()));
  }
  Future<void> _changepassword(BuildContext context) async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    sh.setString("id", id);
    sh.setString("business", qualification);
    sh.setString("place", place);
    sh.setString("name", name);
    sh.setString("phone", phone);
    sh.setString("photo", photo);
    sh.setString("password", pass);
    // Navigate to View Work Request page
    Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePasswordPagew()));
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
                SharedPreferences shred=await SharedPreferences.getInstance();
                shred.setString("type", "").toString();
                // Close the dialog
                // Proceed with the logout action
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
  Widget _createTile(BuildContext context, String title, IconData icon, Function onPressed) {
    return Card(clipBehavior: Clip.antiAliasWithSaveLayer,
      color: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25),side: BorderSide(color: Colors.white,width: 1)),
      elevation: 0,
      margin: EdgeInsets.symmetric(vertical: 10), // Reduce vertical margin
      child: InkWell(
        onTap: () => onPressed(context),
        child: Padding(
          padding:  EdgeInsets.all(18.0), // Reduce padding
          child: Row(
            children: [
              Icon(icon, size: 25, color: Colors.tealAccent), // Reduced icon size
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Reusable Widget for Profile Details
class ProfileDetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const ProfileDetailRow({
    required this.icon,
    required this.label,
    required this.value,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.tealAccent),
        const SizedBox(width: 10),
        Text(
          "$label:".toUpperCase(),
          style: GoogleFonts.montserrat(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: GoogleFonts.dmSans(
            fontSize: 12,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

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
