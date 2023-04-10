import 'package:app_tim_kiem_viec_lam/core/models/jobs_model.dart';
import 'package:app_tim_kiem_viec_lam/widgets/avatar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../screens/detailJob/detail_job.dart';
import '../utils/constant.dart';

class ItemJobHorizal extends StatelessWidget {
  const ItemJobHorizal({super.key, required this.job});
  final JobModel job;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    DetailJobScreen(jobId: job.jobId.toString())));
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 25.w),
        margin: EdgeInsets.only(top: 17.h),
        width: 1.sw,
        height: 100.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AvatarWidget(context, user: job.users, radius: 22),
              Text(
                "${job.users!.name}",
                style: textTheme.regular13(color: "#0D0D26", opacity: 0.6),
              )
            ],
          ),
          SizedBox(
            width: 16.5.w,
          ),

          Column(
            children: [
              Container(
                width: 0.57.sw,
                child: Text(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  "${job.jobName}",
                  style: textTheme.sub14(),
                ),
              ),
              Container(
                width: 0.57.sw,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "💰 ${job.wage}",
                      style: textTheme.medium12(),
                    ),
                    Text(
                      "💼 ${job.categoryJob} - 🏭 ${job.getCity}",
                      style:
                          textTheme.regular13(color: "#0D0D26", opacity: 0.6),
                    )
                  ],
                ),
              )
            ],
          ),

          // Column(
          //   crossAxisAlignment: CrossAxisAlignment.end,
          //   children: [
          //     Text(
          //       "${job.wage}",
          //       style: textTheme.medium12(),
          //     ),
          //     Spacer(),
          //     Text(
          //       "${job.categoryJob} - ${job.getCity}",
          //       style: textTheme.regular13(color: "#0D0D26", opacity: 0.6),
          //     )
          //   ],
          // ),
        ]),
      ),
    );
  }
}
