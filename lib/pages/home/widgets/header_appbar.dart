import 'package:car_rental/core.dart';
import 'package:flutter/material.dart';

class HeaderAppBar extends StatelessWidget {
  const HeaderAppBar({
    Key key,
    @required this.photoURL,
    @required this.membership,
    @required this.balance,
    @required this.progress,
  }) : super(key: key);

  final String photoURL;
  final String membership;
  final String balance;
  final int progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: AvatarWidget(
        photoURL: photoURL,
        membership: membership,
        progress: progress,
      ),
    );
  }
}
