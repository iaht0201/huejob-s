import 'package:app_tim_kiem_viec_lam/core/models/jobsModel.dart';
import 'package:app_tim_kiem_viec_lam/core/models/user_model.dart';
import 'package:app_tim_kiem_viec_lam/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/jobsProvider.dart';
import '../../detailJob/detailJob.dart';
import '../../profile/profile_screen.dart';

class RecommendJobs extends StatefulWidget {
  const RecommendJobs({super.key, required this.user});
  final UserModel user;
  @override
  State<RecommendJobs> createState() => _RecommendJobsState();
}

class _RecommendJobsState extends State<RecommendJobs> {
  late JobsProvider jobsProvider;
  void initState() {
    jobsProvider = Provider.of<JobsProvider>(context, listen: false);

    super.initState();
  }

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
            child: FutureBuilder(
              future: jobsProvider.fetchRecommendJobs(widget.user),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<JobModel> jobs = snapshot.data;
                  return Row(
                    children: [
                      ...jobs
                          .map(
                            (job) => _itemRecommendedJobs(context, job),
                          )
                          .toList()
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                } else
                  return Container(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          shimmerFromColor(height: 164.h, width: 156.w),
                          SizedBox(
                            width: 15.w,
                          ),
                          shimmerFromColor(height: 164.h, width: 156.w),
                          SizedBox(
                            width: 15.w,
                          ),
                          shimmerFromColor(height: 164.h, width: 156.w),
                        ],
                      ),
                    ),
                  );
              },
            ),
          ),
        ],
      ),
    );
  }

  // _itemFeaturedJobs(BuildContext context, JobModel job) {
  //   return Container(
  //     padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 25.w),
  //     margin: EdgeInsets.only(top: 20.h),
  //     width: 156.sw,
  //     height: 164.h,
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(20.r),
  //     ),
  //     child: Row(children: [
  //       Image(
  //         image: AssetImage("assets/images/jobs/job1.png"),
  //         width: 43.w,
  //         height: 43.h,
  //       ),
  //       SizedBox(
  //         width: 16.5.w,
  //       ),
  //       Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text(
  //             "Jr Executive",
  //             style: textTheme.sub14(),
  //           ),
  //           Spacer(),
  //           Text(
  //             "Burger King",
  //             style: textTheme.regular13(color: "#0D0D26", opacity: 0.6),
  //           )
  //         ],
  //       ),
  //       Spacer(),
  //       Column(
  //         crossAxisAlignment: CrossAxisAlignment.end,
  //         children: [
  //           Text(
  //             "\$96,000/y",
  //             style: textTheme.medium12(),
  //           ),
  //           Spacer(),
  //           Text(
  //             "Los Angels, US",
  //             style: textTheme.regular13(color: "#0D0D26", opacity: 0.6),
  //           )
  //         ],
  //       ),
  //     ]),
  //   );
  // }

  _itemRecommendedJobs(BuildContext context, JobModel job) {
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
          height: 164.h,
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
