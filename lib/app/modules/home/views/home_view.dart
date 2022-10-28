import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facial_app_firebase/app/modules/attendance/controllers/attendance_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../attendance/views/attendance_view.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  final _attcont = Get.put(AttendanceController());
  dynamic newVal =
      FirebaseFirestore.instance.collection('newdata').doc().snapshots();
  final _homeController = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 67, 70, 71),
      appBar: AppBar(
        title: Text(
          'Profile-Details',
          style: GoogleFonts.ubuntu(fontSize: 30),
        ),
        backgroundColor: Color.fromARGB(255, 67, 70, 71),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () async {
                await _homeController.logout();
              },
              icon: Icon(Icons.logout_outlined))
        ],
      ),
      body: ListView(
        children: [
          SizedBox(height: 50),
          StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('newdata').snapshots(),
              builder:
                  (BuildContext ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                        color: Color.fromARGB(255, 171, 180, 184)),
                  );
                }
                final List usersData = [];
                snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map a = document.data() as Map<String, dynamic>;
                  usersData.add(a);
                  a["uid"] = document.id;
                }).toList();
                final auths = FirebaseAuth.instance;
                dynamic user = auths.currentUser;
                dynamic data;
                for (int i = 0; i <= usersData.length; i++) {
                  if (usersData[i]['uid'] == user!.uid) {
                    data = usersData[i];
                    break;
                  }
                }
                final dataq = data['image'];
                var images2 = Base64Decoder().convert(dataq);
                return Center(
                  child: Column(
                    children: [
                      // Padding(
                      //   padding: const EdgeInsets.only(
                      //       top: 14.0, bottom: 20, left: 10),
                      //   child: Text(
                      //     'Profile Details',
                      //     style: GoogleFonts.ubuntu(
                      //       color: Color.fromARGB(255, 255, 255, 255),
                      //       fontSize: 40,
                      //     ),
                      //   ),
                      // ),
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 74,
                        child: CircleAvatar(
                          backgroundImage: MemoryImage(images2),
                          radius: 70,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 40,
                          left: 10,
                          right: 10,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Name  ',
                              style: GoogleFonts.ubuntu(
                                  fontSize: 30,
                                  color: Color.fromARGB(255, 164, 160, 160)),
                            ),
                            const SizedBox(
                              width: 30,
                            ),
                            Text(
                              data['Name'],
                              style: GoogleFonts.ubuntu(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w300),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(
                        color: Colors.white,
                        thickness: 1,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Number ',
                              style: GoogleFonts.ubuntu(
                                  fontSize: 30,
                                  color: Color.fromARGB(255, 164, 160, 160)),
                            ),
                            const SizedBox(
                              width: 30,
                            ),
                            Text(data['Number'],
                                style: GoogleFonts.ubuntu(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w300))
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(
                        color: Colors.white,
                        thickness: 1,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 10, bottom: 10, left: 10, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'E-mail ',
                              style: GoogleFonts.ubuntu(
                                  color: Color.fromARGB(255, 164, 160, 160),
                                  fontSize: 30),
                            ),
                            Text(
                              data['email'],
                              style: GoogleFonts.ubuntu(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 30),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(
                        color: Colors.white,
                        thickness: 1,
                      ),
                      Obx(() {
                        return Padding(
                          padding: EdgeInsets.only(top: 30.0),
                          child: ElevatedButton.icon(
                              icon: _homeController.isLoading.value
                                  ? CircularProgressIndicator(
                                      color: Color.fromARGB(255, 171, 180, 184),
                                    )
                                  : Icon(Icons.perm_contact_calendar_rounded),
                              style: ButtonStyle(
                                minimumSize:
                                    MaterialStateProperty.all(Size(250, 50)),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                )),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  Color.fromARGB(255, 65, 86, 94),
                                ),
                              ),
                              onPressed: _homeController.isLoading.value
                                  ? null
                                  : () async {
                                      await _homeController.uploadFile();
                                      var s = await _attcont.getLocation();
                                      Get.to(AttendanceView(
                                        image: dataq,
                                        address: s,
                                        allData: data,
                                      ));
                                      // Get.to(attend(
                                      //   images: images2,
                                      // ));
                                    },
                              label: Text(
                                _homeController.isLoading.value
                                    ? 'Processing'
                                    : 'Take Attendance',
                                style: GoogleFonts.ubuntu(
                                    color: Colors.white, fontSize: 20),
                              )),
                        );
                      })
                    ],
                  ),
                );
              })
        ],
      ),
    );
  }
}
