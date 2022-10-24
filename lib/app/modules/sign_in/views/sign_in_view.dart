import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../../sign_up/views/sign_up_view.dart';
import '../controllers/sign_in_controller.dart';

class SignInView extends GetView<SignInController> {
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final _signInController = Get.put(SignInController());
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  'Login',
                  style: GoogleFonts.ubuntu(
                      color: Colors.white,
                      fontSize: 35,
                      fontWeight: FontWeight.bold),
                ),
                Container(
                  child: Lottie.network(
                      'https://assets2.lottiefiles.com/packages/lf20_pwwZiL9I3Y.json'),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 15, bottom: 25),
                        child: Container(
                          child: (TextFormField(
                            style: GoogleFonts.ubuntu(color: Colors.white),
                            controller: _emailcontroller,
                            decoration: InputDecoration(
                                hintStyle: GoogleFonts.ubuntu(
                                    color: Color.fromARGB(255, 255, 255, 255)),
                                filled: true,
                                prefixIcon: const Icon(
                                  Icons.email_outlined,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                                hintText: 'Enter your  e-mail',
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2,
                                        color:
                                            Color.fromARGB(255, 127, 127, 129)),
                                    borderRadius: BorderRadius.circular(20)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                fillColor: Color.fromARGB(255, 67, 70, 71),
                                focusColor: Color.fromARGB(255, 255, 255, 255)),
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
                        padding: const EdgeInsets.only(left: 15.0, right: 15),
                        child: Container(
                          child: (TextFormField(
                            style: GoogleFonts.ubuntu(color: Colors.white),
                            controller: _passwordcontroller,
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            decoration: InputDecoration(
                                filled: true,
                                prefixIcon: const Icon(
                                  Icons.password,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                                hintText: 'Password',
                                hintStyle: GoogleFonts.ubuntu(
                                    color: Color.fromARGB(255, 255, 255, 255)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2,
                                        color:
                                            Color.fromARGB(255, 127, 127, 129)),
                                    borderRadius: BorderRadius.circular(20)),
                                fillColor: Color.fromARGB(255, 67, 70, 71),
                                focusColor: Color.fromARGB(255, 255, 255, 255)),
                          )),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                              onPressed: () {
                                Get.to(SignUpView());
                              },
                              child: const Text('Dont have an account?'))
                        ],
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          )),
                          backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromARGB(255, 50, 67, 73),
                          ),
                        ),
                        onPressed: () async {
                          await _signInController.loginFunct(
                            email: _emailcontroller.text,
                            password: _passwordcontroller.text,
                          );
                          // if (user != null) {
                          //   Get.off(DataViewView());
                          // }
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          child: Text(
                            'Login',
                            style: GoogleFonts.ubuntu(
                                color: Color.fromARGB(255, 255, 255, 255)),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
