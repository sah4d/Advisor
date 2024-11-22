import 'package:advertisement/admin_booking_cancel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
      home: AdminBookedAds(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AdminBookedAds extends StatefulWidget {
  const AdminBookedAds({super.key});

  @override
  State<AdminBookedAds> createState() => _AdminBookedAdsState();
}

class _AdminBookedAdsState extends State<AdminBookedAds> {
  String ph = "";
  String searchQuery = ""; // Search query
  TextEditingController searchController = TextEditingController(); // Controller for search input

  List<String> id_ = [];
  bool isLoading=true;
  List<String> namel_ = [];
  List<String> place_ = [];
  List<String> phone_ = [];
  List<String> price_ = [];
  List<String> category_ = [];
  List<String> photo_ = [];
  List<String> location_ = [];
  List<String> customer = [];
  List<String> date_ = [];
  List<String> filteredNamel_ = [];
  // Filtered list for search results

  Future<void> prefs() async {
    var prefs = await SharedPreferences.getInstance();
    ph = prefs.getString("phonenum").toString();
  }

  Future<void> fetchAdsData() async {
    CollectionReference adsRef = FirebaseFirestore.instance.collection("advertisement");
    QuerySnapshot querySnapshot = await adsRef.where("status", isEqualTo: "Booked").where("assigned", isEqualTo: "pending").get();
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
    List<String> customerList = [];

    for (var ad in adsData) {
      ids.add(ad.id);
      names.add(ad['title']);
      places.add(ad['place']);
      phones.add(ad['phone']);
      prices.add(ad['price']);
      categories.add(ad['category']);
      photos.add(ad['photo']);
      Locations.add(ad['location']);
      Dates.add(ad['Date']);
      customerList.add(ad['customerph']);
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
      customer = customerList;
      date_=Dates;
      filteredNamel_ = names; // Initialize filtered list
    });
    setState(() {
      isLoading=false;
    });
  }

  // Method to filter ads based on the search query
  void filterAds(String query) {
    List<String> filteredNames = namel_.where((name) => name.toLowerCase().contains(query.toLowerCase())).toList();
    setState(() {
      searchQuery = query;
      filteredNamel_ = filteredNames;
    });
  }

  @override
  void initState() {
    super.initState();
    prefs();
    fetchAdsData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          searchQuery.isEmpty ? "Booked Ads" : "Search Results", // Update title based on search state
          style: GoogleFonts.montserrat(fontSize: 20, color: Colors.black87,fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 10,

        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.black87),
            onPressed: () {
              _showSearchDialog(); // Open the search dialog when icon is clicked
            },
          ),
        ],
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
          itemCount: filteredNamel_.length, // Use filtered list for display
          itemBuilder: (context, index) {
            int originalIndex = namel_.indexOf(filteredNamel_[index]); // Get the original index from the main list
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
                              place_[index]+" || "+category_[index],
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
                            InkWell(onTap: (){
                              _showAdOptionsDialog(index);
                            },
                              child: Text(
                                "Booked Date ::",
                                style: GoogleFonts.teko(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
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
                        const Divider(),
                        Row(
                          children: [
                            Icon(Icons.verified_user,
                                color: Colors.black54),
                            const SizedBox(width: 10),
                            InkWell(onTap: () async {
                              String phoneNumber = customer[index]; // Replace with the actual phone number variable
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
                                "Booked by",
                                style: GoogleFonts.teko(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              customer[index],
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

  // Dialog for entering search query
  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Search Ads', style: GoogleFonts.montserrat(fontSize: 18)),
          content: TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'Enter title to search',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel', style: GoogleFonts.montserrat(fontSize: 16)),
            ),
            TextButton(
              onPressed: () {
                filterAds(searchController.text); // Filter based on input
                Navigator.pop(context);
              },
              child: Text('Search', style: GoogleFonts.montserrat(fontSize: 16)),
            ),
          ],
        );
      },
    );
  }

  void _showAdOptionsDialog(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Options", style: GoogleFonts.montserrat(fontSize: 18)),
          content: Text("Would you like to cancel spot?", style: GoogleFonts.montserrat(fontSize: 14)),
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
                  prefs.setString("phone", phone_[index]);
                  prefs.setString("price", price_[index]);
                  prefs.setString("photo", photo_[index]);
                  prefs.setString("name", namel_[index]);
                  prefs.setString("place", place_[index]);
                  prefs.setString("category", category_[index]);
                  prefs.setString("location", location_[index]);
                  prefs.setString("customer", customer[index]);
                  prefs.setString("phoneii", ph);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CancelBooking()));
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
