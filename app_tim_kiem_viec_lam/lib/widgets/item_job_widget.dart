import 'package:app_tim_kiem_viec_lam/core/models/jobs_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';

import '../screens/detailJob/detail_job.dart';
import '../screens/profile/profile_screen.dart';
import '../utils/constant.dart';

class ItemJobWidget extends StatelessWidget {
  ItemJobWidget({super.key, required this.job});
  JobModel job;
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
          margin: EdgeInsets.only(right: 15.w, top: 20.h),
          width: 156.w,
          height: 190.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: GestureDetector(
                  onTap: () {
                    // _navigatorDrawer(context);
                    // Scaffold.of(context).openDrawer();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ProfileScreen(clientID: job.userId)));
                  },
                  child: job.users!.imageUrl == null
                      ? (CircleAvatar(
                          radius: 22.r,
                          backgroundColor: HexColor("#BB2649"),
                          child: Text(
                              "${job.users!.name.toString().substring(0, 1).toUpperCase()}",
                              style: const TextStyle(fontSize: 25))))
                      : CircleAvatar(
                          radius: 22.r,
                          backgroundColor: HexColor("#BB2649"),
                          backgroundImage:
                              NetworkImage("${job.users!.imageUrl}"),
                        ),
                ),
              ),
              SizedBox(
                height: 12.h,
              ),
              Text(
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                "${job.jobName}",
                style: textTheme.sub14(),
              ),
              SizedBox(
                height: 4.h,
              ),
              Text(
                "${job.users?.fullname ?? job.users?.name}",
                style: textTheme.regular13(color: "#0D0D26", opacity: 0.6),
              ),
              SizedBox(
                height: 8.h,
              ),
              Text(
                "${job.wage}",
                style: textTheme.medium12(),
              ),
            ],
          )),
    );
  }
}
