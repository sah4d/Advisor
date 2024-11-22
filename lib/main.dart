import 'dart:async';
import 'package:advertisement/admin_dashhh.dart';
import 'package:advertisement/login_new.dart';
import 'package:advertisement/user_home.dart';
import 'package:advertisement/worker_home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Modify to navigate to a general login page if needed
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'package:flutter_gradient_animation_text/flutter_gradient_animation_text.dart';

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
// FlutterLocalNotificationsPlugin();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // const AndroidInitializationSettings initializationSettingsAndroid =
  // AndroidInitializationSettings('@mipmap/ic_launcher');
  // const InitializationSettings initializationSettings =
  // InitializationSettings(android: initializationSettingsAndroid);
  // await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  runApp(const Homie());
}

class Homie extends StatelessWidget {
  const Homie({super.key});

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

class _WelcomePageState extends State<WelcomePage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize the AnimationController and Tween for the popup effect
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInCirc),
    );

    // Start the animation
    _controller.forward();

    // Set up a timer to navigate after 5 seconds
    Timer(const Duration(seconds: 3), () async {
      SharedPreferences shred=await SharedPreferences.getInstance();
      if(shred.getString("type").toString()=="admin"){
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Admin_dasboard()),
        );

      }
      else if(shred.getString("type").toString()=="user"){
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UserHome()),
        );
      }
      else if(shred.getString('type').toString()=="worker"){
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => WorkerHome()),
        );
      }
      else{
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
      }

    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient background
          Container(
            decoration: BoxDecoration(
              gradient: SweepGradient(
                colors: [
                  Colors.cyanAccent,
                  Colors.cyan,
                ],
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: ScaleTransition(
                scale: _animation,
                child: GradientAnimationText(
                  colors: [
                  Colors.white70,Colors.white,
                ],
                  text: Text(
                    "Welcome to\nAD-VISOR",
                    style:
                    GoogleFonts.montserrat(
                      fontSize: 36,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                      letterSpacing: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ), duration: Duration(seconds: 3),

                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
