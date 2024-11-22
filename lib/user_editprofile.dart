
import 'dart:io';
import 'package:advertisement/user_bottom_nav.dart';
import 'package:advertisement/user_home.dart';
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
      debugShowCheckedModeBanner: false,
      home: user_edit(),
    );
  }
}
class user_edit extends StatefulWidget {
  const user_edit({super.key});

  @override
  State<user_edit> createState() => _user_editState();
}

class _user_editState extends State<user_edit> {
  _user_editState(){
    prefs();
  }




  bool passvisible=false;
  File? _image;
  final ImagePicker _picker = ImagePicker();
  String id="";
  String phonenum="";
  String Photo="";
  String pass="";
  String ph="";
  TextEditingController _nameController=TextEditingController();
  TextEditingController _phoneContoller=TextEditingController();
  TextEditingController _placeController=TextEditingController();
  TextEditingController _BuisnessController=TextEditingController();
  Future<void> prefs() async {
    SharedPreferences sh=await SharedPreferences.getInstance();
    setState(() {
      id=sh.get("id").toString();
      _nameController.text=sh.get("name").toString();
      _phoneContoller.text=sh.get("phone").toString();
      _placeController.text=sh.get("place").toString();
      _BuisnessController.text=sh.get("business").toString();
      Photo=sh.getString("photo").toString();
      pass=sh.getString("password").toString();
      ph=sh.getString("phone").toString();

    });


  }
  Future<void> editfire() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    CollectionReference firedb= FirebaseFirestore.instance.collection('userdetails');
    firedb.doc(id).update({"name":_nameController.text,"place":_placeController.text,"phone":ph,"buisness":_BuisnessController.text,"password":pass});
    if (_image!= null){
      firedb.doc(id).update({"photo":pref.getString("photoimg").toString()});
    }

  }

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
        if(_image!=null){
          pref.setString("photoimg", downloadURL);

        }
        else{
          pref.setString("photoimg", Photo);
        }


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
        appBar: AppBar(flexibleSpace: Container(decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueGrey, Colors.grey[200]!],
            begin: Alignment.bottomRight,
            end: Alignment.bottomLeft,
          ),
        ),

        ),
          title: Text("Edit Profile", style: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.black87)),
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false
          ,
          elevation: 0,
        ),
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(left: 35, top: 30),
              child: Text(
                'Edit\nProfile',
                style: GoogleFonts.albertSans(fontSize: 30,color: Colors.white,letterSpacing: 4),
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
                                ? CircleAvatar(
                              radius: 90,
                              backgroundImage: NetworkImage(Photo),
                            )
                                : CircleAvatar(
                              radius: 90,
                              backgroundImage: FileImage(_image!),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            IconButton(
                                color: Colors.white,
                                onPressed: () {
                                  _pickImage();
                                },
                                icon: Icon(Icons.person)),
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
                                  borderSide: BorderSide(color: Colors.tealAccent, width: 3),
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
                                  borderSide: BorderSide(color: Colors.tealAccent, width: 3),
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
                            SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                                onPressed: () async {
                                  if (_formkey.currentState!.validate()) {
                                    editfire();
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>UserHome()));
                                    Alert(
                                      context: context,
                                      title: "Profile Edited",style: AlertStyle(isButtonVisible: false,
                                        titleStyle: GoogleFonts.dmSans(fontSize: 15)),
                                      image: Image.asset("assets/userdetails.png",height: 70,),
                                    ).show();




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

