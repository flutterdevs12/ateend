import 'dart:developer';

import 'package:facial_app_firebase/app/modules/attendance/views/attendance_view.dart';
import 'package:facial_app_firebase/app/modules/home/views/home_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../attendance/controllers/attendance_controller.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController
  final _attcont = Get.put(AttendanceController());
  final count = 0.obs;

  @override
  void onClose() {}
  void increment() => count.value++;
  var isLoading = false.obs;
  uploadFile() async {
    isLoading.value = true;
    await Future.delayed(Duration(seconds: 1));
    isLoading.value = false;
  }

  nextPage(data, image) async {
    try {
      isLoading.value = true;
      var s = await _attcont.getLocation();
      await Get.to(AttendanceView(address: s, allData: data, image: image));
      isLoading.value = false;
    } catch (e) {
      log(e.toString());
    }
  }

  logout() async {
    Get.defaultDialog(
        title: 'Alert',
        middleText: 'Do You Want SignOut',
        middleTextStyle: GoogleFonts.ubuntu(
          fontSize: 20,
        ),
        titleStyle:
            GoogleFonts.ubuntu(fontSize: 20, fontWeight: FontWeight.bold),
        textConfirm: 'Yes',
        textCancel: 'No',
        cancelTextColor: Color.fromARGB(255, 67, 70, 71),
        onConfirm: () async {
          FirebaseAuth auth = FirebaseAuth.instance;
          await auth.signOut();
          Get.back();
          // await Get.offAll(HomeView());
        },
        onCancel: () {
          Get.off(HomeView());
        },
        buttonColor: Color.fromARGB(255, 67, 70, 71),
        confirmTextColor: Colors.white);
  }
}
