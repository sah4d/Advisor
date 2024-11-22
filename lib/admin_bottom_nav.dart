import 'package:advertisement/admin_ad_view.dart';
import 'package:advertisement/admin_booked_ads.dart';
import 'package:advertisement/admin_dash.dart';
import 'package:advertisement/admin_view_completed.dart';
import 'package:advertisement/admin_view_users.dart';
import 'package:advertisement/admin_view_workers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BottomNavExample(),
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(), // Modern typography
      ),
    );
  }
}

class BottomNavExample extends StatefulWidget {
  @override
  _BottomNavExampleState createState() => _BottomNavExampleState();
}

class _BottomNavExampleState extends State<BottomNavExample> {
  int _currentIndex = 0;

  // List of screens that will be displayed when an icon is selected
  final List<Widget> _screens = [
   ViewAdsA(),
  AdminBookedAds(),
   ViewUsers(),
    AdminViewWorkers(),
    AdminViewCompleted(),
    // AdminDashboard(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex], // Show the selected screen
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex, // Current selected item
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Change the selected index
          });
        },
        type: BottomNavigationBarType.fixed, // Fix for 6 items
        backgroundColor: Colors.white30, // Minimal background
        elevation: 10,
        selectedItemColor: Colors.teal, // Color for selected icon
        unselectedItemColor: Colors.black, // Color for unselected icons
        selectedFontSize: 12, // Hint text size for selected
        unselectedFontSize: 12, // Hint text size for unselected
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Booked',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Users',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: 'Workers',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.done_all),
            label: 'Completed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz_outlined),
            label: 'More',
          ),
        ],
        selectedLabelStyle: GoogleFonts.montserrat(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Colors.teal,
        ),
        unselectedLabelStyle: GoogleFonts.montserrat(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Colors.grey,
        ),
      ),
    );
  }
}
