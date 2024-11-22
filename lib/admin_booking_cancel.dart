import 'package:advertisement/admin_dashhh.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CancelBooking extends StatefulWidget {
  @override
  State<CancelBooking> createState() => _CancelBookingState();
}

class _CancelBookingState extends State<CancelBooking> {
  String id_ = "";
  String namel_ = '';
  String place_ = '';
  String price_ = "";
  String photo_ = "";
  String phonenum = "";
  String category = "";
  String location = "";
  String phone = "";
  String customer = '';

  Future<void> shared() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      phonenum = prefs.getString("phoneii")!;
      id_ = prefs.getString("selectedAdId")!;
      price_ = prefs.getString("price")!;
      namel_ = prefs.getString("name")!;
      photo_ = prefs.getString("photo")!;
      phone = prefs.getString("phone").toString();
      category = prefs.getString("category").toString();
      location = prefs.getString("location").toString();
      place_ = prefs.getString("place").toString();
      customer = prefs.getString("customer").toString();
    });
  }

  Future<void> UpdateAd() async {
    CollectionReference firedb = FirebaseFirestore.instance.collection("advertisement");
    firedb.doc(id_).update({
      "title": namel_,
      "location": location,
      "price": price_,
      "category": category,
      "place": place_,
      "phone": phone,
      "photo": photo_,
      "status": "available",
      "assigned": "pending",
      "customerph": "not selected",
      "worker": "not selected",
      "Date":DateFormat.yMMMEd().format(DateTime.now()).toString()
    });
  }

  @override
  void initState() {
    super.initState();
    shared();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Cancel booking',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20.0,
            fontWeight: FontWeight.w400,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image with a minimal frame and rounded edges
            AspectRatio(
              aspectRatio: 16 / 9,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Image.network(
                  photo_,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: Icon(
                        Icons.broken_image,
                        color: Colors.grey[500],
                        size: 50.0,
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 24.0),
            // Item name, location, and other details
            Text(
              namel_,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              place_,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 16.0),
            // Displaying category and location
            _buildDetailRow('Category', category),
            Column(mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text("Location",style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey[600],
              ),),
                Text(location,style:TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),)

              ],),
            _buildDetailRow('Customer', customer),
            _buildDetailRow('Customer Phone', phone),
            _buildDetailRow('Your Phone', phonenum),
            Spacer(),
            // Price section
            Divider(
              color: Colors.grey[300],
              thickness: 1.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Price',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            // Request Work button
            ElevatedButton(
              onPressed: () {
                UpdateAd();
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Admin_dasboard()));
                Alert(
                  context: context,
                  title: "Booking cancelled",style: AlertStyle(isButtonVisible: false,
                    titleStyle: GoogleFonts.dmSans(fontSize: 15)),
                  image: Image.asset("assets/cancel.gif",height: 100,),
                ).show();

              },
              child: Text(
                'Cancel Booking',
                style: TextStyle(fontSize: 16.0, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                elevation: 0,
                minimumSize: Size(double.infinity, 50.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
            SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }

  // Helper function to build detail rows
  Widget _buildDetailRow(String title, String detail) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.grey[600],
            ),
          ),
          Text(
            detail,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
