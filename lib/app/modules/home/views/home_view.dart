import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facial_app_firebase/app/modules/attendance/controllers/attendance_controller.dart';
import 'package:facial_app_firebase/app/modules/attendance/views/attendance_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  final _attcont = Get.put(AttendanceController());
  dynamic newVal =
      FirebaseFirestore.instance.collection('newdata').doc().snapshots();
  final _homeController = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Welcome'),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () async {
                  await _homeController.logout();
                },
                icon: Icon(Icons.logout_outlined))
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('newdata')
                      .snapshots(),
                  builder: (BuildContext ctx,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
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
                    return Card(
                      color: Color.fromARGB(255, 187, 198, 200).withOpacity(.5),
                      elevation: 70,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 38.0),
                        child: Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 14.0, bottom: 40),
                              child: Text(
                                'Profile Details',
                                style: TextStyle(
                                    color: Color.fromRGBO(0, 0, 0, 100),
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 38.0),
                              child: CircleAvatar(
                                backgroundImage: MemoryImage(images2),
                                radius: 70,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Name : ',
                                    style: TextStyle(fontSize: 30),
                                  ),
                                  const SizedBox(
                                    width: 30,
                                  ),
                                  Text(
                                    data['Name'],
                                    style: const TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w300),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 10, left: 10, right: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Number :',
                                    style: TextStyle(fontSize: 30),
                                  ),
                                  const SizedBox(
                                    width: 30,
                                  ),
                                  Text(data['Number'],
                                      style: const TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.w300))
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 10, bottom: 20, left: 10, right: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'E-mail :',
                                    style: TextStyle(fontSize: 30),
                                  ),
                                  Text(
                                    data['email'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25),
                                  )
                                ],
                              ),
                            ),
                            ElevatedButton(
                                onPressed: () async {
                                  var s = await _attcont.getUserLocation();
                                  Get.to(AttendanceView(
                                    image: images2,
                                    address: s,
                                  ));
                                  // Get.to(attend(
                                  //   images: images2,
                                  // ));
                                },
                                child: Text('Attendance'))
                          ],
                        ),
                      ),
                    );
                  })
            ],
          ),
        ));
  }
}
