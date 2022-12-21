import 'package:flutter/material.dart';

class ItemListMenu extends StatelessWidget {
  const ItemListMenu({
    Key key,
    this.icon,
    this.name,
    this.data,
    this.onPressed,
  }) : super(key: key);

  final IconData icon;
  final String name;
  final String data;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Icon(
              icon,
              size: 29,
            ),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                      fontSize: onPressed != null ? 20 : 18,
                      fontWeight: FontWeight.w500),
                ),
                onPressed != null
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Text(
                          data ?? "-",
                          style: const TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                      ),
              ],
            ),
          )),
          onPressed == null
              ? Container()
              : const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Icon(
                    Icons.arrow_forward_ios_outlined,
                    color: Colors.black45,
                  ),
                ),
        ],
      ),
    );
  }
}
