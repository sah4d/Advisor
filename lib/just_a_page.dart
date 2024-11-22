// import 'package:advertisement/Admin_login.dart';
// import 'package:advertisement/user_home.dart';
// import 'package:flutter/material.dart';
//
// import 'Accepted works.dart';
// import 'ad_booked_user.dart';
// import 'ad_view.dart';
// import 'admin_tab.dart';
// import 'admin_view_completed.dart';
// import 'admin_view_users.dart';
// import 'admin_view_workers.dart';
// void main(){
//   runApp(just());
//
// }
// class just extends StatelessWidget {
//   const just({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//     );
//   }
// }
// class JustAPage extends StatefulWidget {
//   const JustAPage({super.key});
//
//   @override
//   State<JustAPage> createState() => _JustAPageState();
// }
//
// class _JustAPageState extends State<JustAPage> {
//
//   _JustAPageState(){
//
//   }
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Container(
//         child: DefaultTabController(
//           length: 3,
//           child: Scaffold(
//             appBar: AppBar(
//               title: Text("Dashboard"),
//               centerTitle: true,
//               bottom: TabBar(
//                 indicatorColor: Colors.black,
//                 indicatorWeight: 3,
//                 labelColor: Colors.black,
//                 unselectedLabelColor: Colors.grey,
//                 tabs: [
//                   Tab(icon: Icon(Icons.view_agenda_outlined)),
//                   Tab(icon: Icon(Icons.add)),
//                   Tab(icon: Icon(Icons.book)),
//                 ],
//               ),
//             ),
//             body: TabBarView(
//               children: [
//                 ViewAds(context),
//                 BookedAds(context),
//                 UserHome(context),
//               ],
//             ),
//             drawer: CustomDrawer(), // Adding the custom drawer
//           ),
//         ),
//       ),
//     );
//   }
// }
