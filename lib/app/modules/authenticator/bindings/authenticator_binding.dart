import 'package:get/get.dart';

import '../controllers/authenticator_controller.dart';

class AuthenticatorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthenticatorController>(
      () => AuthenticatorController(),
    );
  }
}
