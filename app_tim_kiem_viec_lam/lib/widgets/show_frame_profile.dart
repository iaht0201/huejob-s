import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/models/user_model.dart';
import '../utils/constant.dart';
import 'avatar_widget.dart';

class ShowProfile extends StatelessWidget {
  const ShowProfile({super.key, required this.user});
  final UserModel user;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Select a profile",
            style: textTheme.semibold16(color: "000000"),
          ),
          SizedBox(
            height: 16.h,
          ),
          Container(
              width: 140.w,
              height: 155.h,
              // margin: EdgeInsets.only(right: 15.w, top: 20.h),
              padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 15.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Stack(
                children: [
                  Container(
                    width: 1.sw,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AvatarWidget(context, user: user, radius: 30.r),
                        SizedBox(
                          height: 12.h,
                        ),
                        SizedBox(
                          height: 4.h,
                        ),
                        Text(
                          "${user.fullname ?? user?.name} 💚",
                          style: textTheme.regular13(
                              color: "#0D0D26", opacity: 0.6),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                      right: 0,
                      child: Container(
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blueAccent,
                        ),
                        child: GestureDetector(
                          onTap: () {},
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ))
                ],
              )),
        ],
      ),
    );
  }
}
