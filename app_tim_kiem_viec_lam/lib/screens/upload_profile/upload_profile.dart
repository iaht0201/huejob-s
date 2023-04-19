import 'package:app_tim_kiem_viec_lam/core/models/user_model.dart';
import 'package:app_tim_kiem_viec_lam/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../../core/models/job_category_model.dart';
import '../../core/providers/post_provider.dart';
import '../../core/providers/user_provider.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  bool isSelected = false;
  late PostProvider postProvider;
  late UserProvider? userProvider;
  List<JobCategoryModel> jobCategorytList = [];
  List<JobCategoryModel> searchResult = [];
  List<JobCategoryModel> _listSelectedCategory = [];
  bool isLoad = false;
  @override
  void initState() {
    super.initState();
    postProvider = Provider.of<PostProvider>(context, listen: false);
    userProvider = Provider.of<UserProvider>(context, listen: false);
    postProvider.getJobCategory(limit: 100).whenComplete(() {
      userProvider!.fetchUser().whenComplete(
        () {
          setState(() {
            isLoad = true;
          });
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
            width: 1.sw,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    "assets/images/logo_huejob.png",
                    width: 0.6.sw,
                    fit: BoxFit.fitWidth,
                  ),
                ),
                Text(
                  "Lựa chọn công việc bạn quan tâm ",
                  style: textTheme.semibold24(),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Text(
                  "Hãy lựa chọn ít nhất 1 công việc quan tâm để chúng tôi có thể giúp bạn tiếp cận một cách dễ dàng.",
                  style: textTheme.medium14(),
                ),
                SizedBox(
                  height: 20.h,
                ),
                _popualarRoles(context, postProvider.jobs)
              ],
            ),
          ),
        ),
        bottomNavigationBar:
            Consumer<UserProvider>(builder: (context, userProvider, child) {
          return BottomAppBar(
              color: Colors.transparent,
              elevation: 0.0,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
                // color: Colors.transparent,
                height: 0.1.sh,
                child: ElevatedButton(
                    onPressed: () async {
                      if (_listSelectedCategory.isEmpty) {
                        Fluttertoast.showToast(
                          msg:
                              'Vui lòng lựa chọn ít nhất 1 công việc bạn quan tâm!',
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: HexColor("#BB2649"),
                          textColor: Colors.white,
                        );
                      } else {
                        UserModel newUser = userProvider.user
                            .copyWith(careAbout: _listSelectedCategory);

                        userProvider.updateUser(context, newUser,
                            action: "next_update_profile");
                      }
                    },
                    child: Container(
                      child: Text('Tiếp theo',
                          style: textTheme.medium16(color: "FFFFFF")),
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: HexColor("#BB2649"),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r)))),
              ));
        }));
  }

  _popualarRoles(conetx, List<JobCategoryModel> roles) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isLoad == true
              ? Container(
                  width: 1.sw,
                  child: Wrap(
                    spacing: 10.w,
                    children: [
                      ...roles.map((e) => GestureDetector(
                            onTap: () {
                              setState(() {
                                if (_listSelectedCategory.contains(e)) {
                                  _listSelectedCategory.remove(e);
                                } else {
                                  if (_listSelectedCategory.length < 5) {
                                    _listSelectedCategory.add(e);
                                  }
                                }
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: _listSelectedCategory.contains(e)
                                    ? HexColor("#BB2649")
                                    : Colors.grey.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.w, horizontal: 10.w),
                              margin: EdgeInsets.only(bottom: 10.h),
                              child: Text(
                                "${e.jobName}",
                                style: textTheme.regular13(
                                    color: _listSelectedCategory.contains(e)
                                        ? "FFFFFF"
                                        : "000000"),
                              ),
                            ),
                          ))
                    ],
                  ))
              : Container(
                  width: 1.sw,
                  child: Wrap(spacing: 10.w, children: [
                    ...List.generate(9,
                        (index) => shimmerFromColor(width: 90.w, height: 30.h))
                  ]))
        ],
      ),
    );
  }
}
