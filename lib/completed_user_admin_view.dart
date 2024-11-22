import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
      home: BookedAdsU1(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class BookedAdsU1 extends StatefulWidget {
  const BookedAdsU1({super.key});

  @override
  State<BookedAdsU1> createState() => _BookedAdsU1State();
}

class _BookedAdsU1State extends State<BookedAdsU1> {
  _BookedAdsU1State() {
    prefs();
    fetchAdsData();
  }
  String ph="";
  Future<void> prefs() async {
    var prefs= await SharedPreferences.getInstance();
    ph=prefs.getString("user11").toString();
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
  List<String> worker = [];
  List<String> payment_ = [];
  List<String> customer = [];
  List<String> Dateii = [];
  bool isLoading=true;

  Future<void> fetchAdsData() async {
    SharedPreferences pref=await SharedPreferences.getInstance();
    CollectionReference adsRef = FirebaseFirestore.instance.collection("completed");
    QuerySnapshot querySnapshot = await adsRef.where("customer phone", isEqualTo: pref.getString("user11").toString()).get();
    final adsData = querySnapshot.docs;


    List<String> ids = [];
    List<String> names = [];
    List<String> places = [];
    List<String> phones = [];
    List<String> prices = [];
    List<String> categories = [];
    List<String> photos = [];
    List<String> Locations = [];
    List<String> Worker = [];
    List<String> Dates = [];
    List<String> Customer = [];

    for(int i=0;i<adsData.length;i++){
      final d=adsData[i];
      DocumentReference doc=d['adlink'];
      DocumentSnapshot snap=await doc.get();
      String namei=snap['title'].toString();
      String  placei=snap['place'].toString();
      String  pricei=snap['price'].toString();
      String  phonei=snap['phone'].toString();
      String  categoriesi=snap['category'].toString();
      String  photoi=snap['photo'].toString();
      String Locationi=snap['location'].toString();
      String Workeri=snap['worker'].toString();
      String Datesi=snap['Date'].toString();
      String Customeri=snap['customerph'].toString();
      names.add(namei);
      places.add(placei);
      prices.add(pricei);
      phones.add(phonei);
      categories.add(categoriesi);
      photos.add(photoi);
      Locations.add(Locationi);
      Dates.add(Datesi);
      Worker.add(Workeri);
      Customer.add(Customeri);
      ids.add(d.id);
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
      customer=Customer;
      worker=Worker;
      Dateii=Dates;
    });
    setState(() {
      isLoading=false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false,
        title: Text("Completed works", style: GoogleFonts.montserrat(fontSize: 20,fontWeight: FontWeight.bold, color: Colors.black87)),
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
            colors: [Colors.white, Colors.grey[200]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView.builder(
          itemCount: id_.length,
          itemBuilder: (context, index) {
            return  Card(
              child: InkWell(onTap: (){
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => Dialog.fullscreen(
                      child: Container(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Card(elevation: 10,
                              shape: CircleBorder(side: BorderSide(color: Colors.teal,width: 2)),
                              child: CircleAvatar(radius: 70,
                                backgroundImage: NetworkImage(photo_[index]),),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(namel_[index],style: GoogleFonts.montserrat(fontWeight: FontWeight.w400,fontSize: 22,),),
                            ),
                            Text(price_[index],style: GoogleFonts.montserrat(fontSize: 25,fontWeight: FontWeight.bold),),
                            Divider(),

                            Container(decoration: BoxDecoration(border: Border.all(width: 1),
                                borderRadius: BorderRadius.circular(35)),
                              padding:EdgeInsets.symmetric(vertical: 16),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 20),
                                child: Column(
                                  children: [
                                    Row(children: [
                                      Icon(Icons.date_range_outlined),
                                      SizedBox(width: 10,),
                                      Text("Completed Date :",style: GoogleFonts.teko(fontSize: 17),),
                                      Spacer(),
                                      Text(Dateii[index],style: GoogleFonts.teko(fontSize: 17),)
                                    ],),
                                    SizedBox(height: 10,),
                                    Row(children: [
                                      Icon(Icons.location_on_outlined),
                                      SizedBox(width: 10,),
                                      Text("Place :",style: GoogleFonts.teko(fontSize: 17),),
                                      Spacer(),
                                      Text(place_[index],style: GoogleFonts.teko(fontSize: 17),)
                                    ],),
                                    SizedBox(height: 10,),
                                    Row(children: [
                                      Icon(Icons.phone),
                                      SizedBox(width: 10,),
                                      Text("Phone :",style: GoogleFonts.teko(fontSize: 17),),
                                      Spacer(),
                                      Text(phone_[index],style: GoogleFonts.teko(fontSize: 17),)
                                    ],),
                                    SizedBox(height: 10,),
                                    Row(children: [
                                      Icon(Icons.person),
                                      SizedBox(width: 10,),
                                      Text("worker phone :",style: GoogleFonts.teko(fontSize: 17),),
                                      Spacer(),
                                      Text(worker[index],style: GoogleFonts.teko(fontSize: 17),)
                                    ],),
                                    SizedBox(height: 10,),
                                    Row(children: [
                                      Icon(Icons.currency_rupee_outlined),
                                      SizedBox(width: 10,),
                                      Text("price :",style: GoogleFonts.teko(fontSize: 17),),
                                      Spacer(),
                                      Text(price_[index],style: GoogleFonts.teko(fontSize: 17),)
                                    ],), SizedBox(height: 10,),
                                    Row(children: [
                                      Icon(Icons.category),
                                      SizedBox(width: 10,),
                                      Text("Category :",style: GoogleFonts.teko(fontSize: 17),),
                                      Spacer(),
                                      Text(category_[index],style: GoogleFonts.teko(fontSize: 17),)
                                    ],),

                                  ],
                                ),
                              ),
                            ),


                          ],
                        ),
                      )
                  ),
                );

              },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(photo_[index]),
                        radius: 30,),
                      SizedBox(width: 15,),

                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(namel_[index],style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,fontSize: 17),),
                          Text(place_[index]+" | "+category_[index],style: GoogleFonts.montserrat(),),
                        ],
                      )
                      ),
                      Icon(Icons.verified_user,color: Colors.green,)
                    ],



                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
