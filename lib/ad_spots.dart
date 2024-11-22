import 'dart:io';
import 'package:advertisement/admin_dashhh.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(user());
}

class user extends StatelessWidget {
  const user({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Ad_spot(),
    );
  }
}

class Ad_spot extends StatefulWidget {
  const Ad_spot({super.key});

  @override
  State<Ad_spot> createState() => _Ad_spotState();
}

class _Ad_spotState extends State<Ad_spot> {
  bool passvisible = false;
  File? _image;
  final ImagePicker _picker = ImagePicker();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneContoller = TextEditingController();
  TextEditingController _placeController = TextEditingController();
  TextEditingController _categoryController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _CordinateController = TextEditingController();
  TextEditingController _paymentController = TextEditingController();

  final _formkey = GlobalKey<FormState>();
  Future<void> _pickImage() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
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
      Reference storageReference =
          storage.ref().child('images/${DateTime.now()}.jpg');

      UploadTask uploadTask = storageReference.putFile(file);

      await uploadTask.whenComplete(() async {
        print('File uploaded successfully');
        String downloadURL = await storageReference.getDownloadURL();
        final pref = await SharedPreferences.getInstance();
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
            image: AssetImage('assets/bill.jpg'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(automaticallyImplyLeading:  false,
          title: Text(
            "Add Adspots",
            style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SingleChildScrollView(
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
                          ? InkWell(
                              onTap: () {
                                _pickImage();
                              },
                              child: CircleAvatar(
                                radius: 60,
                                backgroundImage:
                                    AssetImage("assets/upload.png"),
                              ),
                            )
                          : InkWell(
                              onTap: () {
                                _pickImage();
                              },
                              child: CircleAvatar(
                                radius: 60,
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
                            borderSide: BorderSide(
                                color: Colors.deepOrangeAccent, width: 3),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.deepOrangeAccent, width: 3),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          labelText: "Title",
                          labelStyle: GoogleFonts.teko(color: Colors.white),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.cyan, width: 3),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 3),
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
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        style: GoogleFonts.teko(color: Colors.white),
                        controller: _CordinateController,
                        decoration: InputDecoration(
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.deepOrangeAccent, width: 3),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.deepOrangeAccent, width: 3),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          labelText: "Location",
                          labelStyle: GoogleFonts.teko(color: Colors.white),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.cyan, width: 3),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 3),
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
                        keyboardType: TextInputType.number,
                        style: GoogleFonts.teko(color: Colors.white),
                        controller: _priceController,
                        decoration: InputDecoration(
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.deepOrangeAccent, width: 3),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.deepOrangeAccent, width: 3),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          labelText: "Price",
                          labelStyle: GoogleFonts.teko(color: Colors.white),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.cyan, width: 3),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 3),
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
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        style: GoogleFonts.teko(color: Colors.white),
                        controller: _paymentController,
                        decoration: InputDecoration(
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.deepOrangeAccent, width: 3),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.deepOrangeAccent, width: 3),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          labelText: "payment",
                          labelStyle: GoogleFonts.teko(color: Colors.white),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.cyan, width: 3),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 3),
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
                        controller: _placeController,
                        decoration: InputDecoration(
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.deepOrangeAccent, width: 3),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.deepOrangeAccent, width: 3),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          labelText: "Place",
                          labelStyle: GoogleFonts.teko(color: Colors.white),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.cyan, width: 3),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 3),
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
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        style: GoogleFonts.teko(color: Colors.white),
                        controller: _categoryController,
                        decoration: InputDecoration(
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.deepOrangeAccent, width: 3),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.deepOrangeAccent, width: 3),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          labelText: "Category",
                          labelStyle: GoogleFonts.teko(color: Colors.white),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.cyan, width: 3),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 3),
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
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        style: GoogleFonts.teko(color: Colors.white),
                        controller: _phoneContoller,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.deepOrangeAccent, width: 3),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.deepOrangeAccent, width: 3),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          labelText: "Phone",
                          labelStyle: GoogleFonts.teko(color: Colors.white),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.cyan, width: 3),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 3),
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
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            if (_formkey.currentState!.validate()) {
                              SharedPreferences pref =
                                  await SharedPreferences.getInstance();
                              CollectionReference firedb = FirebaseFirestore
                                  .instance
                                  .collection("advertisement");
                              firedb.add({
                                "title": _nameController.text,
                                "location": _CordinateController.text,
                                "price": _priceController.text,
                                "category": _categoryController.text,
                                "place": _placeController.text,
                                "phone": _phoneContoller.text,
                                "photo": pref.getString("photo").toString(),
                                "status": "available",
                                "assigned": "pending",
                                "customerph": "not selected",
                                "worker": "not selected",
                                "payment": _paymentController.text,
                                "Date": DateFormat.yMMMEd()
                                    .format(DateTime.now())
                                    .toString()
                              });
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Admin_dasboard()));
                              CoolAlert.show(
                                context: context,
                                type: CoolAlertType.success,
                                text: "Success",
                              );
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
    );
  }
}
