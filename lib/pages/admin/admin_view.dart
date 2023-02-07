import 'package:flutter/material.dart';

class AdminView extends StatefulWidget {
  const AdminView({Key key}) : super(key: key);

  @override
  State<AdminView> createState() => _AdminViewState();
}

class _AdminViewState extends State<AdminView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Hello "),
      ),
    );
  }
}
