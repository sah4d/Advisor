
import 'package:advertisement/user_signup.dart';
import 'package:advertisement/worker_bottom_nav.dart';
import 'package:advertisement/worker_home.dart';
import 'package:advertisement/worker_signup.dart';
import 'package:advertisement/worker_tab.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'homepage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(qqw());
}
class qqw extends StatelessWidget {
  const qqw({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: workerlogin(),
      debugShowCheckedModeBanner: false,
    );
  }
}
class workerlogin extends StatefulWidget {
  const workerlogin({super.key});

  @override
  State<workerlogin> createState() => _workerloginState();
}

class _workerloginState extends State<workerlogin> {
  bool isChecked = false;
  List<String> id_ = <String>[];
  List<String> email_ = <String>[];
  List<String> password_ = <String>[];
  Future<void> viewdata_() async {
    List<String> id = <String>[];
    List<String> email = <String>[];
    List<String> password = <String>[];
    CollectionReference firedb = FirebaseFirestore.instance.collection("logindetails");
    QuerySnapshot querySnapshot = await firedb.get();
    final _doc = querySnapshot.docs;

    print(_doc);
    print(_doc.length);

    for (int i = 0; i < _doc.length; i++) {
      final d = _doc[i];

      id.add(d.id);
      email.add(d['email']);
      password.add(d['password']);
    }
    setState(() {
      id_ = id;
      email_ = email;
      password_ = password;
    });
  }

  bool passvisible=true;
  TextEditingController _emailcontroller=TextEditingController();
  TextEditingController _passwordcontroller=TextEditingController();
  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/login.png'), fit: BoxFit.cover),
      ),
      child: Scaffold( appBar: AppBar(title: Text("Login Page",style: GoogleFonts.montserrat(),),
        backgroundColor: Colors.tealAccent,
        leading: IconButton(onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>WelcomePage()));

        }, icon: Icon(Icons.navigate_before)),
      ),
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(),
            Container(
              padding: EdgeInsets.only(left: 35, top: 40),
              child: Text(
                'Welcome\nBack TeamMate',
                style: TextStyle(color: Colors.white, fontSize: 33),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery
                        .of(context)
                        .size
                        .height * 0.5),
                child: Form(key: _formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 35, right: 35),
                        child: Column(
                          children: [
                            TextFormField(
                                style: GoogleFonts.teko(color: Colors.black),
                                controller: _emailcontroller,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide:
                                    BorderSide(color: Colors.deepOrangeAccent, width: 3),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide:
                                    BorderSide(color: Colors.deepOrangeAccent, width: 3),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  labelText: "Phone",
                                  labelStyle: GoogleFonts.teko(color: Colors.black),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.cyan, width: 3),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black, width: 3),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty ){
                                    return "Enter a value";
                                  }
                                  return null;
                                }
                            ),
                            SizedBox(height: 20,),
                            TextFormField(

                              obscureText: passvisible,
                              style: GoogleFonts.teko(color: Colors.black),
                              controller: _passwordcontroller,
                              decoration: InputDecoration(
                                suffixIcon: IconButton(onPressed: (){
                                  setState(() {
                                    if(passvisible==false){
                                      passvisible=true;
                                    }
                                    else{
                                      passvisible=false;
                                    }
                                  });
                                }, icon:Icon(passvisible?Icons.visibility_off:Icons.visibility) ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Colors.deepOrangeAccent, width: 3),
                                  borderRadius: BorderRadius.horizontal(),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Colors.deepOrangeAccent, width: 3),
                                  borderRadius: BorderRadius.horizontal(),
                                ),
                                labelText: "Password",
                                labelStyle: GoogleFonts.teko(color: Colors.black),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.cyan, width: 3),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black, width: 3),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "enter a password";
                                } else {
                                  if (!RegExp(
                                      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                                      .hasMatch(value)) {
                                    return "enter a valid password";
                                  } else {
                                    return null;
                                  }
                                }
                              },
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("Remember Me",
                                  style: TextStyle(color: Colors.black),),
                                Checkbox(
                                  value: isChecked,
                                  onChanged: (value) {
                                    isChecked = !isChecked;
                                    setState(() {

                                    });
                                  },
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Sign in',
                                  style: TextStyle(
                                      fontSize: 27, fontWeight: FontWeight.w700),
                                ),
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Color(0xff4c505b),
                                  child: IconButton(
                                      color: Colors.white,
                                      onPressed: () async {
                                        if(_formkey.currentState!.validate()){
                                          CollectionReference firedj=FirebaseFirestore.instance.collection('loginworker');
                                          QuerySnapshot querySnapshot1 = await firedj.where("phone", isEqualTo:_emailcontroller.text).where("password",isEqualTo: _passwordcontroller.text).get();
                                          final _doc2 = querySnapshot1.docs;
                                          if(_doc2.length!=0){
                                            var prefs= await SharedPreferences.getInstance();
                                            prefs.setString("phonenum", _emailcontroller.text).toString();
                                            print(prefs.getString("phonenum").toString());
                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Login Success")));



                                          }
                                          else{
                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Invalid username or password")));
                                          }


                                        }


                                      },
                                      icon: Icon(
                                        Icons.arrow_forward,
                                      )),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 40,
                            ),


                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>worker_signup()));
                                  },
                                  child: Text(
                                    'Sign Up',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        color: Color(0xff4c505b),
                                        fontSize: 18),
                                  ),
                                  style: ButtonStyle(),
                                ),
                                TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      'Forgot Password',
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
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

