
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'firebase_options.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';

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
      home: BookedAds1(), // Removed passing context to BookedAds
      debugShowCheckedModeBanner: false,
    );
  }
}

class BookedAds1 extends StatefulWidget {
  const BookedAds1({super.key}); // Removed context from constructor

  @override
  State<BookedAds1> createState() => _BookedAds1State();
}

class _BookedAds1State extends State<BookedAds1> {
  _BookedAds1State() {
    prefs();
    fetchAdsData();
  }

  String ph = "";
  Future<void> prefs() async {
    var prefs = await SharedPreferences.getInstance();
    ph = prefs.getString("user11").toString();
    print(ph);
  }

  List<String> id_ = [];
  List<String> namel_ = [];
  List<String> place_ = [];
  List<String> phone_ = [];
  List<String> price_ = [];
  List<String> category_ = [];
  List<String> photo_ = [];
  List<String> location_ = [];
  List<String> date_ = [];
  bool isLoading=true;

  Future<void> fetchAdsData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    CollectionReference adsRef =
    FirebaseFirestore.instance.collection("advertisement");
    QuerySnapshot querySnapshot = await adsRef
        .where("status", isEqualTo: "Booked")
        .where("customerph", isEqualTo: pref.getString("user11").toString())
        .get();
    final adsData = querySnapshot.docs;

    List<String> ids = [];
    List<String> names = [];
    List<String> places = [];
    List<String> phones = [];
    List<String> prices = [];
    List<String> categories = [];
    List<String> photos = [];
    List<String> Locations = [];
    List<String> Datess = [];

    for (var ad in adsData) {
      ids.add(ad.id);
      names.add(ad['title']);
      places.add(ad['place']);
      prices.add(ad['price']);
      phones.add(ad['phone']);
      categories.add(ad['category']);
      photos.add(ad['photo']);
      Locations.add(ad["location"]);
      Datess.add(ad["Date"]);
    }

    setState(() {
      id_ = ids;
      namel_ = names;
      place_ = places;
      phone_ = phones;
      price_ = prices;
      category_ = categories;
      photo_ = photos;
      location_ = Locations;
      date_ = Datess;
    });
    setState(() {
      isLoading=false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Booked Ads",
          style: GoogleFonts.montserrat(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        backgroundColor: Colors.transparent,
        elevation: 10,
      ),
      body:  isLoading
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
            return Column(
              children: [
                Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  elevation: 3,
                  margin: EdgeInsets.only(bottom: 0),
                  child: Stack(
                    children: [
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(photo_[index]),
                                fit: BoxFit.cover)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              namel_[index],
                              style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              place_[index],
                              style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Card(
                  color: Colors.tealAccent,
                  margin: const EdgeInsets.symmetric(vertical: 0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  elevation: 6,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.location_on_outlined,
                                color: Colors.black54),
                            const SizedBox(width: 10),
                            InkWell(onTap: () async {
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

                            },
                              child: Text(
                                "Location ::",
                                style: GoogleFonts.teko(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              location_[index],
                              style: GoogleFonts.teko(
                                fontSize: 18,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                        Row(
                          children: [
                            Icon(Icons.phone,
                                color: Colors.black54),
                            const SizedBox(width: 10),
                            InkWell(onLongPress: () async {
                              String phoneNumber = phone_[index]; // Replace with the actual phone number variable
                              Uri telUrl = Uri.parse("tel:$phoneNumber");

                              // Attempt to launch the URL and show an error message if it fails
                              if (await canLaunchUrl(telUrl)) {
                                await launchUrl(telUrl, mode: LaunchMode.externalApplication);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Could not open the dialer for this number")),
                                );
                              }

                            },
                              child: Text(
                                "Phone ::",
                                style: GoogleFonts.teko(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              phone_[index],
                              style: GoogleFonts.teko(
                                fontSize: 18,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                        Row(
                          children: [
                            Icon(Icons.done,
                                color: Colors.black54),
                            const SizedBox(width: 10),
                            Text(
                              "Paid",
                              style: GoogleFonts.teko(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              price_[index],
                              style: GoogleFonts.teko(
                                fontSize: 18,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                        Row(
                          children: [
                            Icon(Icons.location_on_outlined,
                                color: Colors.black54),
                            const SizedBox(width: 10),
                            Text(
                              "Booked Date ::",
                              style: GoogleFonts.teko(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              date_[index],
                              style: GoogleFonts.teko(
                                fontSize: 18,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

}
