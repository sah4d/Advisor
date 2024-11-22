import 'package:advertisement/admin_dashhh.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RequestWorkA extends StatefulWidget {
  @override
  State<RequestWorkA> createState() => _RequestWorkAState();
}

class _RequestWorkAState extends State<RequestWorkA> {
  String id_ = "";
  String Rid_ = "";
  String namel_ = '';
  String place_ = '';
  String price_ = "";
  String photo_ = "";
  String phonenum = "";
  String category = "";
  String location = "";
  String phone = "";
  String customer = '';
  String worker="";
  String payment_="";
  bool isLoading=true;

  Future<void> shared() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      id_ = prefs.getString("selectedAdId")!;
      price_ = prefs.getString("price")!;
      namel_ = prefs.getString("name")!;
      photo_ = prefs.getString("photo")!;
      phone = prefs.getString("phone").toString();
      category = prefs.getString("category").toString();
      location = prefs.getString("location").toString();
      place_ = prefs.getString("place").toString();
      customer = prefs.getString("customer").toString();
      worker = prefs.getString("worker").toString();
      Rid_ = prefs.getString("requestId").toString();
      payment_ = prefs.getString("payment").toString();
      print(Rid_);

    });
  }

  Future<void> UpdateAd() async {
    CollectionReference advertisements = FirebaseFirestore.instance.collection("advertisement");
    CollectionReference requests = FirebaseFirestore.instance.collection("requests");

    try {
      // Create a reference to the specific document in "advertisement"
      DocumentReference adRef = advertisements.doc(id_);

      // Update the advertisement document
      await adRef.update({
        "title": namel_,
        "location": location,
        "price": price_,
        "category": category,
        "place": place_,
        "phone": phone,
        "photo": photo_,
        "status": "Booked",
        "assigned": "accepted",
        "customerph": customer,
        "worker": worker,
        "Date": DateFormat.yMMMEd().format(DateTime.now()).toString(),
      });

      // Update the specific request in "requests" collection
      await requests.doc(Rid_).update({"selected": worker});

      // Delete all documents in "requests" collection with the same ad reference
      QuerySnapshot querySnapshot = await requests.where("ad", isEqualTo: adRef).get();
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        await doc.reference.delete();
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Request accepted and related documents deleted")));
    } catch (e) {
      print("Error updating and deleting documents: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
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
          'Request Work',
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
      body: namel_.length==0?
      Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center,
          children: [Image.asset("assets/nothing.png",height: 100,),
            Text("No Data",style: GoogleFonts.montserrat(fontSize: 20),)
          ],
        ),
      ):
      Padding(
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
            _buildDetailRow('Customer', customer),
            _buildDetailRow('Owner Phone', phone),
            _buildDetailRow('Worker Phone', worker),
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
                  Text(
                    payment_,
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
              onPressed: ()  {
                UpdateAd();

                Navigator.push(context, MaterialPageRoute(builder: (context)=>Admin_dasboard()));
                Alert(
                  context: context,
                  title: "Assigned",style: AlertStyle(isButtonVisible: false,
                    titleStyle: GoogleFonts.dmSans(fontSize: 15)),
                  image: Image.asset("assets/agreement.png",height: 70,),
                ).show();
              },
              child: Text(
                'Accept work request',
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
