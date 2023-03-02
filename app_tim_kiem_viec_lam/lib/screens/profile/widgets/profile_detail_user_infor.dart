import 'package:flutter/material.dart';

class InforUser extends StatelessWidget {
  InforUser({super.key, this.icon, this.text});
  final String? text;
  final IconData? icon;
  @override
  Widget build(BuildContext context) {
    return text == null || text == "null"
        ? Container()
        : Container(
            margin: EdgeInsets.symmetric(vertical: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon),
                SizedBox(
                  width: 5,
                ),
                Container(
                    padding: EdgeInsets.symmetric(vertical: 2),
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Text(
                      "${text}",
                      textAlign: TextAlign.justify,
                    ))
              ],
            ),
          );
  }
}
