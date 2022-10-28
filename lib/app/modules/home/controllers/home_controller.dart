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
  var isLoading = false.obs;
  uploadFile() async {
    isLoading.value = true;
    await Future.delayed(Duration(seconds: 1));
    isLoading.value = false;
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
