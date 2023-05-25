import 'package:app_tim_kiem_viec_lam/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../core/models/jobs_model.dart';
import '../../../core/providers/jobs_provider.dart';
import '../../../widgets/avatar_widget.dart';
import '../../../widgets/item_job_horizal.dart';
import '../../detailJob/detail_job.dart';
import '../../see_more_screen/see_all_scree.dart';

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
                "Khấc",
                style: textTheme.sub16(),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              SeeAllScreen(styleJob: "Other Jobs")));
                },
                child: Text(
                  "Xem thêm",
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
                  children: [
                    ...jobs.map((job) => ItemJobHorizal(
                          job: job,
                        ))
                  ],
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              } else
                return Container(
                  child: Column(
                    children: [
                      ...List.generate(
                        3,
                        (_) => shimmerFromColor(height: 74.h, width: 1.sw),
                      ).toList()
                    ],
                  ),
                );
            },
          )
        ],
      ),
    );
  }
}
