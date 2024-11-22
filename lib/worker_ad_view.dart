import 'package:advertisement/work_request.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:url_launcher/url_launcher.dart';
import 'firebase_options.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  runApp(DeiApp());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class DeiApp extends StatelessWidget {
  const DeiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Workerview(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Workerview extends StatefulWidget {
  const Workerview({super.key});

  @override
  State<Workerview> createState() => _WorkerviewState();
}

class _WorkerviewState extends State<Workerview> {
  _WorkerviewState(){
    prefs();
    fetchAdsData();
  }

  String ph="";
  String nameofworker="";
  Future<void> prefs() async {
    var prefs= await SharedPreferences.getInstance();
    var shiqq= await SharedPreferences.getInstance();
    ph=prefs.getString("phonenum").toString();
    nameofworker=shiqq.getString("nameofworker").toString();
  }

  List<String> id_ = [];
  List<String> namel_ = [];
  List<String> place_ = [];
  List<String> phone_ = [];
  List<String> price_ = [];
  List<String> category_ = [];
  List<String> photo_ = [];
  List<String> date_ = [];
  List<String> location_ = [];
  List<String> Customer = [];
  List<String> payment_ = [];
  bool isLoading=true;

  Future<void> fetchAdsData() async {
    CollectionReference adsRef = FirebaseFirestore.instance.collection("advertisement");
    QuerySnapshot querySnapshot = await adsRef.where("status",isEqualTo: "Booked").where("assigned",isEqualTo: "pending").get();
    final adsData = querySnapshot.docs;

    List<String> ids = [];
    List<String> names = [];
    List<String> places = [];
    List<String> phones = [];
    List<String> prices = [];
    List<String> categories = [];
    List<String> photos = [];
    List<String> Locations = [];
    List<String> Dates = [];
    List<String> customer = [];
    List<String> Payment_ = [];

    for (var ad in adsData) {
      ids.add(ad.id);
      names.add(ad['title']);
      places.add(ad['place']);
      prices.add(ad['price']);
      phones.add(ad['phone']);
      categories.add(ad['category']);
      photos.add(ad['photo']);
      Locations.add(ad["location"]);
      customer.add(ad["customerph"]);
      Dates.add(ad["Date"]);
      Payment_.add(ad["payment"]);
    }

    setState(() {
      id_ = ids;
      namel_ = names;
      place_ = places;
      phone_ = phones;
      price_ = prices;
      category_ = categories;
      photo_ = photos;
      date_ = Dates;
      location_=Locations;
      Customer=customer;
      payment_=Payment_;
    });
    setState(() {
      isLoading=false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false,
        title: Text("Available Works", style: GoogleFonts.montserrat(fontSize: 20,fontWeight: FontWeight.bold, color: Colors.black87)),
        backgroundColor: Colors.transparent,
        elevation: 10,
      ),
      body:isLoading
          ? Center(
        child: CircularProgressIndicator(), // Show loading indicator while data is loading
      ):
      namel_.length==0?
      Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center,
          children: [Image.asset("assets/nothing.png",height: 100,),
            Text("No Data",style: GoogleFonts.montserrat(fontSize: 20),)
          ],
        ),
      ):
      Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.grey[200]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView.builder(
          itemCount: id_.length,
          itemBuilder: (context, index) {
            return Container(
              child: Column(
                children: [
                  Card(clipBehavior: Clip.antiAliasWithSaveLayer,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2),
                        side: BorderSide(color: Colors.white12,width: 2)),
                    elevation: 5,
                    child: ListTile(
                      title: StrokeText(strokeWidth: 3,strokeColor: Colors.black38,
                          text: namel_[index],textStyle: GoogleFonts.montserrat(fontSize: 25,color: Colors.white,fontWeight: FontWeight.bold)),
                      subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [ Text(  place_[index],style: GoogleFonts.montserrat(fontSize:18,fontWeight: FontWeight.bold),),
                        Divider(thickness: 2,),
                        Text( "Payment : " +payment_[index],style: GoogleFonts.montserrat(fontSize:15,fontWeight: FontWeight.bold),),
                        Text(  "Date : "+date_[index],style: GoogleFonts.montserrat(fontSize:15,fontWeight: FontWeight.bold),),
                      ],),


                    ),
                  ),

                  Card(elevation: 5,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2),
                        side: BorderSide(color: Colors.white12,width: 3)),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Container(height: 300,decoration: BoxDecoration(image: DecorationImage(image: NetworkImage(photo_[index]),fit: BoxFit.cover
                    )),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.015),

                  Card( shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2),
                      side: BorderSide(color: Colors.white12,width: 3)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(

                            onTap: () async {String phoneNumber = phone_[index]; // Replace with the actual phone number variable
                            Uri telUrl = Uri.parse("tel:$phoneNumber");

                            // Attempt to launch the URL and show an error message if it fails
                            if (await canLaunchUrl(telUrl)) {
                              await launchUrl(telUrl, mode: LaunchMode.externalApplication);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Could not open the dialer for this number")),
                              );
                            }


                            }, child: Text("Phone",style: GoogleFonts.dmSans(fontWeight: FontWeight.bold)),),
                          InkWell(
                            onTap: () async {
                              String query = Uri.encodeComponent(location_[index]);
                              Uri googleMapsUrl = Uri.parse("https://www.google.com/maps/search/?api=1&query=$query");

                              // Attempt to launch the URL, and show an error message if it fails
                              if (await canLaunchUrl(googleMapsUrl)) {
                                await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Could not open maps for this location")),
                                );
                              }


                            }, child: Text("Location",style: GoogleFonts.dmSans(fontWeight: FontWeight.bold),),),
                          InkWell(
                            onTap: (){
                              _showAdOptionsDialog(index);


                            },child: Text("Apply Now",style: GoogleFonts.dmSans(fontWeight: FontWeight.bold),),),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _showAdOptionsDialog(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Options", style: GoogleFonts.montserrat(fontSize: 18)),
          content: Text("Would you like to request the spot ?",
              style: GoogleFonts.montserrat(fontSize: 14)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel", style: GoogleFonts.montserrat(fontSize: 16, color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                SharedPreferences.getInstance().then((prefs) {
                  prefs.setString("selectedAdId", id_[index]);
                  prefs.setString("phone",phone_ [index]);
                  prefs.setString("price", price_[index]);
                  prefs.setString("photo", photo_[index]);
                  prefs.setString("name", namel_[index]);
                  prefs.setString("place", place_[index]);
                  prefs.setString("category", category_[index]);
                  prefs.setString("location",location_[index]);
                  prefs.setString("customer",Customer[index]);
                  prefs.setString("phoneii", ph);
                  prefs.setString("workername", nameofworker);
                  prefs.setString("payment", payment_[index]);
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>RequestWork()));



                });
              },
              child: Text("Ok", style: GoogleFonts.montserrat(fontSize: 16, color: Colors.teal)),
            ),
          ],
        );
      },
    );
  }
}
