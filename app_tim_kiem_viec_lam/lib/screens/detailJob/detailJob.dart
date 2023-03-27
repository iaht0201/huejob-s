import 'package:app_tim_kiem_viec_lam/core/models/jobsModel.dart';
import 'package:app_tim_kiem_viec_lam/core/providers/jobsProvider.dart';
import 'package:app_tim_kiem_viec_lam/screens/profile/widgets/button_arrow.dart';
import 'package:app_tim_kiem_viec_lam/utils/constant.dart';
import 'package:app_tim_kiem_viec_lam/widgets/AvatarWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../../core/providers/postProvider.dart';
import '../../core/providers/userProvider.dart';
import '../home/widgets/home_app_bar.dart';

class DetailJob extends StatefulWidget {
  DetailJob({super.key, required this.jobId});
  final String jobId;
  @override
  State<DetailJob> createState() => _DetailJobState();
}

late JobsProvider jobProvider;

class _DetailJobState extends State<DetailJob> {
  late TabController _tabController;
  bool isLoad = false;
  void initState() {
    jobProvider = Provider.of<JobsProvider>(context, listen: false);
    jobProvider.getJobById(widget.jobId).whenComplete(() {
      setState(() {
        isLoad = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SafeArea(
            child: isLoad == true
                ? Consumer<JobsProvider>(
                    builder: (context, jobsProvider, child) {
                      return Container(
                        color: HexColor("#FFFFFF").withOpacity(0.8),
                        width: 1.sw,
                        child: Column(
                          children: [
                            _headerDetail(context, job: jobsProvider.jobById),
                            SizedBox(
                              height: 26.h,
                            ),
                            _bodyDetail(context, job: jobsProvider.jobById),
                          ],
                        ),
                        // height: 1.sh,
                      );
                    },
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  )),
      ),
      bottomNavigationBar: BottomAppBar(
          color: Colors.transparent,
          elevation: 0.0,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
            // color: Colors.transparent,
            height: 0.1.sh,
            child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  child: Text('Apply Now',
                      style: textTheme.medium16(color: "FFFFFF")),
                ),
                style: ElevatedButton.styleFrom(
                    primary: HexColor("#BB2649"),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r)))),
          )),
    );
  }

  _headerDetail(BuildContext context, {required JobModel job}) {
    return Stack(
      children: [
        Container(
          width: 1.sw,
          height: 306.h,
          decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                opacity: 0.1,
                image: AssetImage(
                  'assets/images/jobs/effectFeature.png',
                ),
              ),
              borderRadius:
                  BorderRadius.only(bottomRight: Radius.circular(100.r)),
              color: HexColor("#BB2649")),
        ),
        Positioned(
            child: Container(
          padding: EdgeInsets.only(right: 24.w),
          child: Row(
            children: [
              buttonArrow(context, color: "FFFFFF"),
              Spacer(),
              Icon(
                Icons.bookmark_add,
                color: Colors.white,
                size: 23,
              )
            ],
          ),
        )),
        Center(
          child: Container(
              padding: EdgeInsets.only(right: 24.w, top: 20.h),
              child: Column(
                children: [
                  CircleAvatar(
                      radius: 45.r,
                      backgroundColor: Colors.white,
                      child: AvatarWidget(context,
                          user: job!.users, radius: 25.r)),
                  SizedBox(height: 12.h),
                  Text(
                    "${job.jobName}",
                    style: textTheme.headline20(),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    "${job.users!.name}",
                    style: textTheme.headline14(opacity: 0.6),
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Them thoi gian lam viec , full time , part time ...

                      _itemHagTag(context, "${job.role}"),
                      _itemHagTag(context, "${job.categoryJob}"),
                      // _itemHagTag(context, "${job.wage}"),
                      _itemHagTag(context, "${job.role}")
                    ],
                  ),
                  SizedBox(height: 24.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "${job.wage}",
                        style: textTheme.semibold16(),
                      ),
                      Text(
                        "${job.location}",
                        style: textTheme.semibold16(),
                      )
                    ],
                  )
                ],
              )),
        )
      ],
    );
  }

  _itemHagTag(BuildContext context, String text) {
    return Container(
      margin: EdgeInsets.only(left: 13.w),
      padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(65.r),
      ),
      child: Text(
        '$text',
        style: textTheme.regular11(color: "FFFFFF"),
      ),
    );
  }

  _bodyDetail(BuildContext context, {required JobModel job}) {
    return Container(
      width: 1.sw,
      child: DefaultTabController(
        length: 4,
        child: Column(children: [
          TabBar(
              unselectedLabelColor: Colors.grey,
              indicatorColor: HexColor("#BB2649"),
              tabs: [
                Tab(
                  child: Text(
                    "Description",
                    style: textTheme.medium14(),
                  ),
                ),
                Tab(
                  child: Text(
                    "Requirement",
                    style: textTheme.medium14(),
                  ),
                ),
                Tab(
                  child: Text(
                    "About",
                    style: textTheme.medium14(),
                  ),
                ),
                Tab(
                  child: Text(
                    "Reviews",
                    style: textTheme.medium14(),
                  ),
                ),
              ]),
          Container(
            margin: EdgeInsets.only(left: 24.w, right: 24.w, top: 20.h),
            // color: Color(0xFFF44336),
            height: 300.h,
            child: TabBarView(
              children: [
                _tabBarView('${job.description}'),
                _tabBarView('${job.jobName}'),
                _tabBarView('${job.description}'),
                _tabBarView('${job.description}'),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Widget _tabBarView(String content) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        child: Text("${content}"),
      ),
    );
  }
}
