import 'package:app_tim_kiem_viec_lam/core/models/jobsModel.dart';
import 'package:app_tim_kiem_viec_lam/core/models/user_model.dart';
import 'package:app_tim_kiem_viec_lam/utils/constant.dart';
import 'package:app_tim_kiem_viec_lam/widgets/item_job_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/jobsProvider.dart';
import '../../detailJob/detailJob.dart';
import '../../profile/profile_screen.dart';
import '../../see_more_screen/see_all_scree.dart';

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
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              SeeAllScreen(styleJob: "Recommended Jobs")));
                },
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
              future: jobsProvider.fetchRecommendJobs(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<JobModel> jobs = snapshot.data;
                  return Row(
                    children: [
                      ...jobs
                          .map(
                            (job) => ItemJobWidget(job: job),
                          )
                          .toList()
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                } else {
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
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
