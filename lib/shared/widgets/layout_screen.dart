import 'package:flutter/material.dart';

import '../../core.dart';

class LayoutScreen extends StatelessWidget {
  const LayoutScreen({
    Key key,
    this.backgroundColor,
    this.heightHeader = 70,
    this.appBar,
    this.body,
    this.footer,
  }) : super(key: key);

  final Color backgroundColor;
  final double heightHeader;
  final AppBarWidget appBar;
  final Widget body;
  final Widget footer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Get.isDarkMode ? null : context.theme.cardColor,
      backgroundColor: backgroundColor ?? Colors.grey[200],
      body: Stack(
        children: [
          Container(
            color: Colors.white,
            height: heightHeader,
          ),
          SafeArea(
            child: Column(
              children: [
                appBar ?? Container(),
                body ?? Container(),
                footer ?? Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
