import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facial_app_firebase/app/modules/authenticator/views/authenticator_view.dart';
import 'package:facial_app_firebase/app/data/sign_up_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
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
  bool isLoading = true;
  signUp(String email, String password, context) async {
    try {
      if (isLoading == true) {
        Column(
          children: [
            Center(child: CircularProgressIndicator()),
          ],
        );
      }

      if (formKey.currentState!.validate()) {
        await auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) => {postDetails()})
            .catchError((e) {
          Get.snackbar('Alert', e.toString(),
              snackPosition: SnackPosition.TOP, backgroundColor: Colors.red);
        });
      }
      isLoading == false;
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
