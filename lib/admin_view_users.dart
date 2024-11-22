import 'package:advertisement/booked_ads_user_admin_view.dart';
import 'package:advertisement/completed_user_admin_view.dart';
import 'package:advertisement/pay_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
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
      theme: ThemeData.dark(),
      home: ViewUsers(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ViewUsers extends StatefulWidget {
  const ViewUsers({super.key});

  @override
  State<ViewUsers> createState() => _ViewUsersState();
}

class _ViewUsersState extends State<ViewUsers> {
  bool isLoading = true;
  List<String> id_ = [];
  List<String> namel_ = [];
  List<String> place_ = [];
  List<String> phone_ = [];
  List<String> category_ = [];
  List<String> photo_ = [];
  bool isSearching = false; // Toggles between search bar and title
  TextEditingController searchController = TextEditingController();
  String searchQuery = "";

  _ViewUsersState() {
    fetchAdsData();
  }

  Future<void> Delete_() async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    CollectionReference adsREf = FirebaseFirestore.instance.collection("userdetails");
    await adsREf.doc(sh.getString("deleteid").toString()).delete();
    fetchAdsData();
  }

  Future<void> fetchAdsData() async {
    CollectionReference adsRef = FirebaseFirestore.instance.collection("userdetails");
    QuerySnapshot querySnapshot = await adsRef.get();
    final adsData = querySnapshot.docs;
    List<String> ids = [];
    List<String> names = [];
    List<String> places = [];
    List<String> phones = [];
    List<String> categories = [];
    List<String> photos = [];

    for (var ad in adsData) {
      ids.add(ad.id);
      names.add(ad['name']);
      places.add(ad['place']);
      phones.add(ad['phone']);
      categories.add(ad['buisness']);
      photos.add(ad['photo']);
    }

    setState(() {
      id_ = ids;
      namel_ = names;
      place_ = places;
      phone_ = phones;
      category_ = categories;
      photo_ = photos;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(flexibleSpace: Container(decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.teal,Colors.tealAccent])),),
        automaticallyImplyLeading: false,
        title: isSearching
            ? TextFormField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Search users by name...',
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
          "View Users",
            style: GoogleFonts.montserrat(fontSize: 20, color: Colors.white70,fontWeight: FontWeight.bold)
        ),
        actions: [
          IconButton(
            icon: Icon(isSearching ? Icons.close : Icons.search, color: Colors.black,),
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
                searchController.clear();
                searchQuery = ""; // Clear search when exiting search mode
              });
            },
          ),
        ],
        backgroundColor: Colors.tealAccent,
        elevation: 0,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("userdetails").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("Something went wrong");
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            final filteredUsers = snapshot.data!.docs.where((doc) {
              final name = (doc['name'] as String).toLowerCase();
              return name.contains(searchQuery);
            }).toList();

            return ListView.builder(
              itemCount: filteredUsers.length,
              itemBuilder: (context, index) {
                final user = filteredUsers[index];
                return  InkWell(onTap: ()=>{
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => Dialog.fullscreen(
                      child: Center(
                        child: Container(decoration: BoxDecoration(gradient: LinearGradient(
                            colors: [Colors.teal,Colors.grey])),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              children: [
                                Card(elevation: 10,
                                  shape: CircleBorder(side: BorderSide(color: Colors.teal,width: 2)),
                                  child: CircleAvatar(radius: 70,
                                    backgroundImage: NetworkImage(photo_[index]),),
                                ),
                                Card(
                                  color: Colors.transparent,
                                  margin: const EdgeInsets.all(16),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  elevation: 0,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 20),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.person_3_outlined,
                                                color: Colors.black54),
                                            const SizedBox(width: 10),
                                            Text(
                                              "Name ::",
                                              style: GoogleFonts.teko(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black87,
                                              ),),
                                            const Spacer(),
                                            Text(
                                              namel_[index].toUpperCase(),
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
                                            Icon(Icons.location_on_outlined,
                                                color: Colors.black54),
                                            const SizedBox(width: 10),
                                            Text(
                                              "Place::",
                                              style: GoogleFonts.teko(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black87,
                                              ),),
                                            const Spacer(),
                                            Text(
                                              place_[index],
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
                                            Icon(Icons.business_rounded,
                                                color: Colors.black54),
                                            const SizedBox(width: 10),
                                            Text(
                                              "Business::",
                                              style: GoogleFonts.teko(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black87,
                                              ),),
                                            const Spacer(),
                                            Text(
                                              category_[index],
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
                                            Text(
                                              "Booked Ads::",
                                              style: GoogleFonts.teko(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black87,
                                              ),),
                                            const Spacer(),
                                            IconButton(onPressed: () async {
                                              SharedPreferences derick= await SharedPreferences.getInstance();
                                              derick.setString("user11", phone_[index]);

                                              Navigator.push(context, MaterialPageRoute(builder: (context)=>BookedAds1()));
                                            }, icon: Icon(Icons.navigate_next))
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "Completed::",
                                              style: GoogleFonts.teko(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black87,
                                              ),),
                                            const Spacer(),
                                            IconButton(onPressed: () async {
                                              SharedPreferences derick= await SharedPreferences.getInstance();
                                              derick.setString("user11", phone_[index]);

                                              Navigator.push(context, MaterialPageRoute(builder: (context)=>BookedAdsU1()));
                                            }, icon: Icon(Icons.navigate_next))
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "Payment History::",
                                              style: GoogleFonts.teko(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black87,
                                              ),),
                                            const Spacer(),
                                            IconButton(onPressed: () async {
                                              SharedPreferences derick= await SharedPreferences.getInstance();
                                              derick.setString("user11", phone_[index]);

                                              Navigator.push(context, MaterialPageRoute(builder: (context)=>payhisU1()));
                                            }, icon: Icon(Icons.navigate_next))
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
                    ),
                  ),

                },

                  child: Column(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(photo_[index]),
                            radius: 35,),
                          SizedBox(width: 15,),

                          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(namel_[index].toUpperCase(),style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,fontSize: 20),),
                              Row(crossAxisAlignment: CrossAxisAlignment.start,
                                children: [Icon(Icons.location_on_outlined),
                                  Text(place_[index],style: GoogleFonts.montserrat(),),
                                ],
                              ),
                            ],
                          )),
                          IconButton(onPressed: (){
                            _showAdOptionsDialog(index);
                          }, icon: Icon(Icons.more_vert_outlined))
                        ],

                      ),
                    ),
                    Divider()
                  ],),
                );
              },
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text("Options", style: GoogleFonts.montserrat(fontSize: 18)),
          content: Text(
            "Would you like to delete this user?",
            style: GoogleFonts.montserrat(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Cancel",
                style: GoogleFonts.montserrat(fontSize: 16, color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () async {
                SharedPreferences sh = await SharedPreferences.getInstance();
                sh.setString("phonenumber11", phone_[index]).toString();
                sh.setString("deleteid", id_[index]);
                Delete_();
                CollectionReference fire = FirebaseFirestore.instance.collection("logindetailsuser");
                QuerySnapshot qs = await fire.where("phone", isEqualTo: sh.getString('phonenumber11').toString()).get();
                final doc1 = qs.docs.first.id;
                if (doc1.length != 0) {
                  fire.doc(doc1).delete();
                  fetchAdsData();
                  Navigator.pop(context);
                  Alert(
                    context: context,
                    title: "Delete success",style: AlertStyle(isButtonVisible: false,
                      titleStyle: GoogleFonts.dmSans(fontSize: 15)),
                    image: Image.asset("assets/trash.png",height: 50,),
                  ).show();

                } else {
                  Navigator.pop(context);
                }
              },
              child: Text(
                "Ok",
                style: GoogleFonts.montserrat(fontSize: 16, color: Colors.teal),
              ),
            ),
          ],
        );
      },
    );
  }
}
