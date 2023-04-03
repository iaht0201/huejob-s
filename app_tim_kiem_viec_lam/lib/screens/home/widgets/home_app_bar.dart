import 'package:app_tim_kiem_viec_lam/core/models/user_model.dart';
import 'package:app_tim_kiem_viec_lam/core/providers/userProvider.dart';
import 'package:app_tim_kiem_viec_lam/utils/constant.dart';
import 'package:app_tim_kiem_viec_lam/widgets/AvatarWidget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    final devicePadding = MediaQuery.of(context).padding;
    return Container(
        width: 1.sw,
        padding: EdgeInsets.only(
          top: devicePadding.top.h + 5.h,
          left: 20.w,
          right: 20.w,
          bottom: 10.h,
        ),
        child: Consumer<UserProvider>(
          builder: (context, userProvider, _) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AvatarWidget(context, user: user, radius: 40.r),
                    SizedBox(
                      width: 8.w,
                    ),
                    isScroll == false
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Xin chào",
                                  style: textTheme.headline17(
                                    color: "FFFFFF",
                                  )),
                              SizedBox(
                                height: 5.h,
                              ),
                              Text(
                                ' ${userProvider.user.fullname ?? userProvider.user.name ?? ""} 👋',
                                style: textTheme.headline17(),
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              Text(
                                "HueJob's Luôn đồng hành cùng bạn!",
                                style: textTheme.headline14(
                                    color: "FFFFFF", opacity: 0.6),
                              )
                            ],
                          )
                        : Text(
                            ' ${userProvider.user!.fullname ?? userProvider.user!.name}',
                            style: textTheme.headline22(),
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
                            width: 28.w,
                            height: 28.h,
                          )),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                  ],
                )
              ],
            );
          },
        ));
  }
}
