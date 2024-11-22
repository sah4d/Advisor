// import 'package:advertisement/Accepted%20works.dart';
// import 'package:advertisement/Admin_login.dart';
// import 'package:advertisement/Worker_login.dart';
// import 'package:advertisement/ad_spots.dart';
// import 'package:advertisement/admin_view_work_requests.dart';
// import 'package:advertisement/login_new.dart';
// import 'package:advertisement/worker_view_own_request.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// class WorkerDash extends StatelessWidget {
//   WorkerDash({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(onWillPop: () async{
//       return false;
//
//     },
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text("Worker Dashboard", style: GoogleFonts.montserrat(fontSize: 24, color: Colors.black87)),
//           backgroundColor: Colors.tealAccent,
//           centerTitle: true,
//           automaticallyImplyLeading: false,
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: ListView(
//             children: [
//               _createTile(context, "View My Work Request", Icons.work, _viewWorkRequest),
//               _createTile(context, "Logout", Icons.logout, _logout),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _createTile(BuildContext context, String title, IconData icon, Function onPressed) {
//     return Card(
//       color: Colors.tealAccent,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       elevation: 5,
//       margin: EdgeInsets.symmetric(vertical: 10), // Reduce vertical margin
//       child: InkWell(
//         onTap: () => onPressed(context),
//         child: Padding(
//           padding:  EdgeInsets.all(18.0), // Reduce padding
//           child: Row(
//             children: [
//               Icon(icon, size: 30, color: Colors.teal), // Reduced icon size
//               SizedBox(width: 16),
//               Expanded(
//                 child: Text(
//                   title,
//                   style: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _addAds(BuildContext context) {
//     // Navigate to Add Ads page
//     Navigator.push(context, MaterialPageRoute(builder: (context) => Ad_spot()));
//   }
//
//   void _viewWorkRequest(BuildContext context) {
//     // Navigate to View Work Request page
//     Navigator.push(context, MaterialPageRoute(builder: (context) => WorkerViewOwnRequest()));
//   }
//
//   void _viewAcceptedWorks(BuildContext context) {
//     // Navigate to Accepted Works page
//     Navigator.push(context, MaterialPageRoute(builder: (context) => Accepted()));
//   }
//
//   void _logout(BuildContext context) {
//     Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
//
//     // Implement your logout functionality here/ For now, just go back
//   }
// }
//
// // Dummy pages for navigation
//
// class ViewWorkRequestPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("View Work Request")),
//       body: Center(child: Text("View Work Request Page")),
//     );
//   }
// }
//
// class AcceptedWorksPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Accepted Works")),
//       body: Center(child: Text("Accepted Works Page")),
//     );
//   }
// }