import 'package:app_tim_kiem_viec_lam/core/models/user_model.dart';
import 'package:app_tim_kiem_viec_lam/core/providers/userProvider.dart';

import 'package:flutter/material.dart';

import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;
import '../../profile/profile_screen.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key, this.user, required this.isScroll});
  final UserModel? user;
  final bool isScroll;
  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    final devicePadding = MediaQuery.of(context).padding;
    return Container(
        width: deviceWidth * 1,
        padding: EdgeInsets.only(
          top: devicePadding.top + 5,
          left: 20,
          right: 20,
          bottom: 10,
        ),
        child: Consumer<UserProvider>(
          builder: (context, userProvider, _) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      margin:
                          EdgeInsets.only(right: isScroll == false ? 10 : 0),
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
                                backgroundImage: NetworkImage(
                                    "${userProvider.user!.imageUrl}"),
                              ),
                      ),
                    ),
                    isScroll == false
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Xin chào ${userProvider.user!.fullname == null ? userProvider.user!.name : userProvider.user!.fullname}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                    color: Colors.white),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                "HueJob's",
                                style: TextStyle(
                                    color: Colors.grey[300],
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Text(
                                "Luôn đồng hành cùng bạn!",
                                style: TextStyle(
                                    color: Colors.grey[400], fontSize: 14),
                              )
                            ],
                          )
                        : Text(
                            ' ${userProvider.user!.fullname == null ? userProvider.user!.name : userProvider.user!.fullname}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white),
                          ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      child: badges.Badge(
                          // show daaus cham
                          showBadge: true,
                          child: Image(
                            image: AssetImage("assets/icons/noti.png"),
                            width: 35,
                            height: 35,
                          )
                          // Icon(
                          //   Icons.notifications_none,
                          //   size: 35,
                          // ),
                          ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                )
              ],
            );
          },
        ));
  }
}
