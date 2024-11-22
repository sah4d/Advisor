
import 'package:advertisement/admin_bottom_nav.dart';

import 'package:advertisement/homepage.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  runApp(qqw());
}
class qqw extends StatelessWidget {
  const qqw({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: adminlogin(),
    );
  }
}
class adminlogin extends StatefulWidget {
  const adminlogin({super.key});

  @override
  State<adminlogin> createState() => _adminloginState();
}

class _adminloginState extends State<adminlogin> {
  String adminuser="Admin@2002";
  String adminpass="Admin@2002";
  bool isChecked = false;
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
      child: WillPopScope(onWillPop: ()async {
        return false;

      },
        child: WillPopScope(onWillPop: ()async {
          return false;

        },
          child: Scaffold(
            appBar: AppBar(title: Text("Login Page",style: GoogleFonts.montserrat(),),
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
                  padding: EdgeInsets.only(left: 35, top: 90),
                  child: Text(
                    'Welcome\nBack ADMIN',
                    style:GoogleFonts.mcLaren(color: Colors.teal,fontSize: 30),
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
                                      labelText: "Username",
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
                                              if(adminuser==_emailcontroller.text && adminpass==_passwordcontroller.text){
                                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Login Success")));

                                                Navigator.push(context, MaterialPageRoute(builder: (context)=>BottomNavExample()));
                                                _emailcontroller.text=="";
                                                _passwordcontroller.text=="";

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
        ),
      ),
    );
  }
}

