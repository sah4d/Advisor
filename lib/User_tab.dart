
import 'package:advertisement/User_view_completed.dart';
import 'package:advertisement/user_home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(Tab11());
}

class Tab11 extends StatefulWidget {
  const Tab11({super.key});

  @override
  _Tab11State createState() => _Tab11State();
}

class _Tab11State extends State<Tab11> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(), // Adding modern typography
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          elevation: 0, // Flat, no shadows
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Dashboard"),
            centerTitle: true,
            bottom: TabBar(
              indicatorColor: Colors.black,
              indicatorWeight: 3,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(icon: Icon(Icons.view_agenda_outlined)),
                Tab(icon: Icon(Icons.add)),
                Tab(icon: Icon(Icons.book)),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              UserHome(),
            ],
          ),
          drawer: CustomDrawer(), // Adding the custom drawer
        ),
      ),
    );
  }
}

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.black,
            ),
            child: Center(
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home, color: Colors.black),
            title: Text('View my works'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>BookedAdsU()));
              // Navigate to Home
            },
          ),
          ListTile(
            leading: Icon(Icons.view_agenda_outlined, color: Colors.black),
            title: Text('View Ads'),
            onTap: () {
              Navigator.pop(context);
              // Navigate to View Ads
            },
          ),
          ListTile(
            leading: Icon(Icons.book, color: Colors.black),
            title: Text('Booked Ads'),
            onTap: () {
              Navigator.pop(context);
              // Navigate to Booked Ads
            },
          ),
          ListTile(
            leading: Icon(Icons.settings, color: Colors.black),
            title: Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              // Navigate to Settings
            },
          ),
        ],
      ),
    );
  }
}
