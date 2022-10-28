import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignInController extends GetxController {
  //TODO: Implement SignInController

  final count = 0.obs;

  @override
  void onClose() {}
  void increment() => count.value++;
  var isLoading = false.obs;

  uploadFile() async {
    isLoading.value = true;
    await Future.delayed(Duration(seconds: 3));
    isLoading.value = false;
  }

  Future loginFunct({required String email, required String password}) async {
    // await uploadFile();

    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    try {
      isLoading.value = true;
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", e.message.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
    }
    isLoading.value = false;
    // if (user != null) {
    //   Get.off(HomeView());
    // }
    // return user;
  }
}
