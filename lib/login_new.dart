import 'package:advertisement/admin_dashhh.dart';
import 'package:advertisement/user_home.dart';
import 'package:advertisement/user_signup.dart';
import 'package:advertisement/worker_home.dart';
import 'package:advertisement/worker_signup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const QQW());
}

class QQW extends StatelessWidget {
  const QQW({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Login(),
    );
  }
}

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String adminuser = "Admin@2002";
  String adminpass = "Admin@2002";
  bool isChecked = false;
  bool passVisible = true;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/login.png'), fit: BoxFit.cover),
      ),
      child: WillPopScope(
        onWillPop: () async{
          SystemNavigator.pop();
          return false;
        },
        child: Scaffold(
          appBar: AppBar(automaticallyImplyLeading: false,
            title: Text("Login Page", style: GoogleFonts.montserrat(color: Colors.white)),
            backgroundColor: Colors.transparent,
          ),
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              Container(
                padding: const EdgeInsets.only(left: 35, top: 40),
                child: Text(
                  'Welcome\nBack',
                  style:GoogleFonts.albertSans(fontSize: 32,color: Colors.white,),
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.3),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 35),
                          child: Column(
                            children: [
                              // Role Selection Radio Button
                              // Username field
                              TextFormField(
                                style: GoogleFonts.teko(color: Colors.black),
                                controller: _emailController,
                                decoration: InputDecoration(
                                  focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(25),),
                                  errorBorder: OutlineInputBorder(borderRadius:BorderRadius.circular(25),),
                                  labelText: "Phone",
                                  labelStyle:
                                  GoogleFonts.teko(color: Colors.black),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                    BorderSide(color: Colors.cyan, width: 3),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                    BorderSide(color: Colors.black, width: 3),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Enter a value";
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 20),
                              // Password field
                              TextFormField(
                                obscureText: passVisible,
                                style: GoogleFonts.teko(color: Colors.black),
                                controller: _passwordController,
                                decoration: InputDecoration(
                                  errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                                  focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        passVisible = !passVisible;
                                      });
                                    },
                                    icon: Icon(
                                        passVisible
                                            ? Icons.visibility_off
                                            : Icons.visibility),
                                  ),
                                  labelText: "Password",
                                  labelStyle:
                                  GoogleFonts.teko(color: Colors.black),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                    BorderSide(color: Colors.cyan, width: 3),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                    BorderSide(color: Colors.black, width: 3),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Enter a password";
                                  } else if (!RegExp(
                                      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                                      .hasMatch(value)) {
                                    return "Enter a valid password";
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 200),
                              // Remember Me Checkbox
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Sign in',
                                    style: TextStyle(
                                        fontSize: 27,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundColor: Color(0xff4c505b),
                                    child: IconButton(
                                      color: Colors.white,
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          CollectionReference firedj=FirebaseFirestore.instance.collection('logindetailsuser');
                                          QuerySnapshot querySnapshot1 = await firedj.where("phone", isEqualTo:_emailController.text)
                                              .where("type",isEqualTo: "User").where("password",isEqualTo:_passwordController.text ).get();
                                          final _doc2 = querySnapshot1.docs;
                                          QuerySnapshot qwe=await firedj.get();
                                          final test1=qwe.docs;
                                          print(test1.length);
                                          print("heloooooooooooooooo");
                                          CollectionReference firedk=FirebaseFirestore.instance.collection('logindetailsworker');
                                          QuerySnapshot querySnapshot2 = await firedk.where("phone", isEqualTo:_emailController.text)
                                              .where("type",isEqualTo: "Worker").where("password",isEqualTo:_passwordController.text ).get();
                                          final _doc11 = querySnapshot2.docs;
                                            // Perform login based on selected role
                                            if (adminuser ==
                                                _emailController.text &&
                                                adminpass ==
                                                    _passwordController.text) {

                                              SharedPreferences shred=await SharedPreferences.getInstance();
                                              shred.setString("type", "admin").toString();



                                              Navigator.push(context, MaterialPageRoute(builder: (context)=>Admin_dasboard()));
                                              CoolAlert.show(
                                                context: context,
                                                type: CoolAlertType.success,
                                                text: "Login Success",
                                              );

                                              // Navigate based on role
                                            }
                                            else if(_doc2.length!=0){
                                              var prefs= await SharedPreferences.getInstance();
                                              prefs.setString("lid11", _emailController.text).toString();
                                              print(prefs.getString("lid11").toString());

                                              SharedPreferences shred=await SharedPreferences.getInstance();
                                              shred.setString("type", "user").toString();

                                              Navigator.push(context, MaterialPageRoute(builder: (context)=>UserHome()));
                                              CoolAlert.show(title: "Login Success",
                                                  context: context, type: CoolAlertType.success

                                              );


                                            }
                                            else if(_doc11.length!=0){
                                              var prefs= await SharedPreferences.getInstance();
                                              prefs.setString("phonenum", _emailController.text).toString();
                                              print(prefs.getString("phonenum").toString());

                                              SharedPreferences shred=await SharedPreferences.getInstance();
                                              shred.setString("type", "worker").toString();

                                              Navigator.push(context, MaterialPageRoute(builder: (context)=>WorkerHome()));
                                              Alert(
                                                context: context,
                                                title: "Login Success",style: AlertStyle(isButtonVisible: false,
                                                  titleStyle: GoogleFonts.dmSans(fontSize: 15)),
                                                image: Image.asset("assets/check.png",height: 50,),
                                              ).show();

                                        }
                                            else {
                                              CoolAlert.show(
                                                context: context,
                                                type: CoolAlertType.error,
                                                text: "Invalid Username or Password",
                                              );
                                            }

                                        }
                                      },
                                      icon: const Icon(Icons.arrow_forward),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),


                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>user_signup()));
                                    },
                                    child: Text(
                                      'User Signup',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          color: Color(0xff4c505b),
                                          fontSize: 18),
                                    ),
                                    style: ButtonStyle(),
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>worker_signup()));
                                      },
                                      child: Text(
                                        'Worker Signup',
                                        style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          color: Color(0xff4c505b),
                                          fontSize: 18,
                                        ),
                                      )),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
