import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core.dart';

class AuthController extends GetxController {
 
  static AuthController to = Get.find();

  final GlobalKey<FormState> keyLoginForm = GlobalKey<FormState>();
  final GlobalKey<FormState> keyRegisterForm = GlobalKey<FormState>();
  final GlobalKey<FormState> keyResetPasswordForm = GlobalKey<FormState>();

  var firstnameCtrl = TextEditingController();
  var lastnameCtrl = TextEditingController();

  var emailCtrl = TextEditingController();
  var usernameCtrl = TextEditingController();
  var passCtrl = TextEditingController();
  var passConfirmCtrl = TextEditingController();

  final int delayedAmount = 100;
  var isPasswordSecure = true;
  var isConfirmPasswordSecure = true;
  bool isUsernameAvailable = true;

  @override
  void onInit() {
    super.onInit();
    loadData();
    fillUserDataForm();
  }

  loadData() async { 
  }

  void fillUserDataForm() async {
    isUsernameAvailable = true;
  
    update();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
