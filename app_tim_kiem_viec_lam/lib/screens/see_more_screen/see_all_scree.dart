import 'package:app_tim_kiem_viec_lam/core/providers/jobs_rovider.dart';
import 'package:app_tim_kiem_viec_lam/screens/profile/widgets/button_arrow.dart';
import 'package:app_tim_kiem_viec_lam/utils/constant.dart';
import 'package:app_tim_kiem_viec_lam/widgets/item_job_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../../core/models/jobs_model.dart';

class SeeAllScreen extends StatefulWidget {
  const SeeAllScreen({super.key, required this.styleJob});
  final String styleJob;

  @override
  State<SeeAllScreen> createState() => _SeeAllScreenState();
}

class _SeeAllScreenState extends State<SeeAllScreen> {
  late JobsProvider jobProvider;
  void initState() {
    jobProvider = Provider.of<JobsProvider>(context, listen: false);

    super.initState();
  }

  Future handleBuildJob() async {
    switch (widget.styleJob) {
      case "Featured Jobs":
        return jobProvider.fetchFeaturedJobs("Công nghệ thông tin");

      case "Recommended Jobs":
        return jobProvider.fetchRecommendJobs();
      case "Other Jobs":
        return jobProvider.fetchJobother();

      default:
        return jobProvider.fetchRolesJob(widget.styleJob);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: buttonArrow(context, color: "FFFFFF"),
        backgroundColor: HexColor("#BB2649"),
        shadowColor: Colors.transparent,
        title: Container(
          child: Text(widget.styleJob),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
            height: 1.sh,
            width: 1.sw,
            child: FutureBuilder(
              future: handleBuildJob(),
              builder: (context, snapshot) {
                List<JobModel> jobs = [];
                if (snapshot.hasData) {
                  jobs = snapshot.data;
                  if (jobs.length == 0) {
                    return Container(
                      width: 1.sw,
                      margin: EdgeInsets.symmetric(
                          vertical: 20.h, horizontal: 25.w),
                      child: Text(
                        "'${widget.styleJob}' hiện không có job nào!",
                        style: textTheme.regular13(),
                      ),
                    );
                  }
                  return GridView.count(
                    primary: false,
                    padding: const EdgeInsets.all(20),
                    crossAxisSpacing: 10.h,
                    mainAxisSpacing: 10.w,
                    crossAxisCount: 2,
                    children: <Widget>[
                      ...jobs.map((job) => ItemJobWidget(job: job)).toList()
                    ],
                  );
                } else if (snapshot.hasError) {
                  // print(snapshot.error);
                  return Text("${snapshot.error}");
                } else
                  return Container(
                    margin: EdgeInsets.only(top: 20.h),
                    child: GridView.count(
                        primary: false,
                        padding: const EdgeInsets.all(20),
                        crossAxisSpacing: 10.h,
                        mainAxisSpacing: 10.w,
                        crossAxisCount: 2,
                        children: List.generate(
                            6,
                            (index) => shimmerFromColor(
                                  width: 156.w,
                                  height: 164.h,
                                ))),
                  );
              },
            )),
      ),

      // body:  ,
    );
  }
}
