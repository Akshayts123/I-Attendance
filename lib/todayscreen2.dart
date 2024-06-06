import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iattendence/location_service.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:geocoding/geocoding.dart';
import 'Widget/bezierContainer.dart';
import 'model/user.dart';

class TodayScreen2 extends StatefulWidget {
  const TodayScreen2({super.key});

  @override
  State<TodayScreen2> createState() => _TodayScreen2();
}

class _TodayScreen2 extends State<TodayScreen2> {
  List<String> list = <String>[
    'Android',
    'Life Skill',
    'Networking',
    'Operating System'
  ];
  String dropdownValue = 'Android';

  TextEditingController nameController = TextEditingController();
  TextEditingController rollnoController = TextEditingController();
  TextEditingController subjectController = TextEditingController();
  TextEditingController phonenoController = TextEditingController();

  double screenHeight = 0;
  double screenWidth = 0;

  // Color primary = Color(0xFCEF444C);
  Color primary = Colors.blue;

  late SharedPreferences sharedPreferences;

  String location = " ";
  String checkIn = "--/--";
  String checkOut = "--/--";

  @override
  void initState() {
    _getRecord();

      username();


    super.initState();
  }

  void _getLocation() async {
    List<Placemark> placemark = await placemarkFromCoordinates(User.lat, User.long) ;
    setState(() {
      location =  "${placemark[0].street} , ${placemark[0].locality} , ${placemark[0].administrativeArea} , ${placemark[0].postalCode} , ${placemark[0].country} ";
    });
  }

  username() {

    return  User.username;

  }

  void _getRecord() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection("Employee")
          .where('id', isEqualTo: User.username)
          .get();

      DocumentSnapshot snap2 = await FirebaseFirestore.instance
          .collection("Employee")
          .doc(snap.docs[0].id)
          .collection("record")
          .doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
          // .update({"check in " : DateFormat("hh : mm").format((DateTime.now()))})
          .get();

      setState(() {
        checkIn = snap2["checkIn"];
        checkOut = snap2["checkOut"];
      });
    } catch (e) {
      setState(() {
        checkIn = "--/--";
        checkOut = "--/--";
      });
    }
  }


  // Color(0xFFd93030) red
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        // reverse: true,
        padding: EdgeInsets.all(0),
        child: Stack(
          children: [
            Positioned(
                child: BezierContainer()),
            Column(
              children: [
                // BezierContainer(),
                Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.only(top: 20),
                                child: Text(
                                  "Welcome",
                                  style:  GoogleFonts.poppins(
                                    color: Colors.white,

                                    fontSize: screenWidth / 22,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                margin: const EdgeInsets.only(bottom: 15),
                                child: Text(
                                  "STUDENT" + " : " + username().toString() ,
                                  style:  GoogleFonts.poppins(
                                    color: Color(0xFFf1d71c),

                                    fontSize: screenWidth / 18,
                                    fontWeight: FontWeight.w500
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Image.asset(
                            "assets/logo.png",
                            height: 35,
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 35, bottom: 26),
                        height: 120,
                        decoration: const BoxDecoration(
                          color: Color(0xFFd93030),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10,
                              offset: Offset(2, 2),
                            )
                          ],
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Check In",
                                      style:  GoogleFonts.poppins(
                                        fontSize: screenWidth / 24,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      checkIn,
                                      style:  GoogleFonts.poppins(
                                          fontSize: screenWidth / 18,
                                          color: Colors.white,
                                        fontWeight: FontWeight.bold
                                          ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Check Out",
                                      style:  GoogleFonts.poppins(
                                        fontSize: screenWidth / 26,
                                        color: Colors.white,

                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      checkOut,
                                      style:  GoogleFonts.poppins(
                                          fontSize: screenWidth / 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  child: Column(

                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 40),
                        alignment: Alignment.center,
                        child: RichText(
                          text: TextSpan(
                            text: DateFormat('dd MMMM yyyy').format(DateTime.now()),
                            style: GoogleFonts.poppins(
                              fontSize: screenWidth / 19,
                              color: Colors.red,

                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      StreamBuilder(
                          stream: Stream.periodic(const Duration(seconds: 1)),
                          builder: (context, snapshot) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 26),
                              alignment: Alignment.center,
                              child: Text(
                                DateFormat('hh:mm:ss a').format(DateTime.now()),
                                style:  GoogleFonts.poppins(
                                  fontSize: screenWidth / 20,
                                  color: Color(0xFF314f8c),

                                ),
                              ),
                            );
                          }),
                      checkOut == "--/--"
                          ? Container(
                        margin: const EdgeInsets.only(top: 44, bottom: 30),
                        child: Builder(
                          builder: (context) {
                            final GlobalKey<SlideActionState> key = GlobalKey();

                            return SlideAction(
                              text: checkIn == "--/--"
                                  ? "Slide to Check In "
                                  : "Slide to Check Out ",
                              textStyle: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: screenWidth / 20,

                              ),
                              outerColor: Color(0xFFd93030),
                              innerColor: Color(0xFF314f8c),
                              sliderButtonIcon: Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                              ),
                              key: key,
                              onSubmit: () async {

                                if(User.lat != 0){
                                  _getLocation();
                                  QuerySnapshot snap = await FirebaseFirestore
                                      .instance
                                      .collection("Employee")
                                      .where('id', isEqualTo: User.username)
                                      .get();

                                  DocumentSnapshot snap2 = await FirebaseFirestore
                                      .instance
                                      .collection("Employee")
                                      .doc(snap.docs[0].id)
                                      .collection("record")
                                      .doc(DateFormat('dd MMMM yyyy')
                                      .format(DateTime.now()))
                                  // .update({"check in " : DateFormat("hh : mm").format((DateTime.now()))})
                                      .get();

                                  try {
                                    String checkIn = snap2["checkIn"];

                                    setState(() {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar( SnackBar(
                                        backgroundColor: Color(0xFF314f8c),
                                        content: Text(
                                          "You have Check Out",
                                          style: GoogleFonts.poppins(color: Colors.white),
                                        ),
                                      ));
                                      checkOut = DateFormat("hh:mm a")
                                          .format((DateTime.now()));
                                    });
                                    await FirebaseFirestore.instance
                                        .collection("Employee")
                                        .doc(snap.docs[0].id)
                                        .collection("record")
                                        .doc(DateFormat('dd MMMM yyyy')
                                        .format(DateTime.now()))
                                        .update({
                                      'date':Timestamp.now(),
                                      "checkIn": checkIn,
                                      "checkOut": DateFormat("hh:mm a")
                                          .format((DateTime.now())),
                                      "checkInlocation" :location,

                                    });
                                  } catch (e) {
                                    setState(() {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar( SnackBar(
                                        backgroundColor: Color(0xFF314f8c),
                                        content: Text(
                                          "You have Check In",
                                          style: GoogleFonts.poppins(color: Colors.white),
                                        ),
                                      ));
                                      checkIn = DateFormat("hh:mm a")
                                          .format((DateTime.now()));
                                    });
                                    await FirebaseFirestore.instance
                                        .collection("Employee")
                                        .doc(snap.docs[0].id)
                                        .collection("record")
                                        .doc(DateFormat('dd MMMM yyyy')
                                        .format(DateTime.now()))
                                        .set({
                                      'date':Timestamp.now(),
                                      "checkIn": DateFormat("hh:mm a")
                                          .format((DateTime.now())),
                                      "checkOut" : "--/--",
                                      "checkOutlocation" :location,
                                    });
                                  }
                                  Timer(Duration(seconds: 3), () {
                                    key.currentState?.reset();
                                  });
                                }else{
                                  Timer(Duration(seconds: 3), () async {
                                    _getLocation();
                                    QuerySnapshot snap = await FirebaseFirestore
                                        .instance
                                        .collection("Employee")
                                        .where('id', isEqualTo: User.username)
                                        .get();

                                    DocumentSnapshot snap2 = await FirebaseFirestore
                                        .instance
                                        .collection("Employee")
                                        .doc(snap.docs[0].id)
                                        .collection("record")
                                        .doc(DateFormat('dd MMMM yyyy')
                                        .format(DateTime.now()))
                                    // .update({"check in " : DateFormat("hh : mm").format((DateTime.now()))})
                                        .get();

                                    try {
                                      String checkIn = snap2["checkIn"];

                                      setState(() {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar( SnackBar(
                                          backgroundColor: Color(0xFF314f8c),
                                          content: Text(
                                            "You have Check Out",
                                            style: GoogleFonts.poppins(color: Colors.white),
                                          ),
                                        ));
                                        checkOut = DateFormat("hh:mm a")
                                            .format((DateTime.now()));
                                      });
                                      await FirebaseFirestore.instance
                                          .collection("Employee")
                                          .doc(snap.docs[0].id)
                                          .collection("record")
                                          .doc(DateFormat('dd MMMM yyyy')
                                          .format(DateTime.now()))
                                          .update({
                                        'date':Timestamp.now(),
                                        "checkIn": checkIn,
                                        "checkOut": DateFormat("hh:mm a")
                                            .format((DateTime.now())),
                                        "checkInlocation" :location,

                                      });
                                    } catch (e) {
                                      setState(() {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar( SnackBar(
                                          backgroundColor: Color(0xFF314f8c),
                                          content: Text(
                                            "You have Check In",
                                            style: GoogleFonts.poppins(color: Colors.white),
                                          ),
                                        ));
                                        checkIn = DateFormat("hh:mm a")
                                            .format((DateTime.now()));
                                      });
                                      await FirebaseFirestore.instance
                                          .collection("Employee")
                                          .doc(snap.docs[0].id)
                                          .collection("record")
                                          .doc(DateFormat('dd MMMM yyyy')
                                          .format(DateTime.now()))
                                          .set({
                                        'date':Timestamp.now(),
                                        "checkIn": DateFormat("hh:mm a")
                                            .format((DateTime.now())),
                                        "checkOut" : "--/--",
                                        "checkOutlocation" :location,
                                      });
                                    }
                                    Timer(Duration(seconds: 3), () {
                                      key.currentState?.reset();
                                    });
                                  });
                                }
                              },
                            );
                          },
                        ),
                      )
                          : Container(
                        margin: const EdgeInsets.only(top: 44,bottom: 44),
                        child: Text(
                          "You have completed this day !",
                          style:  GoogleFonts.poppins(fontSize: 20, color: Color(0xFFd93030),),
                        ),
                      ),
                      location!= " " ?Text("Location : " + location,style: GoogleFonts.poppins(fontSize: 14, color: Color(0xFF314f8c),),):SizedBox(),
                    ],
                  ),
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget fieldTitle(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5, left: 10),
      child: Text(
        title,
        style: TextStyle(fontSize: screenHeight / 40, fontFamily: "NexaBold"),
      ),
    );
  }

  Widget customField(
      String hint, TextEditingController controller, bool obscure) {
    return Container(
        width: screenWidth,
        margin: EdgeInsets.only(bottom: screenHeight / 45),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(12)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 10,
              offset: Offset(2, 2),
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              width: screenWidth / 7,
              child: Icon(Icons.person, color: primary, size: screenWidth / 12),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: screenWidth / 12),
                child: TextFormField(
                  controller: controller,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: screenHeight / 35,
                    ),
                    border: InputBorder.none,
                    hintText: hint,
                  ),
                  maxLines: 1,
                  obscureText: obscure,
                ),
              ),
            ),
          ],
        ));
  }

  Widget dropField() {
    return Container(
      width: screenWidth,
      alignment: Alignment.center,
      margin: EdgeInsets.only(bottom: screenHeight / 45),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(12)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 10,
            offset: Offset(2, 2),
          )
        ],
      ),
      child: DropdownButton<String>(
        value: dropdownValue,
        icon: Icon(
          Icons.select_all,
          color: primary,
        ),
        alignment: Alignment.center,
        elevation: 16,
        style: TextStyle(
          color: primary,
          fontFamily: "NexaBold",
          fontSize: screenWidth / 16,
        ),
        underline: Container(
          color: primary,
        ),
        onChanged: (String? value) {
          // This is called when the user selects an item.
          setState(() {
            dropdownValue = value!;
          });
        },
        items: list.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}

//slideactionbutton
//  Container(
//                     margin: const EdgeInsets.only(top: 24),
//                     child: Builder(
//                       builder: (context) {
//                         final GlobalKey<SlideActionState> key = GlobalKey();
//
//                         return SlideAction(
//                           text: "Slide to Submit",
//                           textStyle: TextStyle(
//                             color: Colors.black54,
//                             fontSize: screenWidth / 20,
//                             fontFamily: "NexaRegular",
//                           ),
//                           outerColor: Colors.white,
//                           innerColor: primary,
//                           key: key,
//                           onSubmit: ()
//                              async {
//                         FocusScope.of(context).unfocus();
//
//                         String name = nameController.text.trim();
//                         String rollno = rollnoController.text.trim();
//                         // String subject = subjectController.text.trim();
//                         String phoneno = phonenoController.text.trim();
//
//                         if (name.isEmpty) {
//                           ScaffoldMessenger.of(context)
//                               .showSnackBar(const SnackBar(
//                             content: Text("Student name is still empty"),
//                           ));
//                         } else if (rollno.isEmpty) {
//                           ScaffoldMessenger.of(context)
//                               .showSnackBar(const SnackBar(
//                             content: Text("roll no is still empty"),
//                           ));
//                           // } else if (subject.isEmpty) {
//                           //   ScaffoldMessenger.of(context)
//                           //       .showSnackBar(const SnackBar(
//                           //     content: Text("subject is still empty"),
//                           //   ));
//                         } else if (phoneno.isEmpty) {
//                           ScaffoldMessenger.of(context)
//                               .showSnackBar(const SnackBar(
//                             content: Text("phoneno is still empty"),
//                           ));
//                         } else {
//                           QuerySnapshot snap = await FirebaseFirestore.instance
//                               .collection("submit")
//                               .where('name', isEqualTo: name)
//                               .get();
//                           try {
//                             if (rollno == snap.docs[0]['rollno'] &&
//                                 phoneno == snap.docs[0]['phoneno']) {
//                               sharedPreferences =
//                                   await SharedPreferences.getInstance();
//
//                               // sharedPreferences.setString('studentName', name).then((_){
//                               //    Navigator.pushReplacement(context,
//                               //    MaterialPageRoute(builder: (context)=> AttendanceScreen()));
//
//                               // });
//                               ScaffoldMessenger.of(context)
//                                   .showSnackBar(const SnackBar(
//                                 content: Text("Attendace successful"),
//                               ));
//                             } else {
//                               ScaffoldMessenger.of(context)
//                                   .showSnackBar(const SnackBar(
//                                 content: Text("Deatails no matching"),
//                               ));
//                             }
//                           } catch (e) {
//                             String error = " ";
//                             print(e.toString());
//                             if (e.toString() ==
//                                 "RangeError (Index): Invalid value: valid value range is empty: 0") {
//                               setState(() {
//                                 error = "Student Name does not exist";
//                               });
//                             } else {
//                               setState(() {
//                                 error = "Check name & roll no";
//                               });
//                             }
//
//                             ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                               content: Text(error),
//                             ));
//                           }
//                         }
//                       },
//
//                         );
//                       },
//                     ),
//                   ),

// ontap function here
//
// onTap: () async {
//                       FocusScope.of(context).unfocus();
//
//                       String name = nameController.text.trim();
//                       String rollno = rollnoController.text.trim();
//                       // String subject = subjectController.text.trim();
//                       String phoneno = phonenoController.text.trim();
//
//                       if (name.isEmpty) {
//                         ScaffoldMessenger.of(context)
//                             .showSnackBar(const SnackBar(
//                           content: Text("Student name is still empty"),
//                         ));
//                       } else if (rollno.isEmpty) {
//                         ScaffoldMessenger.of(context)
//                             .showSnackBar(const SnackBar(
//                           content: Text("roll no is still empty"),
//                         ));
//                         // } else if (subject.isEmpty) {
//                         //   ScaffoldMessenger.of(context)
//                         //       .showSnackBar(const SnackBar(
//                         //     content: Text("subject is still empty"),
//                         //   ));
//                       } else if (phoneno.isEmpty) {
//                         ScaffoldMessenger.of(context)
//                             .showSnackBar(const SnackBar(
//                           content: Text("phoneno is still empty"),
//                         ));
//                       } else {
//                         QuerySnapshot snap = await FirebaseFirestore.instance
//                             .collection("submit")
//                             .where('name', isEqualTo: name)
//                             .get();
//                         try {
//                           if (rollno == snap.docs[0]['rollno'] &&
//                               phoneno == snap.docs[0]['phoneno']) {
//                             sharedPreferences =
//                                 await SharedPreferences.getInstance();
//
//                             // sharedPreferences.setString('studentName', name).then((_){
//                             //    Navigator.pushReplacement(context,
//                             //    MaterialPageRoute(builder: (context)=> AttendanceScreen()));
//
//                             // });
//                             ScaffoldMessenger.of(context)
//                                 .showSnackBar(const SnackBar(
//                               content: Text("Attendace successful"),
//                             ));
//                           } else {
//                             ScaffoldMessenger.of(context)
//                                 .showSnackBar(const SnackBar(
//                               content: Text("Deatails no matching"),
//                             ));
//                           }
//                         } catch (e) {
//                           String error = " ";
//                           print(e.toString());
//                           if (e.toString() ==
//                               "RangeError (Index): Invalid value: valid value range is empty: 0") {
//                             setState(() {
//                               error = "Student Name does not exist";
//                             });
//                           } else {
//                             setState(() {
//                               error = "Check name & roll no";
//                             });
//                           }
//
//                           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                             content: Text(error),
//                           ));
//                         }
//                       }
//                     },
//                     child: Container(
//                       height: 60,
//                       width: screenWidth,
//                       margin: EdgeInsets.only(top: screenHeight / 30),
//                       decoration: BoxDecoration(
//                         color: primary,
//                         borderRadius:
//                             const BorderRadius.all(Radius.circular(30)),
//                       ),
//                       child: Center(
//                         child: Text(
//                           "SUBMIT",
//                           style: TextStyle(
//                             fontFamily: "NexaBold",
//                             fontSize: screenWidth / 26,
//                             color: Colors.white,
//                             letterSpacing: 2,
//                           ),
//
//                         ),
//
//                       ),
//
//                     ),

//today attendance
// Container(
//   alignment: Alignment.centerLeft,
//   margin: EdgeInsets.only(top: 10, bottom: 15),
//   child: Text(
//     "Today's Attendance",
//     style: TextStyle(
//       color: Colors.grey,
//       fontFamily: "NexaRegular",
//       fontSize: screenWidth / 26,
//     ),
//   ),
// ),
