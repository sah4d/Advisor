import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
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
      home: payhisWA(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class payhisWA extends StatefulWidget {
  const payhisWA({super.key});

  @override
  State<payhisWA> createState() => _payhisWAState();
}

class _payhisWAState extends State<payhisWA> {
  _payhisWAState() {
    fetchAdsData();
  }
  String ph="";

  List<String> id_ = [];
  List<String> namel_ = [];
  List<String> place_ = [];
  List<String> phone_ = [];
  List<String> price_ = [];
  List<String> category_ = [];
  List<String> photo_ = [];
  List<String> location_ = [];
  List<String> worker = [];
  List<String> customer = [];
  List<String> _paymentid = [];
  List<String> _paymentamount = [];
  List<String> paydate_ = [];
  bool isLoading=true;


  Future<void> fetchAdsData() async {
    CollectionReference adsRef = FirebaseFirestore.instance.collection("paymentsworker");
    QuerySnapshot querySnapshot = await adsRef.get();
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
    List<String> Customer = [];
    List<String> Payid = [];
    List<String> Payamount = [];
    List<String> Paydate = [];

    for(int i=0;i<adsData.length;i++){
      final d=adsData[i];
      DocumentReference doc=d['adreference'];
      DocumentSnapshot snap=await doc.get();
      String namei=snap['title'].toString();
      String  placei=snap['place'].toString();
      String  pricei=snap['price'].toString();
      String  phonei=snap['phone'].toString();
      String  categoriesi=snap['category'].toString();
      String  photoi=snap['photo'].toString();
      String Locationi=snap['location'].toString();
      String Workeri=snap['worker'].toString();
      String Customeri=snap['customerph'].toString();

      names.add(namei);
      places.add(placei);
      prices.add(pricei);
      phones.add(phonei);
      categories.add(categoriesi);
      photos.add(photoi);
      Locations.add(Locationi);
      Worker.add(Workeri);
      Customer.add(Customeri);
      ids.add(d.id);
    }
    for(var ad in adsData){
      Payid.add(ad["payment id"]);
      Payamount.add(ad["amount"]);
      Paydate.add(ad["Date"]);

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
      _paymentid=Payid;
      _paymentamount=Payamount;
      paydate_=Paydate;

    });
    setState(() {
      isLoading=false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(flexibleSpace: Container(decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blueGrey, Colors.grey[200]!],
          begin: Alignment.bottomRight,
          end: Alignment.bottomLeft,
        ),
      ),

      ),
        automaticallyImplyLeading: false,
        title: Text("Payment History Worker", style: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.black87)),
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
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
        ),
        child: ListView.builder(
          itemCount: id_.length,
          itemBuilder: (context, index) {
            return InkWell(onTap: (){
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
                          Text(_paymentamount[index],style: GoogleFonts.montserrat(fontSize: 25,fontWeight: FontWeight.bold),),
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
                                    Text(paydate_[index],style: GoogleFonts.teko(fontSize: 17),)
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
                                    Text("Customer phone :",style: GoogleFonts.teko(fontSize: 17),),
                                    Spacer(),
                                    Text(customer[index],style: GoogleFonts.teko(fontSize: 17),)
                                  ],),
                                  SizedBox(height: 10,),
                                  Row(children: [
                                    Icon(Icons.work),
                                    SizedBox(width: 10,),
                                    Text("Worker phone :",style: GoogleFonts.teko(fontSize: 17),),
                                    Spacer(),
                                    Text(worker[index],style: GoogleFonts.teko(fontSize: 17),)
                                  ],),
                                  SizedBox(height: 10,),
                                  Row(children: [
                                    Icon(Icons.currency_rupee_outlined),
                                    SizedBox(width: 10,),
                                    Text("Payment :",style: GoogleFonts.teko(fontSize: 17),),
                                    Spacer(),
                                    Text(_paymentamount[index],style: GoogleFonts.teko(fontSize: 17),)
                                  ],),
                                  SizedBox(height: 10,),
                                  Row(children: [
                                    InkWell(
                                      child: Icon(Icons.copy_all),
                                      onTap: () async {
                                        await Clipboard.setData(ClipboardData(text:_paymentid[index]));
                                        CoolAlert.show(context: context, type: CoolAlertType.success,
                                            text: "Copied to Clipboard");
                                      },),
                                    SizedBox(width: 10,),
                                    Text("Payment ID :",style: GoogleFonts.teko(fontSize: 17),),
                                    Spacer(),
                                    Text(_paymentid[index],style: GoogleFonts.teko(fontSize: 17),)
                                  ],),

                                  SizedBox(height: 10,),
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
              child: Column(children: [
                Padding(
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
                          Text(worker[index],style: GoogleFonts.montserrat(),),
                        ],
                      )),
                      Text(_paymentamount[index],style: GoogleFonts.montserrat(fontSize: 20,color: Colors.red,fontWeight: FontWeight.bold),)
                    ],

                  ),
                ),
                Divider()
              ],),
            );
          },
        ),
      ),
    );
  }
}
