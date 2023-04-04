import 'package:flutter/material.dart';

void showSnackBar(context, IconData icon, String message, Color color){
  final snackbar = SnackBar(
      behavior: SnackBarBehavior.fixed,
      backgroundColor: color,
      content: Container(
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: [
              Icon(
                icon,
                color: Colors.white,
              ),
              SizedBox(
                width: 10.0,
              ),
              Text(
                message,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 17.0,
                    fontWeight: FontWeight.normal),
              ),
            ],
          )),
      duration: Duration(seconds: 4),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
}