import 'package:app_tim_kiem_viec_lam/core/models/user_model.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';

import '../screens/profile/profile_screen.dart';

Widget AvatarWidget(BuildContext context, {UserModel? user, num radius = 10}) {
  return Container(
    child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProfileScreen(clientID: user.userId)));
        },
        child: user!.imageUrl == null
            ? (CircleAvatar(
                radius: radius.r,
                backgroundColor: HexColor("#BB2649"),
                child: Text(
                    "${user!.name.toString().substring(0, 1).toUpperCase()}",
                    style: const TextStyle(fontSize: 25))))
            : CircleAvatar(
                radius: radius.r,
                backgroundColor: HexColor("#BB2649"),
                backgroundImage: NetworkImage("${user.imageUrl}"),
              )),
  );
}
