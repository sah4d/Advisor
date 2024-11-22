import 'dart:io';
import 'package:advertisement/login_new.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'package:google_fonts/google_fonts.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options:DefaultFirebaseOptions.currentPlatform,
  );
  runApp(user());

}
class user extends StatelessWidget {
  const user({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: user_signup(),
      debugShowCheckedModeBanner: false,
    );
  }
}
class user_signup extends StatefulWidget {
  const user_signup({super.key});

  @override
  State<user_signup> createState() => _user_signupState();
}

class _user_signupState extends State<user_signup> {
  bool passvisible=false;
  File? _image;
  final ImagePicker _picker = ImagePicker();
  TextEditingController _nameController=TextEditingController();
  TextEditingController _phoneContoller=TextEditingController();
  TextEditingController _placeController=TextEditingController();
  TextEditingController _PassController=TextEditingController();
  TextEditingController _BuisnessController=TextEditingController();
  TextEditingController _ConfirmController=TextEditingController();

  final _formkey = GlobalKey<FormState>();
  Future<void> _pickImage() async {
    final XFile? pickedImage = await _picker.pickImage(
        source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
        uploadFile(File(pickedImage.path));

      });
    }
  }
  Future<void> uploadFile(File file) async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference storageReference = storage.ref().child('images/${DateTime.now()}.jpg');

      UploadTask uploadTask = storageReference.putFile(file);

      await uploadTask.whenComplete(() async {
        print('File uploaded successfully');
        String downloadURL = await storageReference.getDownloadURL();
        final pref =await SharedPreferences.getInstance();
        pref.setString("photo", downloadURL);

        print('Download URL: $downloadURL');
      });
    } catch (e) {
      print('Error uploading file: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/black.jpg'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(left: 35, top: 30),
              child: Text(
                'Create\nAccount',
                style: TextStyle(color: Colors.white, fontSize: 33),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 35, right: 35),
                      child: Form(
                key: _formkey,
                child: Column(
                  children: [
                    SizedBox(
                      height: 100,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    _image == null
                        ? InkWell(onTap: (){
                          _pickImage();
                          
                    },
                          child: CircleAvatar(
                                                radius: 70,
                                                backgroundImage:AssetImage("assets/upload.png"),
                                              ),
                        )
                        : InkWell(onTap: (){
                          _pickImage();
                    },
                          child: CircleAvatar(
                                                radius: 70,
                                                backgroundImage: FileImage(_image!),
                                              ),
                        ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      style: GoogleFonts.teko(color: Colors.white),
                      controller: _nameController,
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
                        labelText: "Name",
                        labelStyle: GoogleFonts.teko(color: Colors.white),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.cyan, width: 3),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 3),
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please fill this";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      style: GoogleFonts.teko(color: Colors.white),
                      controller:_placeController ,
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
                        labelText: "Place",
                        labelStyle: GoogleFonts.teko(color: Colors.white),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.cyan, width: 3),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 3),
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please fill this";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20,),
                    TextFormField(
                      style: GoogleFonts.teko(color: Colors.white),
                      controller: _BuisnessController,
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
                        labelText: "Buisness",
                        labelStyle: GoogleFonts.teko(color: Colors.white),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.cyan, width: 3),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 3),
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please fill this";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20,),
                    TextFormField(
                      style: GoogleFonts.teko(color: Colors.white),
                      controller: _phoneContoller,
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
                        labelStyle: GoogleFonts.teko(color: Colors.white),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.cyan, width: 3),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 3),
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      validator: (value) {
                        String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
                        RegExp regExp = RegExp(pattern);
                        if (value!.isEmpty) {
                          return 'Please enter mobile number';
                        } else if (!regExp.hasMatch(value)) {
                          return 'Please enter valid mobile number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(

                      obscureText: passvisible,
                      style: GoogleFonts.teko(color: Colors.white),
                      controller: _PassController,
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
                          borderRadius: BorderRadius.circular(25),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.deepOrangeAccent, width: 3),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        labelText: "Password",
                        labelStyle: GoogleFonts.teko(color: Colors.white),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.cyan, width: 3),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 3),
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
                      height: 20,
                    ),
                    TextFormField(

                      obscureText: passvisible,
                      style: GoogleFonts.teko(color: Colors.white),
                      controller: _ConfirmController,
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
                          borderRadius: BorderRadius.circular(25),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.deepOrangeAccent, width: 3),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        labelText: "Confirm Password",
                        labelStyle: GoogleFonts.teko(color: Colors.white),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.cyan, width: 3),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 3),
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
                          } else if(value!=_PassController.text) {
                            return "Confirm Password not matching";
                          }
                          else{
                            return null;
                          }
                        }
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          if (_formkey.currentState!.validate()) {
                            CollectionReference firedb = FirebaseFirestore.instance.collection("userdetails");
                            CollectionReference firedj = FirebaseFirestore.instance.collection("logindetailsuser");
                            CollectionReference firedk= FirebaseFirestore.instance.collection("logindetailsworker");
                            QuerySnapshot qs1=await firedk.where("phone",isEqualTo: _phoneContoller.text).get();
                            QuerySnapshot querysnapshot= await firedj.where("phone",isEqualTo: _phoneContoller.text).get();
                            final _doc2=querysnapshot.docs;
                            final _doc0=qs1.docs;
                            if(_doc2.length==0 && _doc0.length==0 ){
                              SharedPreferences prefs=await SharedPreferences.getInstance();
                              firedj.add({"phone":_phoneContoller.text,"password":_PassController.text,"type":"User"});
                              QuerySnapshot qs= await firedj.where("phone",isEqualTo: _phoneContoller.text).where("password",isEqualTo: _PassController.text).get();
                              // DocumentReference ref=await FirebaseFirestore.instance.collection("logindetailsuser").doc(_doc1);
                              firedb.add({"name":_nameController.text,"place":_placeController.text,"buisness":_BuisnessController.text,"phone":_phoneContoller.text,"password":_PassController.text,"photo":prefs.getString('photo').toString(),});


                              Navigator.push(context, MaterialPageRoute(builder: (context)=>Login()));
                              Alert(
                                context: context,
                                title: "Signup success",style: AlertStyle(isButtonVisible: false,
                                  titleStyle: GoogleFonts.dmSans(fontSize: 15)),
                                image: Image.asset("assets/signup.png",height: 50,),
                              ).show();





                            }
                            else{
                              Alert(
                                context: context,
                                title: "Phone number is already used",style: AlertStyle(isButtonVisible: false,
                                  titleStyle: GoogleFonts.dmSans(fontSize: 15)),
                                image: Image.asset("assets/cancel.png",height: 50,),
                              ).show();

                            }


                          }
                        },
                        child: Text("submit",style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),))
                  ],
                ),
              ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

