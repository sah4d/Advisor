
import 'dart:io';
import 'package:advertisement/worker_home.dart';
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
  runApp(worker());

}
class worker extends StatelessWidget {
  const worker({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: worker_edit(),
      debugShowCheckedModeBanner: false,
    );
  }
}
class worker_edit extends StatefulWidget {
  const worker_edit({super.key});

  @override
  State<worker_edit> createState() => _worker_editState();
}

class _worker_editState extends State<worker_edit> {

  _worker_editState(){
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
  TextEditingController _placeController=TextEditingController();
  TextEditingController _BuisnessController=TextEditingController();
  Future<void> prefs() async {
    SharedPreferences sh1=await SharedPreferences.getInstance();
    setState(() {
      id=sh1.get("id1").toString();
      _nameController.text=sh1.get("name1").toString();
      _placeController.text=sh1.get("place1").toString();
      _BuisnessController.text=sh1.get("business1").toString();
      Photo=sh1.getString("photo1").toString();
      pass=sh1.getString("password1").toString();
      ph=sh1.getString("phone1").toString();

    });
    print(id+"    its  a hbdhsabh");


  }
  Future<void> editfire() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    CollectionReference firedb= FirebaseFirestore.instance.collection("workerdetails");
   firedb.doc(id).update({"name":_nameController.text,"place":_placeController.text,"qualification":_BuisnessController.text});
   if(_image!= null){
     firedb.doc(id).update({"photo":pref.getString("photoimg11").toString()});

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
    else{
      uploadFile(File(pickedImage!.path));
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

          pref.setString("photoimg11", downloadURL);
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
            image: AssetImage('assets/work.jpg'), fit: BoxFit.cover),
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
                              style: GoogleFonts.teko(color: Colors.teal),
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
                                labelStyle: GoogleFonts.teko(color: Colors.blue),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.tealAccent, width: 3),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.teal, width: 3),
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
                              style: GoogleFonts.teko(color: Colors.black),
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
                                  borderSide: BorderSide(color: Colors.black, width: 3),
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
                                labelText: "Qualification",
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
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>WorkerHome()));
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

