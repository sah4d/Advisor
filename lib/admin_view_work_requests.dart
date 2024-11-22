import 'package:advertisement/user_home.dart';
import 'package:advertisement/work_request_admin.dart';
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
      home: ViewWorkRequests(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ViewWorkRequests extends StatefulWidget {
  const ViewWorkRequests({super.key});

  @override
  State<ViewWorkRequests> createState() => _ViewWorkRequestsState();
}

class _ViewWorkRequestsState extends State<ViewWorkRequests> {
  _ViewWorkRequestsState(){
    fetchAdsData();
  }
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
  List<String> workerphone_ = [];
  List<String> docid = [];
  List<String> date_ = [];
  List<String> pay_ = [];
  bool isLoading=true;


  Future<void> fetchAdsData() async {
    CollectionReference adsRef = FirebaseFirestore.instance.collection("requests");
    QuerySnapshot querySnapshot = await adsRef.where("selected",isEqualTo: "Not Selected").get();
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
    List<String> Dates = [];
    List<String> workerphone = [];
    List<String> DocId = [];
    List<String> Pay = [];
    for(int i=0;i<adsData.length;i++){
      final d=adsData[i];
      DocumentReference doc=d['ad'];
      DocumentSnapshot snap=await doc.get();
      String namei=snap['title'].toString();
      String  placei=snap['place'].toString();
      String  pricei=snap['price'].toString();
      String  phonei=snap['phone'].toString();
      String  categoriesi=snap['category'].toString();
      String  photoi=snap['photo'].toString();
      String Locationi=snap['location'].toString();
      String Customeri=snap['customerph'].toString();
      String paymenti=snap['payment'].toString();
      names.add(namei);
      places.add(placei);
      phones.add(phonei);
      prices.add(pricei);
      categories.add(categoriesi);
      photos.add(photoi);
      Locations.add(Locationi);
      customer.add(Customeri);
      Pay.add(paymenti);
      ids.add(d.id);
      DocId.add(doc.id);
      print(doc.id);



    }

    for (var ad in adsData) {
      workerphone.add(ad['worker ph']);
      Worker.add(ad['worker name']);
      Dates.add(ad['Date']);
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
      workerphone_=workerphone;
      docid=DocId;
      date_=Dates;
      pay_=Pay;

    });
    setState(() {
      isLoading=false;
    });
    print(namel_);
    print(Customer);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: ()async {
      Navigator.of(context).pop();
      return false;

    },
      child: Scaffold(
        appBar: AppBar(automaticallyImplyLeading: false,
          title: Text("Work Requests", style: GoogleFonts.montserrat(fontSize: 20, color: Colors.black87,fontWeight: FontWeight.bold)),
          backgroundColor: Colors.transparent,
          elevation: 10,
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
            gradient: LinearGradient(
              colors: [Colors.teal, Colors.tealAccent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: ListView.builder(
            itemCount: id_.length,
            itemBuilder: (context, index) {
              return Card(
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
                              children: [Icon(Icons.location_on_outlined),
                                Text(" "+location_[index],style: GoogleFonts.montserrat(),),
                              ],
                            ),
                            SizedBox(height: 5,),
                            Row(
                              children: [Icon(Icons.currency_rupee_outlined),
                                Text(pay_[index],style: GoogleFonts.montserrat(fontSize: 17,color: Colors.black,),),
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
                          ],
                        ),
                      )),
                      Column(
                        children: [
                          IconButton(onPressed: (){
                            _showAdOptionsDialog(index);
                          }, icon: Icon(Icons.more_vert_outlined)),
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
                Divider()
                ],),
                      Card(color: Colors.tealAccent,
                        margin: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        elevation: 6,
                        child: Padding(
                          padding:
                          const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                          child: Column(
                            children: [
                              ProfileDetailRow(
                                  icon: Icons.add_alert, label: "Requested By", value: worker[index]),
                              const Divider(),
                              ProfileDetailRow(
                                  icon: Icons.phone_android_outlined, label: "Phone", value: workerphone_[index]),
                            ],
                          ),
                        ),
                      ),
                    ]

                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _showAdOptionsDialog(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Assign Work to", style: GoogleFonts.montserrat(fontSize: 18)),
          content: Text(worker[index],
              style: GoogleFonts.montserrat(fontSize: 14,fontWeight: FontWeight.bold)),
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

                  prefs.setString("selectedAdId", docid[index]);
                  prefs.setString("requestId", id_[index]);
                  prefs.setString("phone",phone_ [index]);
                  prefs.setString("price", price_[index]);
                  prefs.setString("photo", photo_[index]);
                  prefs.setString("name", namel_[index]);
                  prefs.setString("place", place_[index]);
                  prefs.setString("category", category_[index]);
                  prefs.setString("location",location_[index]);
                  prefs.setString("customer",Customer[index]);
                  prefs.setString("worker",workerphone_[index]);
                  prefs.setString("payment",pay_[index]);
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>RequestWorkA()));



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
