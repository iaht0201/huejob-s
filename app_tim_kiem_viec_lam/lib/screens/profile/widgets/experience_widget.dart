import 'dart:ui';

import 'package:app_tim_kiem_viec_lam/core/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../utils/constant.dart';
import '../../see_more_screen/see_all_scree.dart';

class ExperienceWidget extends StatelessWidget {
  const ExperienceWidget({super.key, this.experience, this.isClient = false});
  final List<ExperienceModel>? experience;
  final bool isClient;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 12.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    "Kinh nghiệm",
                    style: textTheme.sub16(),
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  isClient == false
                      ? GestureDetector(
                          onTap: () {},
                          child: Icon(
                            Icons.edit_square,
                            size: 18,
                          ),
                        )
                      : Container()
                ],
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              SeeAllScreen(styleJob: "Featured Jobs")));
                },
                child: Text(
                  "Xem thêm",
                  style: textTheme.regular13(color: "95969D"),
                ),
              ),
            ],
          ),
        ),
        // SizedBox(
        //   height: 8.h,
        // ),
        ...List.generate(1, (index) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 15.w),
            margin: EdgeInsets.only(top: 17.h),
            width: 1.sw,
            height: 115.h,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                opacity: 0.1,
                image: AssetImage(
                  'assets/images/jobs/effectFeature.png',
                ),
              ),
              color: HexColor("#26BB98"),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              children: [
                Container(
                  width: 0.13.sw,
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                          radius: 30.r,
                          backgroundColor: HexColor("#BB2649"),
                          child: Text("T", style: TextStyle(fontSize: 25.sp))),
                    ],
                  ),
                ),
                SizedBox(
                  width: 8.w,
                ),
                Container(
                  width: 0.63.sw,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 0.35.sw,
                            child: Text(
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              "${experience?[index].jobTitle}",
                              style: textTheme.semibold14(),
                            ),
                          ),
                          Text(
                            "${experience?[index].startDate} - ${experience?[index].endDate}",
                            style: textTheme.medium12(
                                color: "0D0D26", opacity: 0.5),
                          )
                        ],
                      ),
                      Text(
                        "🏠 ${experience?[index].company_name}",
                        style: textTheme.medium12(color: "FFFFFF"),
                      ),
                      SizedBox(
                        height: 6.h,
                      ),
                      Container(
                          width: 1.sw,
                          child: Text(
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            "${experience?[index].description}",
                            style: textTheme.medium12(
                                color: "FFFFFF", opacity: 0.5),
                          ))
                    ],
                  ),
                )
              ],
            ),
          );
        }).toList(),
      ],
    );
  }
}
