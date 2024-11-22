// import 'package:advertisement/worker_ad_view.dart';
// import 'package:advertisement/worker_dash.dart';
// import 'package:advertisement/worker_home.dart';
// import 'package:advertisement/worker_view_Accepted%20work.dart';
// import 'package:advertisement/worker_view_completed.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'firebase_options.dart';
//
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: BottomNavExampleW(),
//       theme: ThemeData(
//         textTheme: GoogleFonts.poppinsTextTheme(), // Modern typography
//       ),
//     );
//   }
// }
//
// class BottomNavExampleW extends StatefulWidget {
//   @override
//   _BottomNavExampleWState createState() => _BottomNavExampleWState();
// }
//
// class _BottomNavExampleWState extends State<BottomNavExampleW> {
//   int _currentIndex = 0;
//
//   // List of screens that will be displayed when an icon is selected
//   final List<Widget> _screens = [
//     Workerview(),
//     WorkerHome(),
//    AcceptedW(),
//     BookedAdsW(),
//   WorkerDash(),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _screens[_currentIndex], // Show the selected screen
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _currentIndex, // Current selected item
//         onTap: (index) {
//           setState(() {
//             _currentIndex = index; // Change the selected index
//           });
//         },
//         type: BottomNavigationBarType.fixed, // Fix for 6 items
//         backgroundColor: Colors.white, // Minimal background
//         elevation: 10,
//         selectedItemColor: Colors.teal, // Color for selected icon
//         unselectedItemColor: Colors.grey, // Color for unselected icons
//         selectedFontSize: 12, // Hint text size for selected
//         unselectedFontSize: 12, // Hint text size for unselected
//         items: [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home_outlined),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: 'Profile',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.pending),
//             label: 'Works',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.done_all),
//             label: 'Completed',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.more_horiz_outlined),
//             label: 'More',
//           ),
//         ],
//         selectedLabelStyle: GoogleFonts.montserrat(
//           fontSize: 12,
//           fontWeight: FontWeight.w500,
//           color: Colors.teal,
//         ),
//         unselectedLabelStyle: GoogleFonts.montserrat(
//           fontSize: 12,
//           fontWeight: FontWeight.w500,
//           color: Colors.grey,
//         ),
//       ),
//     );
//   }
// }
