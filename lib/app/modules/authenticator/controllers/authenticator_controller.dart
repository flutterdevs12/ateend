import 'dart:io';

import 'package:get/get.dart';

class AuthenticatorController extends GetxController {
  //TODO: Implement AuthenticatorController

  final count = 0.obs;

  Future<void> coneect() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
      }
    } on SocketException catch (_) {
      print('not connected');
    }
    return;
  }

  @override
  void onClose() {}
  void increment() => count.value++;
}
