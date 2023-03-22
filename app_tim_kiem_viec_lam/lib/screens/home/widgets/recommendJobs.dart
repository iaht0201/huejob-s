import 'package:app_tim_kiem_viec_lam/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecommendJobs extends StatelessWidget {
  const RecommendJobs({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 26.w, right: 26.w),
      // height: 210.h,
      // width: 376.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Recommended Jobs",
                style: textTheme.sub16(),
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  "See all",
                  style: textTheme.regular13(color: "95969D"),
                ),
              ),
            ],
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _itemRecommendedJobs(context, "featuresJobs"),
                _itemRecommendedJobs(context, "featuresJobs"),
                _itemRecommendedJobs(context, "featuresJobs"),
                _itemRecommendedJobs(context, "featuresJobs"),
                _itemRecommendedJobs(context, "featuresJobs"),
              ],
            ),
          )
        ],
      ),
    );
  }

  _itemFeaturedJobs(BuildContext context, String featuresJobs) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 25.w),
      margin: EdgeInsets.only(top: 20.h),
      width: 156.sw,
      height: 164.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(children: [
        Image(
          image: AssetImage("assets/images/jobs/job1.png"),
          width: 43.w,
          height: 43.h,
        ),
        SizedBox(
          width: 16.5.w,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Jr Executive",
              style: textTheme.sub14(),
            ),
            Spacer(),
            Text(
              "Burger King",
              style: textTheme.regular13(color: "#0D0D26", opacity: 0.6),
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
            Spacer(),
            Text(
              "Los Angels, US",
              style: textTheme.regular13(color: "#0D0D26", opacity: 0.6),
            )
          ],
        ),
      ]),
    );
  }

  _itemRecommendedJobs(BuildContext context, String s) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 25.w),
        margin: EdgeInsets.only(right: 15.w, top: 20.h),
        width: 156.w,
        height: 164.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage("assets/images/jobs/job1.png"),
              width: 40.w,
              height: 40.h,
            ),
            SizedBox(
              height: 12.h,
            ),
            Text(
              "Sr Engineer",
              style: textTheme.sub14(),
            ),
            SizedBox(
              height: 4.h,
            ),
            Text(
              "Facebook",
              style: textTheme.regular13(color: "#0D0D26", opacity: 0.6),
            ),
            SizedBox(
              height: 8.h,
            ),
            Text(
              "\$96,000/y",
              style: textTheme.medium12(),
            ),
          ],
        ));
  }
}
