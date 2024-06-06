import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';

import 'model/user.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  double screenHeight = 0;
  double screenWidth = 0;

  // Color primary = Color(0xFCEF444C);
  Color primary = Color.fromARGB(255, 37, 230, 134);

  String _month = DateFormat('MMMM').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Color(0xFF314f8c),
          title: Text(
            "MY ATTENDANCE",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.only(top: 15),
                    child: Text(
                      _month,
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      final month = await showMonthYearPicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2023),
                        lastDate: DateTime(2099),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(
                                primary: Color(0xFF314f8c),
                                secondary: Color(0xFFd93030),
                                onSecondary: Colors.white,
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (month != null) {
                        setState(() {
                          _month = DateFormat("MMMM").format(month);
                        });
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                      decoration: const BoxDecoration(
                        color: Color(0xFFd93030),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(2, 2),
                          )
                        ],
                        borderRadius: BorderRadius.all(
                            Radius.circular(10)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.calendar_month,color: Colors.white,),
                          SizedBox(width: 10,),
                          Container(
                            child:  Text(
                              "Pick a Month",
                              style: GoogleFonts.poppins(color: Colors.white, fontSize: 15, ),


                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                  height: screenHeight / 1.3,
                  // color: Colors.red,
                  child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("Employee")
                          .doc(User.id)
                          .collection("record")
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasData) {
                          final snap = snapshot.data!.docs;
                          return ListView.builder(
                            itemCount: snap.length,
                            // physics: BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return DateFormat('MMMM').format(
                                          snap[index]['date'].toDate()) ==
                                      _month
                                  ? Container(
                                      margin:
                                          EdgeInsets.only(top: 20, bottom: 12),
                                      height: 120,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 10,
                                            offset: Offset(2, 2),
                                          )
                                        ],
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 90,
                                            decoration: BoxDecoration(
                                            color: Color(0xFFd93030),
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                            child: Center(
                                          child: Text(
                                            DateFormat('EE \ndd').format(
                                                snap[index]['date']
                                                    .toDate()),
                                            style:GoogleFonts.poppins(color: Colors.white, fontSize: screenWidth / 18,
                                                fontWeight:
                                                FontWeight.bold ),
                                            textAlign: TextAlign.center,
                                          ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "Check In",
                                                    style:GoogleFonts.poppins(fontSize:
                              screenWidth / 24,
                              color: Colors.black,)
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    snap[index]['checkIn'],
                                                    style:GoogleFonts.poppins(

                                                        fontSize:
                                                            screenWidth / 22,
                                                        color: Color(0xFF314f8c),
                                                       ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "Check Out",
                                                    style: GoogleFonts.poppins(

                                                      fontSize:
                                                          screenWidth / 26,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    snap[index]['checkOut'],
                                                    style:GoogleFonts.poppins(
                                                        fontSize:
                                                            screenWidth / 22,
                                                        color: Color(0xFF314f8c),
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : SizedBox();
                            },
                          );
                        } else {
                          return const SizedBox();
                        }
                      }))
            ],
          ),
        ));
  }
}
