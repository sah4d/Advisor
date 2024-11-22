
import 'dart:io';
import 'package:advertisement/admin_dashhh.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
      home: Ad_spotE(),
    );
  }
}
class Ad_spotE extends StatefulWidget {
  const Ad_spotE({super.key});

  @override
  State<Ad_spotE> createState() => _Ad_spotEState();
}

class _Ad_spotEState extends State<Ad_spotE> {
  _Ad_spotEState(){
    shared();
  }
  String id_ = "";
  String namel_ = '';
  String place_ = '';
  String price_ = "";
  String photo_ = "";
  String category="";
  String location="";
  String phone="";
  String status="";
  String assigned="";
  String customerph="";
  String worker="";
  String payment="";
  Future<void> shared() async {
    SharedPreferences shii = await SharedPreferences.getInstance();
    setState(() {
      id_=shii.getString("adid").toString();
      _nameController.text=shii.getString("title").toString();
      _paymentController.text=shii.getString("payment").toString();
      _CordinateController.text=shii.getString("location").toString();
      _priceController.text=shii.getString("price").toString();
      _placeController.text=shii.getString('place').toString();
      _categoryController.text=shii.getString("category").toString();
      _phoneContoller.text=shii.getString("phonenumber").toString();
      photo_=shii.getString("adphoto").toString();

    });
  }
  Future<void>EditFire()async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    CollectionReference firedb = FirebaseFirestore.instance.collection("advertisement");
    if(_image!=null){
      firedb.doc(id_).update({"photo":pref.getString("photoselected").toString(),});

    }
    firedb.doc(id_).update({"title":_nameController.text,
      "location":_CordinateController.text,
      "price":_priceController.text,
      "category":_categoryController.text,
      "place":_placeController.text,
      "phone":_phoneContoller.text,
      "payment":_paymentController.text,
    });
  }
  bool passvisible=false;
  File? _image;
  final ImagePicker _picker = ImagePicker();
  TextEditingController _nameController=TextEditingController();
  TextEditingController _phoneContoller=TextEditingController();
  TextEditingController _placeController=TextEditingController();
  TextEditingController _categoryController=TextEditingController();
  TextEditingController _priceController=TextEditingController();
  TextEditingController _CordinateController=TextEditingController();
  TextEditingController _paymentController=TextEditingController();

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

          pref.setString("photoselected", downloadURL);


        print('Download URL: $downloadURL');
      });
    } catch (e) {
      print('Error uploading file: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: SweepGradient(colors: [Colors.tealAccent,Colors.redAccent])
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
                'EDIT AD',
                style:GoogleFonts.montserrat(fontSize: 30,color: Colors.white),
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
                              radius: 80,
                              backgroundImage: NetworkImage(
                                  photo_),
                            )
                                : CircleAvatar(
                              radius: 80,
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
                                labelText: "Title",
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
                              controller: _CordinateController,
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
                                labelText: "Location",
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
                              keyboardType: TextInputType.number,
                              style: GoogleFonts.teko(color: Colors.white),
                              controller: _priceController,
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
                                labelText: "Price",
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
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              style: GoogleFonts.teko(color: Colors.white),
                              controller: _paymentController,
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
                                labelText: "payment",
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
                              controller: _categoryController,
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
                                labelText: "Category",
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
                            SizedBox(
                              height: 10,
                            ),
                            ElevatedButton(
                                onPressed: () async {
                                  if (_formkey.currentState!.validate()) {
                                    EditFire();

                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Admin_dasboard()));
                                    CoolAlert.show(
                                      context: context,
                                      type: CoolAlertType.success,
                                      text: "Edit Success",
                                    );

                                  }
                                },
                                child: Text("SUBMIT",style: GoogleFonts.dmSans(fontWeight: FontWeight.bold),)
                            )
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

