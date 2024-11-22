import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';  // Import for system navigation (to exit app)
import 'Admin_login.dart';
import 'User_login.dart';
import 'Worker_login.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(homie());
}

class homie extends StatelessWidget {
  const homie({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomePage(),
    );
  }
}

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;  // Disable the back button
      },
      child: Scaffold(
        body: Stack(
          children: [
            // Minimalistic gradient background
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFF5F5F5), // Soft off-white color
                    Color(0xFFE0E0E0), // Light grey for a subtle contrast
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Clean and subtle title
                    Text(
                      "Welcome to\nAD-VISOR",
                      style: GoogleFonts.montserrat(
                        fontSize: 36,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                        letterSpacing: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 50),

                    // Buttons with minimalistic design
                    _buildButton(context, 'Admin', adminlogin(), Colors.teal),
                    SizedBox(height: 20),
                    _buildButton(context, 'User', userlogin(), Colors.teal[300]!),
                    SizedBox(height: 20),
                    _buildButton(context, 'Worker', workerlogin(), Colors.teal[100]!),
                    SizedBox(height: 20),
                    // Exit button
                    ElevatedButton(
                      onPressed: () {
                        SystemNavigator.pop();  // This will exit the app
                      },
                      child: Text(
                        'Exit',
                        style: GoogleFonts.montserrat(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                        backgroundColor: Colors.redAccent,  // Red accent for exit button
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 2,
                        shadowColor: Colors.black.withOpacity(0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to create a minimalistic button
  Widget _buildButton(BuildContext context, String label, Widget page, Color color) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      child: Text(
        label,
        style: GoogleFonts.montserrat(fontSize: 18, color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
      ),
    );
  }
}
