import 'package:app_tim_kiem_viec_lam/core/models/user_model.dart';
import 'package:app_tim_kiem_viec_lam/data/home/featureJobsData.dart';
import 'package:app_tim_kiem_viec_lam/screens/profile/widgets/button_arrow.dart';
import 'package:app_tim_kiem_viec_lam/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../../core/models/jobsModel.dart';
import '../../core/providers/userProvider.dart';
import '../../widgets/AvatarWidget.dart';
import '../profile/profile_screen.dart';

class ApplyJob extends StatefulWidget {
  const ApplyJob({super.key, required this.job, required this.user});
  final JobModel job;
  final UserModel user;
  @override
  State<ApplyJob> createState() => _ApplyJobState();
}

class _ApplyJobState extends State<ApplyJob> {
  final ScrollController _scrollController = ScrollController();
  double top = 0.0;
  double _opacity = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                automaticallyImplyLeading: false,
                backgroundColor: HexColor("#FFFFFF"),
                pinned: true,
                expandedHeight: 170.h,
                flexibleSpace: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    top = constraints.biggest.height;
                    if (top.toDouble() < 100) {
                      _opacity = 1;
                    } else {
                      _opacity = 0;
                    }
                    // Neu < 100 thi chi show text , con khong show 1 app bar ở backgroud
                    return FlexibleSpaceBar(
                      expandedTitleScale: 1,
                      collapseMode: CollapseMode.pin,
                      background: _AppBarJobApply(
                        context,
                        job: widget.job,
                        isScroll: false,
                      ),
                      titlePadding: EdgeInsets.only(
                        left: 0,
                        right: 0,
                      ),
                      // title: Container(
                      //   child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //       children: [
                      //         AnimatedOpacity(
                      //             duration: Duration(milliseconds: 0),
                      //             //opacity: top == MediaQuery.of(context).padding.top + kToolbarHeight ? 1.0 : 0.0,
                      //             opacity: _opacity,
                      //             child: HomeAppBar(
                      //                 user: userProvider.user, isScroll: true)),
                      //       ]),
                      // )
                    );
                  },
                ),
              ),
              SliverList(
                  delegate: SliverChildListDelegate([
                Container(
                  margin:
                      EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                  width: 1.sw,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _showProfile(context, widget.user),
                      _submitFile(context)
                    ],
                  ),
                )
              ]))
            ],
          ),
        ],
      ),
      bottomNavigationBar: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          return BottomAppBar(
              color: Colors.transparent,
              elevation: 0.0,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
                // color: Colors.transparent,
                height: 0.1.sh,
                child: ElevatedButton(
                    onPressed: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => ApplyJob(
                      //               job: jobProvider.jobById,
                      //               user: userProvider.user,
                      //             )));
                    },
                    child: Container(
                      child: Text('Apply',
                          style: textTheme.medium16(color: "FFFFFF")),
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: HexColor("#BB2649"),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r)))),
              ));
        },
      ),
    );
  }

  _AppBarJobApply(BuildContext context,
      {required JobModel job, required bool isScroll}) {
    return SafeArea(
      child: Container(
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: buttonArrow(context),
                ),
                Expanded(
                  flex: 6,
                  child: Container(
                    margin: EdgeInsets.only(top: 20.h),
                    alignment: Alignment.center,
                    child: Text(
                      "Apply",
                      style: textTheme.semibold20(color: "000000"),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(),
                ),
              ],
            ),
            Container(
              // width: 1.sw,
              padding: EdgeInsets.symmetric(horizontal: 44.w),
              child: Row(
                children: [
                  AvatarWidget(context, user: job.users, radius: 35),
                  SizedBox(
                    width: 16.5.w,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${job.jobName} ",
                        style: textTheme.sub14(),
                      ),
                      // Spacer(),
                      Text(
                        "${job.users!.name}",
                        style:
                            textTheme.regular13(color: "#0D0D26", opacity: 0.6),
                      )
                    ],
                  ),
                  Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "\$96,000/y",
                        style: textTheme.medium12(),
                      ),
                      Text(
                        "Los Angels, US",
                        style:
                            textTheme.regular13(color: "#0D0D26", opacity: 0.6),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _showProfile(BuildContext context, UserModel user) {
    return Column(
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
            width: 155.w,
            height: 155.h,
            // margin: EdgeInsets.only(right: 15.w, top: 20.h),
            padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 25.w),
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
                        "${user?.fullname ?? user?.name} 💚",
                        style:
                            textTheme.regular13(color: "#0D0D26", opacity: 0.6),
                      ),
                      Text(
                        "${user.job ?? ""}",
                        style: textTheme.sub14(),
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
                        color: Colors.green,
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
    );
  }

  _submitFile(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Text(
          "Cover Later (Optional)",
          style: textTheme.semibold16(color: "000000"),
        ),
        SizedBox(
          height: 16.h,
        ),
      ],
    ));
  }
}
