import 'package:advertisement/payment_admin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

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
      home: AdminViewCompleted(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AdminViewCompleted extends StatefulWidget {
  const AdminViewCompleted({super.key});

  @override
  State<AdminViewCompleted> createState() => _AdminViewCompletedState();
}

class _AdminViewCompletedState extends State<AdminViewCompleted> {
  _AdminViewCompletedState() {
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
  List<String> worker = [];
  List<String> payment_ = [];
  List<String> customer = [];
  List<String> Dateii = [];
  List<String> workerpay = [];
  List<String> completedid = [];

  // Search variables
  bool isSearching = false;
  String searchQuery = "";
  TextEditingController searchController = TextEditingController();

  Future<void> fetchAdsData() async {
    CollectionReference adsRef = FirebaseFirestore.instance.collection("completed");
    QuerySnapshot querySnapshot = await adsRef.get();
    final adsData = querySnapshot.docs;


    List<String> ids = [];
    List<String> idk = [];
    List<String> names = [];
    List<String> places = [];
    List<String> phones = [];
    List<String> prices = [];
    List<String> categories = [];
    List<String> photos = [];
    List<String> Locations = [];
    List<String> Worker = [];
    List<String> Customer = [];
    List<String> Datess = [];
    List<String> Payments = [];
    List<String> PaymentsS = [];

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
      String Datessi=snap['Date'].toString();
      String Paymentsi=snap['payment'].toString();
      String Customeri=snap['customerph'].toString();
      names.add(namei);
      places.add(placei);
      Datess.add(Datessi);
      Payments.add(Paymentsi);
      prices.add(pricei);
      phones.add(phonei);
      categories.add(categoriesi);
      photos.add(photoi);
      Locations.add(Locationi);
      Worker.add(Workeri);
      Customer.add(Customeri);
      ids.add(d.id);
      idk.add(doc.id);
      print(idk);
    }
    for(var d in adsData){
      PaymentsS.add(d["payment"]);

    }

    setState(() {
      completedid=ids;
      id_ = idk;
      namel_ = names;
      place_ = places;
      phone_ = phones;
      price_ = prices;
      category_ = categories;
      photo_ = photos;
      location_=Locations;
      customer=Customer;
      worker=Worker;
      Dateii=Datess;
      payment_=Payments;
      workerpay=PaymentsS;
      isLoading=false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(flexibleSpace: Container(decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.lightBlueAccent,Colors.teal])),),
        automaticallyImplyLeading: false,
        title: isSearching
            ? TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Search completed works...',
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
          "Completed Works",
          style: GoogleFonts.montserrat(fontSize: 17, color: Colors.black87,fontWeight: FontWeight.bold),
        ),
        elevation:0,
        actions: [
          IconButton(
            icon: Icon(isSearching ? Icons.close : Icons.search, color: Colors.black),
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
                searchController.clear();
                searchQuery = ""; // Clear search when exiting search mode
              });
            },
          ),
        ],
      ),
      body: isLoading
        ? Center(
        child: CircularProgressIndicator(), // Show loading indicator while data is loading
    )
        : namel_.isEmpty
    ? Center(
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    Image.asset("assets/nothing.png", height: 100),
    Text("No Data", style: GoogleFonts.montserrat(fontSize: 20)),
    ],
    ),
    ):
      Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
        ),
        child: ListView.builder(
          itemCount: id_.length,
          itemBuilder: (context, index) {
            // Filter the list based on the search query
            if (searchQuery.isNotEmpty && !namel_[index].toLowerCase().contains(searchQuery)) {
              return SizedBox.shrink(); // Skip this item if it doesn't match the search query
            }
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
                          Text(payment_[index],style: GoogleFonts.montserrat(fontSize: 25,fontWeight: FontWeight.bold),),
                          workerpay[index]=="Not Paid"
                              ?    Text(workerpay[index],style: GoogleFonts.montserrat(fontSize: 15,color: Colors.red,fontWeight: FontWeight.bold),)
                              :    Text(workerpay[index],style: GoogleFonts.montserrat(fontSize: 15,color: Colors.green,fontWeight: FontWeight.bold),),
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
                                    Text("Customer phone :",style: GoogleFonts.teko(fontSize: 17),),
                                    Spacer(),
                                    Text(customer[index],style: GoogleFonts.teko(fontSize: 17),)
                                  ],),
                                  SizedBox(height: 10,),
                                  Row(children: [
                                    Icon(Icons.phone_android),
                                    SizedBox(width: 10,),
                                    Text("Worker Phone :",style: GoogleFonts.teko(fontSize: 17),),
                                    Spacer(),
                                    Text(worker[index],style: GoogleFonts.teko(fontSize: 17),)
                                  ],),
                                  SizedBox(height: 10,),
                                  Row(children: [
                                    Icon(Icons.currency_rupee_outlined),
                                    SizedBox(width: 10,),
                                    Text("Payment :",style: GoogleFonts.teko(fontSize: 17),),
                                    Spacer(),
                                    Text(payment_[index],style: GoogleFonts.teko(fontSize: 17),)
                                  ],),
                                  SizedBox(height: 10,),
                                  Row(children: [
                                    Icon(Icons.sell_outlined),
                                    SizedBox(width: 10,),
                                    Text("Price :",style: GoogleFonts.teko(fontSize: 17),),
                                    Spacer(),
                                    Text(price_[index],style: GoogleFonts.teko(fontSize: 17),)
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
                          Text(place_[index]+" | "+category_[index],style: GoogleFonts.montserrat(),),
                        ],
                      )),
                      workerpay[index]=="Not Paid"
                          ?    TextButton(onPressed: (){
                        SharedPreferences.getInstance().then((prefs) {
                          prefs.setString("selectedAdId1", id_[index]);
                          prefs.setString("phone1", phone_[index]);
                          prefs.setString("price1", payment_[index]);
                          prefs.setString("photo1", photo_[index]);
                          prefs.setString("name1", namel_[index]);
                          prefs.setString("place1", place_[index]);
                          prefs.setString("category1", category_[index]);
                          prefs.setString("location1", location_[index]);
                          prefs.setString("phoneii1", phone_[index]);
                          prefs.setString("worker", worker[index]);
                          prefs.setString("completed", completedid[index]);

                          Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentPage1()));
                        });





                      }, child: Text("PAY",style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 15),))
                          :    Text(workerpay[index].toUpperCase(),style: GoogleFonts.montserrat(fontSize: 15,color: Colors.green,fontWeight: FontWeight.bold),),

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
