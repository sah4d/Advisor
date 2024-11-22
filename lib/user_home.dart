import 'package:advertisement/User_view_completed.dart';
import 'package:advertisement/payment%20history_user.dart';
import 'package:advertisement/user_changepassword.dart';
import 'package:advertisement/user_editprofile.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ad_booked_user.dart';
import 'ad_view.dart';
import 'firebase_options.dart';
import 'login_new.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const UserHome(), // Removed passing context to UserHome
    );
  }
}

class UserHome extends StatefulWidget {
  const UserHome({super.key}); // Removed context from constructor

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  String id = "";
  String photo = "";
  String business = "";
  String place = '';
  String name = "";
  String phone = "";
  String refer = "";
  String pass = "";

  @override
  void initState() {
    super.initState();
    viewData();
  }

  Future<void> viewData() async {
    try {
      var prefs = await SharedPreferences.getInstance();
      CollectionReference firedb = FirebaseFirestore.instance.collection('userdetails');
      // Ensure that 'lid' is not null before making a query
      if (prefs.getString("lid11").toString() != null) {
        QuerySnapshot querySnapshot = await firedb
            .where("phone", isEqualTo: prefs.getString('lid11').toString())
            .get();
        final doc2 = querySnapshot.docs.first.id;

        if (querySnapshot.docs.isNotEmpty) {
          final _doc = querySnapshot.docs;
          final d = _doc[0];

          setState(() {
            photo = d['photo'] ?? '';
            business = d["buisness"] ?? '';
            name = d['name'] ?? '';
            place = d['place'] ?? '';
            phone = d["phone"] ?? '';
            pass = d["password"] ?? '';
            id = doc2;
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
        backgroundColor: const Color(0xFFF7F7F7),
        body: SingleChildScrollView(
          child: Container(decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/pro.jpg"),fit: BoxFit.cover)),
            child: Padding(
              padding:  EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadiusDirectional.circular(16),border: Border.all(width: 1,color:Colors.white )),
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
                            child: AnimatedTextKit(repeatForever: true,
                              animatedTexts: [
                                TyperAnimatedText(
                                  name.toUpperCase(),speed: Durations.medium2,
                                  textStyle: GoogleFonts.dmSans(color: Colors.cyanAccent,
                                      fontSize: 18,
                                      letterSpacing: 5,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                              onTap: () {
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Name
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Card(elevation: 6,clipBehavior: Clip.antiAliasWithSaveLayer,
                      shape: CircleBorder(side: BorderSide(width: 2,color: Colors.cyanAccent)),
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
                  SizedBox(height: 4),
                  // Business, Phone, etc.
                  Card(color: Colors.transparent,
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),side: BorderSide(width: 1,color: Colors.white)),
                    elevation: 0,
                    child: Padding(
                      padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                      child: Column(
                        children: [
                          ProfileDetailRow(
                              icon: Icons.business_outlined, label: "Business", value: business),
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
                  SizedBox(height: MediaQuery.of(context).size.height*0.00000010),
                  GridView.count(
                    physics: NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5,
                    shrinkWrap: true,
                    children: [
                      InkWell(onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewAds()));
          
                      },
                        child: Card(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25),side: BorderSide(color: Colors.white,width: 1)),
                          elevation: 0,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: Padding(
                            padding: EdgeInsets.only(top: 15),
                            child: Column(
                              children: [
                                Icon(Icons.event_available_outlined,size:30 ,color: Colors.cyanAccent,),
                                Text(
                                  "Ads",
                                  style: GoogleFonts.montserrat(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          color: Colors.transparent,
                        ),
                      ),
                      InkWell(onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>BookedAds()));
          
          
                      },
                        child: Card(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25),side: BorderSide(color: Colors.white,width: 1)),
                          elevation: 0,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: Padding(
                            padding: EdgeInsets.only(top: 15),
                            child: Column(
                              children: [
          
                                Icon(Icons.bookmark_added_outlined,size:30 ,color: Colors.cyanAccent,),
                                Text(
                                  "Bookings",
                                  style: GoogleFonts.montserrat(fontSize: 13,fontWeight: FontWeight.bold,color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          color: Colors.transparent,
                        ),),
                      InkWell(onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>BookedAdsU()));
          
          
                      },
                        child: Card(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25),side: BorderSide(color: Colors.white,width: 1)),
                          elevation: 0,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: Padding(
                            padding: EdgeInsets.only(top: 15),
                            child: Column(
                              children: [
                                Icon(Icons.done_all_outlined,size:30 ,color: Colors.cyanAccent,),
                                Text(
                                  "Completed",
                                  style: GoogleFonts.montserrat(fontSize: 11,fontWeight: FontWeight.bold,color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          color: Colors.transparent,
                        ),),
                      InkWell(onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>payhisU()));
          
                      },
                        child: Card(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25),side: BorderSide(color: Colors.white,width: 1)),
                          elevation: 0,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: Padding(
                            padding: EdgeInsets.only(top: 15),
                            child: Column(
                              children: [
          
                                Icon(Icons.history,size:30 ,color: Colors.cyanAccent,),
                                Text(
                                  "History",
                                  style: GoogleFonts.montserrat(fontSize: 15,fontWeight: FontWeight.bold,color:Colors.white ),
                                ),
                              ],
                            ),
                          ),
                          color: Colors.transparent,
                        ),),
                    ],
                    crossAxisCount: 4,
                  ),
                  Container(
                    height: 300,
                    child: ListView(physics: NeverScrollableScrollPhysics(),
                      children: [ _createTile(context, "Edit Profile", Icons.edit,_editprofile ),
                        _createTile(context, "Change Password", Icons.password_outlined, _changepassword),
                        _createTile(context, "Logout", Icons.logout, _logout),
          
                      ],
                    ),
                  ),
                  // Edit & Next Buttons
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _createTile(BuildContext context, String title, IconData icon, Function onPressed) {
    return Card(clipBehavior: Clip.antiAliasWithSaveLayer,
      color: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25),side: BorderSide(width: 1,color: Colors.white)),
      elevation: 0,
      margin: EdgeInsets.symmetric(vertical: 10), // Reduce vertical margin
      child: InkWell(
        onTap: () => onPressed(context),
        child: Padding(
          padding:  EdgeInsets.all(18.0), // Reduce padding
          child: Row(
            children: [
              Icon(icon, size: 30, color: Colors.cyanAccent), // Reduced icon size
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
                SharedPreferences shred=await SharedPreferences.getInstance();
                shred.setString("type", "").toString();// Close the dialog
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
  Future<void> _editprofile(BuildContext context) async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    sh.setString("id", id);
    sh.setString("business", business);
    sh.setString("place", place);
    sh.setString("name", name);
    sh.setString("phone", phone);
    sh.setString("photo", photo);
    sh.setString("password", pass);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => user_edit()));


    // Implement your logout functionality here/ For now, just go back
  }
  Future<void> _changepassword(BuildContext context) async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    sh.setString("id", id);
    sh.setString("business", business);
    sh.setString("place", place);
    sh.setString("name", name);
    sh.setString("phone", phone);
    sh.setString("photo", photo);
    sh.setString("password", pass);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChangePasswordPage()));

    // Implement your logout functionality here/ For now, just go back
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
        Icon(icon, color: Colors.cyanAccent
        ),
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
