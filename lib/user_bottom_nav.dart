import 'package:advertisement/User_view_completed.dart';
import 'package:advertisement/ad_booked_user.dart';
import 'package:advertisement/ad_view.dart';
import 'package:advertisement/user_dash.dart';
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
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BottomNavExampleU(),
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(), // Modern typography
      ),
    );
  }
}

class BottomNavExampleU extends StatefulWidget {
  @override
  _BottomNavExampleUState createState() => _BottomNavExampleUState();
}

class _BottomNavExampleUState extends State<BottomNavExampleU> {
  int _currentIndex = 0;

  // List of screens that will be displayed when an icon is selected
  final List<Widget> _screens = [
    ViewAds(),
    BookedAds(),
    UserHome(),
    BookedAdsU(),
    // UserDash()
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
        backgroundColor: Colors.white, // Minimal background
        elevation: 10,
        selectedItemColor: Colors.teal, // Color for selected icon
        unselectedItemColor: Colors.grey, // Color for unselected icons
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
            label: 'Profile',
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
