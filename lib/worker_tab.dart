// import 'package:advertisement/worker_ad_view.dart';
// import 'package:advertisement/worker_home.dart';
// import 'package:advertisement/worker_view_Accepted%20work.dart';
// import 'package:advertisement/worker_view_completed.dart';
// import 'package:advertisement/worker_view_own_request.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// import 'firebase_options.dart';
//
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   runApp(WorkerTap());
// }
//
// class WorkerTap extends StatefulWidget {
//   const WorkerTap({super.key});
//
//   @override
//   _WorkerTapState createState() => _WorkerTapState();
// }
//
// class _WorkerTapState extends State<WorkerTap> {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData(
//         textTheme: GoogleFonts.poppinsTextTheme(), // Adding modern typography
//         primaryColor: Colors.black,
//         scaffoldBackgroundColor: Colors.white,
//         appBarTheme: AppBarTheme(
//           elevation: 0, // Flat, no shadows
//           backgroundColor: Colors.white,
//           iconTheme: IconThemeData(color: Colors.black),
//           titleTextStyle: TextStyle(
//             color: Colors.black,
//             fontSize: 18,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ),
//       home: DefaultTabController(
//         length: 2,
//         child: Scaffold(
//           appBar: AppBar(
//             title: Text("Dashboard"),
//             centerTitle: true,
//             bottom: TabBar(
//               indicatorColor: Colors.black,
//               indicatorWeight: 2,
//               labelColor: Colors.black,
//               unselectedLabelColor: Colors.grey,
//               tabs: [
//                 Tab(icon: Icon(Icons.view_agenda_outlined)),
//                 Tab(icon: Icon(Icons.add)),
//               ],
//             ),
//           ),
//           body: TabBarView(
//             children: [
//               Workerview(),
//               WorkerHome(),
//             ],
//           ),
//           drawer: CustomDrawer(), // Adding the custom drawer
//         ),
//       ),
//     );
//   }
// }
//
// class CustomDrawer extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: <Widget>[
//           DrawerHeader(
//             decoration: BoxDecoration(
//               color: Colors.black,
//             ),
//             child: Center(
//               child: Text(
//                 'Menu',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//           ListTile(
//             leading: Icon(Icons.home, color: Colors.black),
//             title: Text('Home'),
//             onTap: () {
//               Navigator.pop(context);
//               // Navigate to Home
//             },
//           ),
//           ListTile(
//             leading: Icon(Icons.view_agenda_outlined, color: Colors.black),
//             title: Text('View work requests'),
//             onTap: () {
//               Navigator.push(context, MaterialPageRoute(builder: (context) => WorkerViewOwnRequest()));
//               // Navigate to View work requests
//             },
//           ),
//           ListTile(
//             leading: Icon(Icons.book, color: Colors.black),
//             title: Text('Accepted requests'),
//             onTap: () {
//               Navigator.push(context, MaterialPageRoute(builder: (context) => AcceptedW()));
//               // Navigate to Accepted requests
//             },
//           ),
//           ListTile(
//             leading: Icon(Icons.checklist_outlined, color: Colors.black),
//             title: Text('Completed works'),
//             onTap: () {
//               Navigator.push(context, MaterialPageRoute(builder: (context) => BookedAdsW()));
//               // Navigate to Completed works
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
