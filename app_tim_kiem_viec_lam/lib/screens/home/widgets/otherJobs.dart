import 'package:app_tim_kiem_viec_lam/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../core/models/jobsModel.dart';
import '../../../core/providers/jobsProvider.dart';
import '../../../widgets/AvatarWidget.dart';
import '../../detailJob/detailJob.dart';

class OtherJobs extends StatefulWidget {
  const OtherJobs({super.key});

  @override
  State<OtherJobs> createState() => _OtherJobsState();
}

class _OtherJobsState extends State<OtherJobs> {
  late JobsProvider jobsProvider;
  void initState() {
    jobsProvider = Provider.of<JobsProvider>(context, listen: false);
    super.initState();
  }

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
          FutureBuilder(
            future: jobsProvider.fetchJobother(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<JobModel> jobs = snapshot.data;
                return Column(
                  children: [...jobs.map((job) => _itemOtherJob(context, job))],
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              } else
                return CircularProgressIndicator();
            },
          )
        ],
      ),
    );
  }

  _itemOtherJob(BuildContext context, JobModel job) {
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
        height: 74.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(children: [
          AvatarWidget(context, user: job.users, radius: 25),
          SizedBox(
            width: 16.5.w,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${job.jobName}",
                style: textTheme.sub14(),
              ),
              Spacer(),
              Text(
                "${job.users!.name}",
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
      ),
    );
  }
}
