import 'package:flutter/material.dart';

class TitleWidget extends StatelessWidget {
  const TitleWidget({
    Key key,
    @required this.title,
    @required this.subtitle,
    this.spacer = 2,
    this.fontSizeTitle = 27,
    this.fontSizeSubtitle = 18,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final double spacer;
  final double fontSizeTitle, fontSizeSubtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            title,
            style: TextStyle(
              color: Colors.black,
              fontSize: fontSizeTitle,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: spacer),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            subtitle,
            style: TextStyle(
              color: Colors.grey,
              fontSize: fontSizeSubtitle,
            ),
          ),
        ),
      ],
    );
  }
}
