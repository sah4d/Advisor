import 'package:advertisement/payment_menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewAds extends StatefulWidget {
  const ViewAds({super.key});

  @override
  State<ViewAds> createState() => _ViewAdsState();
}

class _ViewAdsState extends State<ViewAds> {
  _ViewAdsState() {
    prefs();
    fetchAdsData();
  }

  String ph = "";
  String searchQuery = ""; // This will store the search input
  bool isSearching = false; // Toggle for showing search bar

  final TextEditingController searchController = TextEditingController(); // Search text controller

  Future<void> prefs() async {
    var prefs = await SharedPreferences.getInstance();
    ph = prefs.getString("lid11").toString();
  }
  bool isLoading=true;

  List<String> id_ = [];
  List<String> namel_ = [];
  List<String> place_ = [];
  List<String> phone_ = [];
  List<String> price_ = [];
  List<String> category_ = [];
  List<String> photo_ = [];
  List<String> location_ = [];
  List<String> date_ = [];

  // Fetches ads data from Firestore with an optional search query
  Future<void> fetchAdsData([String query = ""]) async {
    CollectionReference adsRef = FirebaseFirestore.instance.collection("advertisement");
    QuerySnapshot querySnapshot;

    // Search functionality: query Firestore with title
    if (query.isNotEmpty) {
      querySnapshot = await adsRef
          .where("status", isEqualTo: "available")
          .where("title", isGreaterThanOrEqualTo: query)
          .where("title", isLessThanOrEqualTo: "$query\uf8ff") // Ensures partial matches
          .get();
    } else {
      querySnapshot = await adsRef.where("status", isEqualTo: "available").get();
    }

    final adsData = querySnapshot.docs;

    List<String> ids = [];
    List<String> names = [];
    List<String> places = [];
    List<String> phones = [];
    List<String> prices = [];
    List<String> categories = [];
    List<String> photos = [];
    List<String> Locations = [];
    List<String> Date = [];

    for (var ad in adsData) {
      ids.add(ad.id);
      names.add(ad['title']);
      places.add(ad['place']);
      prices.add(ad['price']);
      phones.add(ad['phone']);
      categories.add(ad['category']);
      photos.add(ad['photo']);
      Locations.add(ad["location"]);
      Date.add(ad["Date"]);
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
      date_=Date;
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
        title: isSearching
            ? TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: "Search ads by title...",
            hintStyle: GoogleFonts.montserrat(fontSize: 18, color: Colors.black87),
            border: InputBorder.none,
          ),
          style: GoogleFonts.montserrat(fontSize: 18, color: Colors.black87),
          onChanged: (value) {
            setState(() {
              searchQuery = value;
              fetchAdsData(searchQuery); // Fetch ads based on search query
            });
          },
        )
            : Text(
          "Available Ads",
          style: GoogleFonts.montserrat(fontSize: 20,fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          // Search Icon
          IconButton(
            icon: Icon(isSearching ? Icons.clear : Icons.search, color: Colors.black87),
            onPressed: () {
              setState(() {
                if (isSearching) {
                  // Reset search when search is cleared
                  searchController.clear();
                  searchQuery = "";
                  fetchAdsData(); // Fetch all ads when cleared
                }
                isSearching = !isSearching;
              });
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
          image: DecorationImage(image: AssetImage("assets/black.jpg",),fit: BoxFit.cover)
        ),
        child: ListView.builder(
          itemCount: id_.length,
          itemBuilder: (context, index) {
            return Container(
              child: Column(
                children: [
                  Card(clipBehavior: Clip.antiAliasWithSaveLayer,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1),
                        side: BorderSide(color: Colors.white12,width: 2)),
                    elevation: 5,
                    child: ListTile(
                      title: Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children:[StrokeText(strokeWidth: 3,strokeColor: Colors.black38,
                              text: namel_[index].toUpperCase(),textStyle: GoogleFonts.montserrat(fontSize: 30,
                                  color: Colors.white,fontWeight: FontWeight.bold)),
                            Text(place_[index].toUpperCase(),style: GoogleFonts.montserrat(fontSize:18,fontWeight: FontWeight.bold),),

                          ]
                      ),
                      subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [Divider(thickness: 2,),
                          Text("Price : "+price_[index],style: GoogleFonts.montserrat(fontSize:18,fontWeight: FontWeight.bold),),
                          Text("Date :"+date_[index],style: GoogleFonts.montserrat(fontSize:15,fontWeight: FontWeight.bold),),
                        ],),


                    ),
                  ),

                  Card(elevation: 5,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1),
                        side: BorderSide(color: Colors.white12,width: 3)),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Container(height: 300,decoration: BoxDecoration(image: DecorationImage(image: NetworkImage(photo_[index]),fit: BoxFit.cover
                    )),
                    ),
                  ),
                  Card(elevation: 5,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1)),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(color: Colors.black,

                          onPressed: () async {String phoneNumber = phone_[index]; // Replace with the actual phone number variable
                          Uri telUrl = Uri.parse("tel:$phoneNumber");

                          // Attempt to launch the URL and show an error message if it fails
                          if (await canLaunchUrl(telUrl)) {
                            await launchUrl(telUrl, mode: LaunchMode.externalApplication);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Could not open the dialer for this number")),
                            );
                          }


                          }, icon: Icon(Icons.phone,),iconSize: 30,tooltip: "Phone Number",),
                        IconButton(color: Colors.black,
                          onPressed: () async {
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


                          }, icon: Icon(Icons.location_on_outlined,),iconSize: 30,),
                        IconButton(color: Colors.black,
                          onPressed: (){
                            _showAdOptionsDialog(index);


                          }, icon: Icon(Icons.bookmark_add_outlined,),iconSize: 30,tooltip: "More",),
                      ],
                    ),
                  ),
                  Divider(thickness: 2,height: 25,)
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
          content: Text("Would you like to book the spot?", style: GoogleFonts.montserrat(fontSize: 14)),
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
                  prefs.setString("phoneii", ph);

                  Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentPage()));
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
