import 'package:advertisement/User_login.dart';
import 'package:advertisement/Worker_login.dart';
import 'package:advertisement/login_new.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(change());
}
class change extends StatelessWidget {
  const change({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(theme: ThemeData.dark(),
      home: ChangePasswordPagew(),
      debugShowCheckedModeBanner: false,
    );
  }
}


class ChangePasswordPagew extends StatefulWidget {
  const ChangePasswordPagew({Key? key}) : super(key: key);

  @override
  State<ChangePasswordPagew> createState() => _ChangePasswordPagewState();
}

class _ChangePasswordPagewState extends State<ChangePasswordPagew> {
  _ChangePasswordPagewState(){
    prefs();
  }
  String pass="";
  String ph="";
  Future<void> prefs() async {
    SharedPreferences sh=await SharedPreferences.getInstance();
    setState(() {
      pass=sh.getString("password").toString();
      ph=sh.getString("phone").toString();

    });


  }

  bool passVisible = true;
  bool newPassVisible = true;
  bool confirmPassVisible = true;

  final _formKey = GlobalKey<FormState>();
  TextEditingController _currentPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  Future<void> editfire() async {
    CollectionReference firedb = FirebaseFirestore.instance.collection("logindetailsworker");
    QuerySnapshot qs= await firedb.where("phone",isEqualTo: ph).where("password",isEqualTo: pass).get();
    final doc2=qs.docs;
    String Id=doc2.first.id;
    firedb.doc(Id).set({"phone":ph,"password":_confirmPasswordController.text,"type":"Worker"});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Change Password',
          style: GoogleFonts.teko(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.cyan,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 60),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Current Password',
                style: GoogleFonts.teko(fontSize: 20, color: Colors.grey[700]),
              ),
              SizedBox(height: 10),
              _buildPasswordField(
                controller: _currentPasswordController,
                hintText: 'Enter current password',
                isVisible: passVisible,
                toggleVisibility: () {
                  setState(() {
                    passVisible = !passVisible;
                  });
                },
                validator: (value){
                  if(value!.isEmpty){
                    return "Please enter current Password";
                  }
                  else{
                    return null;
                  }
                }
              ),
              SizedBox(height: 30),
              Text(
                'New Password',
                style: GoogleFonts.teko(fontSize: 20, color: Colors.grey[700]),
              ),
              SizedBox(height: 10),
              _buildPasswordField(
                controller: _newPasswordController,
                hintText: 'Enter new password',
                isVisible: newPassVisible,
                toggleVisibility: () {
                  setState(() {
                    newPassVisible = !newPassVisible;
                  });
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a new password';
                  }
                  if (value.length < 8) {
                    return 'Password must be at least 8 characters long';
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),
              Text(
                'Confirm New Password',
                style: GoogleFonts.teko(fontSize: 20, color: Colors.grey[700]),
              ),
              SizedBox(height: 10),
              _buildPasswordField(
                controller: _confirmPasswordController,
                hintText: 'Confirm new password',
                isVisible: confirmPassVisible,
                toggleVisibility: () {
                  setState(() {
                    confirmPassVisible = !confirmPassVisible;
                  });
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please confirm the new password';
                  }
                  if (value != _newPasswordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              SizedBox(height: 50),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      if (_currentPasswordController.text==pass){
                        editfire();
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>Login()));
                        Alert(
                          context: context,
                          title: "Password Changed",style: AlertStyle(isButtonVisible: false,
                            titleStyle: GoogleFonts.dmSans(fontSize: 15)),
                          image: Image.asset("assets/password.png",height: 70,),
                        ).show();
                      }
                      else{
                        Alert(
                          context: context,
                          title: "Current password Error",style: AlertStyle(isButtonVisible: false,
                            titleStyle: GoogleFonts.dmSans(fontSize: 15)),
                          image: Image.asset("assets/cancel.png",height: 70,),
                        ).show();

                      }
                      // Handle password change logic here


                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding:
                    EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    backgroundColor: Colors.cyan,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Change Password',
                    style: GoogleFonts.teko(fontSize: 22, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hintText,
    required bool isVisible,
    required VoidCallback toggleVisibility,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isVisible,
      style: GoogleFonts.teko(color: Colors.black),
      decoration: InputDecoration(
        suffixIcon: IconButton(
          onPressed: toggleVisibility,
          icon: Icon(isVisible ? Icons.visibility_off : Icons.visibility),
        ),
        hintText: hintText,
        hintStyle: GoogleFonts.teko(color: Colors.grey[600]),
        errorBorder:  OutlineInputBorder(borderSide: BorderSide(color: Colors.red,width: 3),borderRadius: BorderRadius.circular(25)),
        focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red,width: 3),borderRadius: BorderRadius.circular(25)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.cyan, width: 3),
          borderRadius: BorderRadius.circular(25),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(25),
        ),
      ),
      validator: validator,
    );
  }
}
