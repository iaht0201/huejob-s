import 'package:app_tim_kiem_viec_lam/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OtherJobs extends StatelessWidget {
  const OtherJobs({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
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
                "Other Jobs",
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
          Column(
            children: [
              _itemOtherJob(context, "featuresJobs"),
              _itemOtherJob(context, "featuresJobs"),
              _itemOtherJob(context, "featuresJobs"),
              _itemOtherJob(context, "featuresJobs"),
              _itemOtherJob(context, "featuresJobs"),
              _itemOtherJob(context, "featuresJobs"),
              _itemOtherJob(context, "featuresJobs"),
            ],
          )
        ],
      ),
    );
  }

  _itemOtherJob(BuildContext context, String featuresJobs) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 25.w),
      margin: EdgeInsets.only(top: 17.h),
      width: 1.sw,
      height: 74.h,
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
}
