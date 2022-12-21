import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core.dart';
import 'package:line_icons/line_icons.dart';

class UserAgreementView extends GetView {
  const UserAgreementView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutScreen(
      appBar: const AppBarWidget(title: "User Agreement"),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(7)),
        child: Column(
          children: [
            ItemListMenu(
              onPressed: () => Get.toNamed(Routes.PRIVACY_POLICY),
              icon: LineIcons.userShield,
              name: "Privacy Policy",
            ),
            const Divider(),
            ItemListMenu(
              onPressed: () => Get.toNamed(Routes.TERMS_CONDITIONS),
              icon: LineIcons.fileSignature,
              name: "Terms & Conditions",
            ),
          ],
        ),
      ),
    );
  }
}
