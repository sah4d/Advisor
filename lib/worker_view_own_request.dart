import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
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
      home: WorkerViewOwnRequest(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class WorkerViewOwnRequest extends StatefulWidget {
  const WorkerViewOwnRequest({super.key});

  @override
  State<WorkerViewOwnRequest> createState() => _WorkerViewOwnRequestState();
}

class _WorkerViewOwnRequestState extends State<WorkerViewOwnRequest> {
  _WorkerViewOwnRequestState(){
    prefs();
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
  List<String> payment_ = [];
  List<String> DAtes = [];
  String phonenum="";
Future<void> prefs() async {
  var prefs= await SharedPreferences.getInstance();
  setState(() {
    phonenum=prefs.getString("phonenum").toString();
    print(phonenum);
  });

}
  Future<void> fetchAdsData() async {
    var prefs = await SharedPreferences.getInstance();
    CollectionReference adsRef = FirebaseFirestore.instance.collection(
        "requests");
    QuerySnapshot querySnapshot = await adsRef.where(
        "worker ph", isEqualTo: prefs.getString("phonenum")).get();
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
    List<String> Pyment = [];
    List<String> dates_ = [];
    for (int i = 0; i < adsData.length; i++) {
      final d = adsData[i];
      DocumentReference doc = d['ad'];
      DocumentSnapshot snap = await doc.get();
      String namei = snap['title'].toString();
      String placei = snap['place'].toString();
      String pricei = snap['price'].toString();
      String phonei = snap['phone'].toString();
      String categoriesi = snap['category'].toString();
      String photoi = snap['photo'].toString();
      String Locationi = snap['location'].toString();
      String Customeri = snap['customerph'].toString();
      String paymenti = snap['payment'].toString();
      names.add(namei);
      places.add(placei);
      phones.add(phonei);
      prices.add(pricei);
      categories.add(categoriesi);
      photos.add(photoi);
      Locations.add(Locationi);
      customer.add(Customeri);
      ids.add(d.id);
      Pyment.add(paymenti);
      for(var ad in adsData){
        dates_.add(ad["Date"]);

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
        Customer = customer;
        worker = Worker;
        payment_ = Pyment;
        DAtes=dates_;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Work Requests", style: GoogleFonts.montserrat(fontSize: 18, color: Colors.black87,fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 10,
        automaticallyImplyLeading:  false,
        actions: [
          IconButton(
          onPressed: () {
    fetchAdsData();
    }, icon: Icon(Icons.restart_alt_outlined)),
        ],
      ),
      body:namel_.length==0?
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
            return Column(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(photo_[index]),
                      radius: 45,),
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
                              Text(" "+payment_[index],style: GoogleFonts.montserrat(fontSize: 17,color: Colors.black,),),
                            ],
                          ),
                          SizedBox(height: 5,),
                          Row(
                            children: [Icon(Icons.date_range_outlined),
                              Text(" "+DAtes[index],style: GoogleFonts.montserrat(fontSize: 17,color: Colors.black,),),
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
            ],);
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
          content: Text("Would you like to cancel\n the request ?",
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
                CollectionReference firedb = FirebaseFirestore.instance.collection("requests");
                firedb.doc(id_[index]).delete();
                fetchAdsData();
                Navigator.pop(context);
                Alert(
                  context: context,
                  title: "Request Deleted",style: AlertStyle(isButtonVisible: false,
                    titleStyle: GoogleFonts.dmSans(fontSize: 15)),
                  image: Image.asset("assets/delete.png",height: 70,),
                ).show();
                fetchAdsData();



              },
              child: Text("Ok", style: GoogleFonts.montserrat(fontSize: 16, color: Colors.teal)),
            ),
          ],
        );
      },
    );
  }
}
