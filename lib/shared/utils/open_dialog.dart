import 'package:car_rental/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class OpenDialog {
  static const DialogTransitionType animationType = DialogTransitionType.size;

  static Future<void> messageSuccess(String message,
      {String title, Duration duration}) async {
    Get.snackbar(
      title ?? "Success Message",
      message,
      backgroundColor: Colors.green[400],
      snackPosition: SnackPosition.TOP,
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
      borderRadius: 5,
      icon: Icon(FontAwesomeIcons.checkCircle, color: Colors.white),
      colorText: Colors.white,
      animationDuration: Duration(milliseconds: 1200),
      duration: duration,
    );
  }

  static Future<void> messageError(String message, {Duration duration}) async {
    print("[ERROR] : ${message.toString()}");
    Get.snackbar(
      "Error Message",
      message,
      backgroundColor: Colors.red[400],
      snackPosition: SnackPosition.TOP,
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
      borderRadius: 5,
      icon: Icon(FontAwesomeIcons.exclamationCircle, color: Colors.white),
      colorText: Colors.white,
      animationDuration: Duration(milliseconds: 1200),
      duration: duration,
    );
  }

  static Future<T> info<T>({
    String title,
    String content,
    String lottieFilename,
    EdgeInsets lottiePadding,
    String labelButton,
    Function() onClicked,
    Widget customWidget,
    bool isBackAfterYes = true,
  }) async {
    return await showAnimatedDialog(
      context: Get.context,
      barrierDismissible: true,
      animationType: animationType,
      curve: Curves.fastOutSlowIn,
      duration: Duration(milliseconds: 500),
      builder: (_) => InfoDialog(
        title: title,
        content: content,
        lottieFilename: lottieFilename,
        lottiePadding: lottiePadding,
        labelButton: labelButton,
        customWidget: customWidget,
        onPressed: () {
          if (isBackAfterYes) Get.back();
          if (onClicked != null) onClicked();
        },
      ),
    );
  }

  static Future<T> confirm<T>({
    String title,
    String content,
    String lottieFilename,
    String labelNoButton,
    Function() onNoClicked,
    String labelYesButton,
    @required Function() onYesClicked,
    Widget customWidget,
    bool isBackAfterYes = true,
  }) async {
    return await showAnimatedDialog(
      context: Get.context,
      barrierDismissible: true,
      animationType: animationType,
      curve: Curves.fastOutSlowIn,
      duration: Duration(milliseconds: 500),
      builder: (_) => ConfirmDialog(
        title: title,
        content: content,
        lottieFilename: lottieFilename,
        labelLeftButton: labelNoButton,
        customWidget: customWidget,
        onLeftPressed: () {
          Get.back();
          if (onNoClicked != null) onNoClicked();
        },
        labelRightButton: labelYesButton,
        onRightPressed: () {
          if (isBackAfterYes) Get.back();
          if (onYesClicked != null) onYesClicked();
        },
      ),
    );
  }
}
