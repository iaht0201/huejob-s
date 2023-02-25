import 'package:app_tim_kiem_viec_lam/core/models/user_model.dart';
import 'package:app_tim_kiem_viec_lam/core/routes/routes.dart';
import 'package:app_tim_kiem_viec_lam/screens/profile/profile_edit.dart';
import 'package:app_tim_kiem_viec_lam/screens/profile/profile_setting.dart';
import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../../profile/profile_screen.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key, this.user});
  final UserModel? user;

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    final devicePadding = MediaQuery.of(context).padding;
    return Container(
      padding: EdgeInsets.only(
        top: devicePadding.top + 20,
        left: 20,
        right: 20,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(right: 10),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfileScreen()));
                  },
                  child: user!.imageUrl == null
                      ? (CircleAvatar(
                          radius: 35,
                          backgroundColor: HexColor("#BB2649"),
                          child: Text(
                              "${user?.name.toString().substring(0, 1).toUpperCase()}",
                              style: TextStyle(fontSize: 40))))
                      : CircleAvatar(
                          radius: 35,
                          backgroundColor: HexColor("#BB2649"),
                          backgroundImage: NetworkImage("${user!.imageUrl}"),
                        ),
                ),
              ),
              Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Xin chào ${user!.name}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "HueJob's",
                        style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        "Luôn đồng hành cùng bạn!",
                        style: TextStyle(color: Colors.grey[400], fontSize: 14),
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Container(
                child: const Badge(
                  // show daaus cham
                  showBadge: true,
                  child: Icon(
                    Icons.notifications_none,
                    size: 35,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
            ],
          )
        ],
      ),
    );
  }
}
