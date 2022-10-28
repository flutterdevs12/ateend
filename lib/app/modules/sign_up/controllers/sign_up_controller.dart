import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facial_app_firebase/app/data/sign_up_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../authenticator/views/authenticator_view.dart';

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

  var isLoading = false.obs;

  uploadFile() async {
    isLoading.value = true;
    await Future.delayed(Duration(seconds: 3));
    isLoading.value = false;
  }

  signUp(String email, String password, context) async {
    isLoading.value = true;
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
    isLoading.value = false;
  }

  postDetails() async {
    // await uploadFile();
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
    firstNameEditingController.clear();
    img = '';
    passwordController.clear();
    numberController.clear();
    emailEditingController.clear();
    // image = null;
    // emailEditingController.clear();
    Get.off(AuthenticatorView());
    update();
    // Get.off(SignInView());
  }

  File? image;
  String img = '';
  pickimage() async {
    final XFile? pimage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pimage == null) {
      return;
    } else {
      image = File(pimage.path);
      final bytes = File(pimage.path).readAsBytesSync();
      var result = await FlutterImageCompress.compressAndGetFile(
          image!.absolute.path, "${image!.path}compresed.jpg",
          quality: 30);
      final bit = File(result!.path).readAsBytesSync();
      img = base64Encode(bit);
    }
    update();
  }
}
