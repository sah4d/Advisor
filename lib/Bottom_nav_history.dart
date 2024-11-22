import 'package:advertisement/payment_history_user_admin.dart';
import 'package:advertisement/payment_history_worker_admin.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
void main(){

}
class bottom_nav extends StatelessWidget {
  const bottom_nav({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
    );
  }
}
class bottom_navigation extends StatefulWidget {
  const bottom_navigation({super.key});

  @override
  State<bottom_navigation> createState() => _bottom_navigationState();
}

class _bottom_navigationState extends State<bottom_navigation> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    payhisUA(),
    payhisWA()
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
            icon: Icon(Icons.history),
            label: 'User',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_sharp),
            label: 'Worker',
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

