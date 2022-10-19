import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facial_app_firebase/app/modules/authenticator/views/authenticator_view.dart';
import 'package:facial_app_firebase/app/modules/sign_up/views/widget/sign_up_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class SignUpController extends GetxController {
  //TODO: Implement SignUpController

  final count = 0.obs;

  @override
  void onClose() {}
  void increment() => count.value++;
  final firstNameEditingController = TextEditingController();

  var emailEditingController = TextEditingController();
  final passwordController = TextEditingController();
  final numberController = TextEditingController();
  final auth = FirebaseAuth.instance;
  final formKey = GlobalKey<FormState>();

  signUp(String email, String password) async {
    CircularProgressIndicator(
      value: sqrt1_2,
    );
    try {
      if (formKey.currentState!.validate()) {
        await auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) => {postDetails()})
            .catchError((e) {
          Get.snackbar('Alert', e.toString(),
              snackPosition: SnackPosition.TOP, backgroundColor: Colors.red);
        });
      }
    } catch (e) {
      Get.snackbar('Alert', e.toString(),
          snackPosition: SnackPosition.TOP, backgroundColor: Colors.red);
    }
  }

  postDetails() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = auth.currentUser;
    SignUpModelView dataModel = SignUpModelView();
    dataModel.image = img;
    dataModel.uid = user!.uid;
    dataModel.email = user.email;
    dataModel.name = firstNameEditingController.text;

    dataModel.number = numberController.text;
    dataModel.s = Timestamp.now();
    await firebaseFirestore
        .collection("newdata")
        .doc(user.uid)
        .set(dataModel.toMap());
    print('data uploaded');
    Get.snackbar('Alert', 'Account Succesfully created',
        snackPosition: SnackPosition.TOP, backgroundColor: Colors.green);

    image = null;
    emailEditingController.clear();
    update();
    Get.off(AuthenticatorView());
  }

  File? image;
  String img = '';
  pickimage() async {
    final pimage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pimage == null) {
      return;
    } else {
      image = File(pimage.path);

      final bytes = File(pimage.path).readAsBytesSync();
      img = base64Encode(bytes);
    }
    update();
  }
}