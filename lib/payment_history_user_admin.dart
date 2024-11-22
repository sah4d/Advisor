import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
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
      home: payhisUA(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class payhisUA extends StatefulWidget {
  const payhisUA({super.key});

  @override
  State<payhisUA> createState() => _payhisUAState();
}

class _payhisUAState extends State<payhisUA> {
  _payhisUAState() {
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
    CollectionReference adsRef = FirebaseFirestore.instance.collection("payments");
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
        title: Text("Payment History User", style: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.black87)),
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
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
        ),
        child: ListView.builder(
          itemCount: id_.length,
          itemBuilder: (context, index) {
            return InkWell(onTap: ()=>
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => Dialog.fullscreen(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
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
                                          "Location",
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
                                          "Phone",
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
                                      Icon(Icons.calendar_month,
                                          color: Colors.black54),
                                      const SizedBox(width: 10),
                                      InkWell(onTap: (){
                                      },
                                        child: Text(
                                          "Paid Date",
                                          style: GoogleFonts.teko(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(paydate_[index],
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
                                      InkWell(
                                        child: Icon(Icons.copy_all,
                                            color: Colors.black54),
                                        onTap: () async {
                                          await Clipboard.setData(ClipboardData(text:_paymentid[index]));
                                          CoolAlert.show(text: "Copied",
                                              context: context, type: CoolAlertType.success);
                                        },
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        "Payment Id",
                                        style: GoogleFonts.teko(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        _paymentid[index],
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
                                      Icon(Icons.work,
                                          color: Colors.black54),
                                      const SizedBox(width: 10),
                                      Text(
                                        "Worker",
                                        style: GoogleFonts.teko(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        worker[index],
                                        style: GoogleFonts.teko(
                                          fontSize: 18,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Divider(),
                                  Row(
                                    children: [
                                      Icon(Icons.phone,
                                          color: Colors.black54),
                                      const SizedBox(width: 10),
                                      InkWell(onLongPress: () async {
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
                                          "Customer",
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
                      ),
                    ),
                  ),
                ),
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
                          Text(customer[index],style: GoogleFonts.montserrat(),),
                        ],
                      )),
                      Text(_paymentamount[index],style: GoogleFonts.montserrat(fontSize: 20,color: Colors.green,fontWeight: FontWeight.bold),)
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
