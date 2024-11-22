import 'package:advertisement/ad_edit_admin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
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
      home: ViewAdsA(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ViewAdsA extends StatefulWidget {
  const ViewAdsA({super.key});

  @override
  State<ViewAdsA> createState() => _ViewAdsAState();
}

class _ViewAdsAState extends State<ViewAdsA>with TickerProviderStateMixin {
  bool isLoading=true;
  List<String> id_ = [];
  List<String> namel_ = [];
  List<String> place_ = [];
  List<String> phone_ = [];
  List<String> price_ = [];
  List<String> category_ = [];
  List<String> photo_ = [];
  List<String> location_ = [];
  List<String> status = [];
  List<String> assigned = [];
  List<String> customerph = [];
  List<String> worker = [];
  List<String> date_ = [];
  List<String> payment_ = [];

  bool isSearching = false;
  TextEditingController searchController = TextEditingController();
  String searchQuery = "";

  _ViewAdsAState() {
    fetchAdsData();
  }

  Future<void> fetchAdsData() async {
    CollectionReference adsRef = FirebaseFirestore.instance.collection("advertisement");
    QuerySnapshot querySnapshot = await adsRef.where("status", isEqualTo: "available").get();
    final adsData = querySnapshot.docs;

    List<String> ids = [];
    List<String> names = [];
    List<String> places = [];
    List<String> phones = [];
    List<String> prices = [];
    List<String> categories = [];
    List<String> photos = [];
    List<String> Locations = [];
    List<String> Status = [];
    List<String> Assigned = [];
    List<String> Customerph = [];
    List<String> Worker = [];
    List<String> Dates_ = [];
    List<String> Payment = [];

    for (var ad in adsData) {
      ids.add(ad.id);
      names.add(ad['title']);
      places.add(ad['place']);
      prices.add(ad['price']);
      phones.add(ad['phone']);
      categories.add(ad['category']);
      photos.add(ad['photo']);
      Locations.add(ad["location"]);
      Status.add(ad["status"]);
      Assigned.add(ad["assigned"]);
      Customerph.add(ad["customerph"]);
      Worker.add(ad["worker"]);
      Dates_.add(ad["Date"]);
      Payment.add(ad["payment"]);
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
      status = Status;
      assigned = Assigned;
      customerph = Customerph;
      worker = Worker;
      date_=Dates_;
      payment_=Payment;
    });
    setState(() {
      isLoading=false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(flexibleSpace: Container(decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.cyan,Colors.blueGrey,])),),
        automaticallyImplyLeading: false,
        title: isSearching
            ? TextFormField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Search ads by title...',
            hintStyle: TextStyle(color: Colors.white60),
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
          ),
          style: TextStyle(color: Colors.white),
          onChanged: (value) {
            setState(() {
              searchQuery = value.toLowerCase();
            });
          },
        )
            : Text(
          "Available Ads",
          style: GoogleFonts.montserrat(fontSize: 20, color: Colors.black87,fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 10,
        actions: [
          IconButton(
            icon: Icon(isSearching ? Icons.close : Icons.search, color: Colors.white),
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
                searchController.clear();
                searchQuery = "";
              });
            },
          ),
        ],
      ),
      body: isLoading
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
          gradient:LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 0.5, 1.0],
            colors: [
              Colors.white,
              Colors.cyan,
              Colors.white,
            ],
          )
        ),
        child: ListView.builder(
          itemCount: id_.length,
          itemBuilder: (context, index) {
            // Filtering ads by title
            if (namel_[index].toLowerCase().contains(searchQuery)) {
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
                          Text("Payment : "+payment_[index],style: GoogleFonts.montserrat(fontSize:18,fontWeight: FontWeight.bold),),
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

                              onPressed: () async {
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
                          IconButton(color: Colors.red,
                            onPressed: ()async{
                              _showDeleteConfirmationDialog(index);



                            }, icon: Icon(Icons.delete,),iconSize: 30,tooltip: "Delete",),
                          IconButton(color: Colors.black,
                            onPressed: (){
                              _showAdOptionsDialog(index);


                            }, icon: Icon(Icons.edit,),iconSize: 30,tooltip: "More",),
                        ],
                      ),
                    ),
                    Divider(thickness: 2,height: 25,)
                  ],
                ),
              );
            } else {
              return Container(); // Hide if the title doesn't match the search query
            }
          },
        ),
      ),
    );
  }

  void _showAdOptionsDialog(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(backgroundColor: Colors.greenAccent,
          title: Text("Options", style: GoogleFonts.montserrat(fontSize: 18)),
          content: Text("Would you like to edit the ad?", style: GoogleFonts.montserrat(fontSize: 14)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel", style: GoogleFonts.montserrat(fontSize: 16, color: Colors.red)),
            ),
            TextButton(
              onPressed: () async {
                SharedPreferences shii = await SharedPreferences.getInstance();
                shii.setString("adid", id_[index]).toString();
                shii.setString("title", namel_[index]).toString();
                shii.setString("location", location_[index]).toString();
                shii.setString("price", price_[index]).toString();
                shii.setString("place", place_[index]).toString();
                shii.setString("category", category_[index]).toString();
                shii.setString("phonenumber", phone_[index]).toString();
                shii.setString("payment", payment_[index]).toString();
                shii.setString("adphoto", photo_[index]).toString();

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Ad_spotE()),
                );
              },
              child: Text("Ok", style: GoogleFonts.montserrat(fontSize: 16, color: Colors.teal)),
            ),
          ],
        );
      },
    );
  }
  Future<void> _deleteAd(int index) async {
    try {
      CollectionReference adsRef = FirebaseFirestore.instance.collection("advertisement");
      await adsRef.doc(id_[index]).delete();
      fetchAdsData(); // Refresh the ads list after deletion
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Advertisement deleted successfully")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete advertisement: $e")),
      );
    }
  }

  void _showDeleteConfirmationDialog(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Confirm Delete",
            style: GoogleFonts.montserrat(fontSize: 18),
          ),
          content: Text(
            "Are you sure you want to delete this advertisement?",
            style: GoogleFonts.montserrat(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text(
                "Cancel",
                style: GoogleFonts.montserrat(fontSize: 16, color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () async {
                await _deleteAd(index); // Call the delete function
                Navigator.pop(context);
                Alert(
                  context: context,
                  title: "Ad Deleted",style: AlertStyle(isButtonVisible: false,
                    titleStyle: GoogleFonts.dmSans(fontSize: 15)),
                  image: Image.asset("assets/trash.png",height: 50,),
                ).show();// Close the dialog
              },
              child: Text(
                "Delete",
                style: GoogleFonts.montserrat(fontSize: 16, color: Colors.teal),
              ),
            ),
          ],
        );
      },
    );
  }

}

