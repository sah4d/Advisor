import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      home: Accepted(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Accepted extends StatefulWidget {
  const Accepted({super.key});

  @override
  State<Accepted> createState() => _AcceptedState();
}

class _AcceptedState extends State<Accepted> {
  _AcceptedState(){
    fetchAdsData();
  }
  bool isLoading = true;
  List<String> id_ = [];

  List<String> namel_ = [];
  List<String> place_ = [];
  List<String> phone_ = [];
  List<String> price_ = [];
  List<String> category_ = [];
  List<String> photo_ = [];
  List<String> location_ = [];
  List<String> Customer = [];
  List<String> worker = [];
  List<String> date_ = [];

  Future<void> fetchAdsData() async {
    CollectionReference adsRef = FirebaseFirestore.instance.collection("advertisement");
    QuerySnapshot querySnapshot = await adsRef.where("status", isEqualTo: "Booked").where("assigned", isEqualTo: "accepted").get();
    final adsData = querySnapshot.docs;

    List<String> ids = [];
    List<String> names = [];
    List<String> places = [];
    List<String> phones = [];
    List<String> prices = [];
    List<String> categories = [];
    List<String> photos = [];
    List<String> Locations = [];
    List<String> customer = [];
    List<String> Worker = [];
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
      customer.add(ad["customerph"]);
      Worker.add(ad["worker"]);
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
      location_=Locations;
      Customer=customer;
      worker=Worker;
      date_=Datess;

    });
    setState(() {
      isLoading=false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Works Accepted", style: GoogleFonts.montserrat(fontSize: 20, color: Colors.black87,fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 10,
        automaticallyImplyLeading: false,
      ),
      body:isLoading?
          Center(
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
            return  Card(
              elevation: 10,shadowColor: Colors.cyan,
              child: Padding(
                padding:EdgeInsets.all(8),
                child: Column(
                    children:[
                      Column(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(photo_[index]),
                                radius: 40,),
                              SizedBox(width: 15,),

                              Expanded(child: SingleChildScrollView(scrollDirection: Axis.horizontal,
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(namel_[index],style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,fontSize: 17),),
                                    Row(
                                      children: [InkWell(child: Icon(Icons.location_on_outlined),
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
                                      },),
                                        Text(" "+location_[index],style: GoogleFonts.montserrat(),),
                                      ],
                                    ),
                                    SizedBox(height: 5,),
                                    Row(
                                      children: [Icon(Icons.date_range_outlined),
                                        Text(" "+date_[index],style: GoogleFonts.montserrat(fontSize: 17,color: Colors.black,),),
                                      ],
                                    ),
                                    SizedBox(height: 5,),
                                    Row(
                                      children: [Icon(Icons.phone),
                                        Text(" "+Customer[index],style: GoogleFonts.montserrat(fontSize: 17,color: Colors.black,),),
                                      ],
                                    ),
                                    SizedBox(height: 5,),
                                    Row(
                                      children: [Icon(Icons.work),
                                        Text(" "+worker[index],style: GoogleFonts.montserrat(fontSize: 17,color: Colors.black,),),
                                      ],
                                    ),
                                  ],
                                ),
                              )),
                              Column(
                                children: [
                                  IconButton(onPressed: () async {
                                    String phoneNumber = worker[index]; // Replace with the actual phone number variable
                                    Uri telUrl = Uri.parse("tel:$phoneNumber");

                                    // Attempt to launch the URL and show an error message if it fails
                                    if (await canLaunchUrl(telUrl)) {
                                    await launchUrl(telUrl, mode: LaunchMode.externalApplication);
                                    } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Could not open the dialer for this number")),
                                    );
                                    }

                                  }, icon: Icon(Icons.work)),
                                  IconButton(onPressed: () async {
                                    String phoneNumber = Customer[index]; // Replace with the actual phone number variable
                                    Uri telUrl = Uri.parse("tel:$phoneNumber");

                                    // Attempt to launch the URL and show an error message if it fails
                                    if (await canLaunchUrl(telUrl)) {
                                      await launchUrl(telUrl, mode: LaunchMode.externalApplication);
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text("Could not open the dialer for this number")),
                                      );
                                    }
                                  }, icon: Icon(Icons.phone))
                                ],
                              )
                            ],

                          ),
                        ),
                      ],),
                    ]

                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
