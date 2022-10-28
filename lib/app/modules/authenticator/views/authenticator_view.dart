import 'package:facial_app_firebase/app/modules/home/views/home_view.dart';
import 'package:facial_app_firebase/app/modules/sign_in/views/sign_in_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/authenticator_controller.dart';

class AuthenticatorView extends GetView<AuthenticatorController> {
  final AuthenticatorController _authenticatorController =
      Get.put(AuthenticatorController());
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _authenticatorController.coneect(),
        builder: (condtext, snapshot) {
          return StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Container();
                } else if (snapshot.hasData) {
                  return HomeView();
                } else {
                  return SignInView();
                }
              });
        });
  }
}
