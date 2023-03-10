import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../sign_in/views/sign_in_view.dart';
import '../controllers/sign_up_controller.dart';

class SignUpView extends GetView<SignUpController> {
  final _signUpController = Get.put(SignUpController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
              onPressed: () {
                Get.off(SignInView());
              },
              icon: (Icon(Icons.arrow_back))),
          backgroundColor: Color.fromARGB(255, 67, 70, 71),
        ),
        backgroundColor: Color.fromARGB(255, 67, 70, 71),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Row(
                  children: [
                    Text(
                      'Create Account',
                      style: GoogleFonts.ubuntu(
                          color: Colors.white,
                          fontSize: 35,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Form(
                key: _signUpController.formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 28.0),
                      child: Column(
                        children: [
                          GetBuilder<SignUpController>(builder: (context) {
                            return Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(60),
                                image: const DecorationImage(
                                  image: AssetImage('assets/images/avatar.png'),
                                ),
                              ),
                              child: _signUpController.img.trim().isNotEmpty
                                  ? CircleAvatar(
                                      backgroundImage: MemoryImage(
                                        const Base64Decoder()
                                            .convert(_signUpController.img),
                                      ),
                                    )
                                  : Container(),
                            );
                          }),
                        ],
                      ),
                    ),
                    IconButton(
                        onPressed: () async {
                          _signUpController.pickimage();
                        },
                        icon: const Icon(
                          Icons.add_a_photo,
                          color: Color.fromARGB(255, 204, 208, 210),
                        )),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15, bottom: 20),
                      child: (TextFormField(
                        style: GoogleFonts.ubuntu(color: Colors.white),
                        controller:
                            _signUpController.firstNameEditingController,
                        decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.abc,
                              color: Color.fromARGB(255, 165, 169, 171),
                            ),
                            hintText: 'Enter Your Name',
                            hintStyle: GoogleFonts.ubuntu(
                                color: Color.fromARGB(255, 255, 255, 255)),
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 2,
                                    color: Color.fromARGB(255, 127, 127, 129)),
                                borderRadius: BorderRadius.circular(10)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            fillColor: Color.fromARGB(255, 45, 47, 51),
                            focusColor: Color.fromARGB(255, 67, 70, 71)),
                        validator: (value) {
                          if (!RegExp(r'^[a-z A-Z]+$').hasMatch(value!) ||
                              value.length < 3) {
                            return 'please enter valid Name';
                          } else {
                            return null;
                          }
                        },
                      )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15, bottom: 15),
                      child: Container(
                        child: (TextFormField(
                          style: GoogleFonts.ubuntu(color: Colors.white),
                          maxLength: 10,
                          controller: _signUpController.numberController,
                          decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.phone,
                                color: Color.fromARGB(255, 165, 169, 171),
                              ),
                              filled: true,
                              hintText: 'Mobile Number',
                              hintStyle: GoogleFonts.ubuntu(
                                  color: Color.fromARGB(255, 255, 255, 255)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 2,
                                      color:
                                          Color.fromARGB(255, 127, 127, 129)),
                                  borderRadius: BorderRadius.circular(10)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              fillColor: Color.fromARGB(255, 45, 47, 51),
                              focusColor: Color.fromARGB(255, 67, 70, 71)),
                          validator: (value) {
                            if (!RegExp(r'^[0-9]{10}$').hasMatch(value!)) {
                              return 'please enter valid number';
                            } else {
                              return null;
                            }
                          },
                        )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15, bottom: 15),
                      child: Container(
                        child: (TextFormField(
                          style: GoogleFonts.ubuntu(color: Colors.white),
                          controller: _signUpController.emailEditingController,
                          decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.email_outlined,
                                color: Color.fromARGB(255, 165, 169, 171),
                              ),
                              filled: true,
                              hintText: 'Enter your  e-mail',
                              hintStyle: GoogleFonts.ubuntu(
                                  color: Color.fromARGB(255, 255, 255, 255)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 2,
                                      color:
                                          Color.fromARGB(255, 127, 127, 129)),
                                  borderRadius: BorderRadius.circular(10)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              fillColor: Color.fromARGB(255, 45, 47, 51),
                              focusColor: Color.fromARGB(255, 67, 70, 71)),
                          validator: (value) {
                            if (!RegExp(r'^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$')
                                    .hasMatch(value!) ||
                                value.length < 3) {
                              return 'please enter valid email';
                            } else {
                              return null;
                            }
                          },
                        )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15, bottom: 25),
                      child: Container(
                        child: (TextFormField(
                          style: GoogleFonts.ubuntu(color: Colors.white),
                          controller: _signUpController.passwordController,
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.password,
                                color: Color.fromARGB(255, 165, 169, 171),
                              ),
                              filled: true,
                              hintText: 'Password',
                              hintStyle: GoogleFonts.ubuntu(
                                  color: Color.fromARGB(255, 255, 255, 255)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 2,
                                      color:
                                          Color.fromARGB(255, 127, 127, 129)),
                                  borderRadius: BorderRadius.circular(10)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              fillColor: Color.fromARGB(255, 45, 47, 51),
                              focusColor: Color.fromARGB(255, 67, 70, 71)),
                        )),
                      ),
                    ),
                    Obx(() {
                      return ElevatedButton.icon(
                        icon: _signUpController.isLoading.value
                            ? CircularProgressIndicator(
                                color: Color.fromARGB(255, 171, 180, 184))
                            : Icon(Icons.upload),
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all(Size(150, 50)),
                          backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromARGB(255, 50, 67, 73),
                          ),
                        ),
                        onPressed: _signUpController.isLoading.value
                            ? null
                            : () async {
                                await _signUpController.signUp(
                                    email: _signUpController
                                        .emailEditingController.text
                                        .toString(),
                                    password: _signUpController
                                        .passwordController.text
                                        .toString(),
                                    mobileNumber: _signUpController
                                        .numberController.text
                                        .toString(),
                                    name: _signUpController
                                        .firstNameEditingController.text
                                        .toString());
                                // await AttendanceController().getUserLocation();
                              },
                        label: Text(
                            _signUpController.isLoading.value
                                ? 'Processing'
                                : 'Sign-up',
                            style: GoogleFonts.ubuntu(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      );
                    })
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
