import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core.dart';

class ProfileController extends GetxController {
 
  static ProfileController to = Get.find();

  final GlobalKey<FormState> keyEditProfileForm = GlobalKey<FormState>();

  var firstnameCtrl = TextEditingController();
  var lastnameCtrl = TextEditingController();

  var emailCtrl = TextEditingController();
  var usernameCtrl = TextEditingController();
  var passCtrl = TextEditingController();
  var passConfirmCtrl = TextEditingController();

  var phoneCtrl = TextEditingController();
  var genderCtrl = TextEditingController();
  var dobCtrl = TextEditingController();

  var streetCtrl = TextEditingController();
  var cityCtrl = TextEditingController();
  var provinceCtrl = TextEditingController();
  var countryCtrl = TextEditingController();
  var postalCodeCtrl = TextEditingController();

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

  updateProfile() async {
    if (keyEditProfileForm.currentState.validate()) {
      keyEditProfileForm.currentState.save();
      isUsernameAvailable = false;
      update();
    }
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
