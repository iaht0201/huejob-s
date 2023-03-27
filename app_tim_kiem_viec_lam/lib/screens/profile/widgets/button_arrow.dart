import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

buttonArrow(BuildContext context, {String color = "000000"}) {
  return Padding(
      padding: const EdgeInsets.all(10.0),
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
            clipBehavior: Clip.hardEdge,
            height: 55,
            width: 55,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(25)),
            child: Icon(
              Icons.arrow_back_ios,
              color: HexColor("${color}"),
            )),
      ));
}
