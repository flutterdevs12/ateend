import 'package:facial_app_firebase/app/modules/home/views/home_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController

  final count = 0.obs;

  @override
  void onClose() {}
  void increment() => count.value++;

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
        cancelTextColor: Colors.black,
        onConfirm: () async {
          FirebaseAuth auth = FirebaseAuth.instance;
          await auth.signOut();
          Get.back();
          // await Get.offAll(HomeView());
        },
        onCancel: () {
          Get.off(HomeView());
        },
        buttonColor: Color.fromARGB(255, 0, 0, 0),
        confirmTextColor: Colors.white);
  }
}
