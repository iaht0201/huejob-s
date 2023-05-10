import 'package:app_tim_kiem_viec_lam/core/models/jobs_model.dart';
import 'package:app_tim_kiem_viec_lam/core/providers/jobs_provider.dart';
import 'package:app_tim_kiem_viec_lam/screens/applyJob/apply_job.dart';
import 'package:app_tim_kiem_viec_lam/screens/profile/widgets/button_arrow.dart';
import 'package:app_tim_kiem_viec_lam/utils/constant.dart';
import 'package:app_tim_kiem_viec_lam/widgets/avatar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../../core/providers/post_provider.dart';
import '../../core/providers/user_provider.dart';
import '../addPost/map.dart';
import '../home/widgets/home_app_bar.dart';

class DetailJobScreen extends StatefulWidget {
  DetailJobScreen({super.key, required this.jobId});
  final String jobId;
  @override
  State<DetailJobScreen> createState() => _DetailJobScreenState();
}

late JobsProvider jobProvider;
late UserProvider userProvider;

class _DetailJobScreenState extends State<DetailJobScreen> {
  late TabController _tabController;
  bool isLoad = false;
  bool? checkApply;
  void initState() {
    userProvider = Provider.of<UserProvider>(context, listen: false);
    jobProvider = Provider.of<JobsProvider>(context, listen: false);

    jobProvider.getJobById(widget.jobId).whenComplete(() async {
      checkApply = await jobProvider.checkIsApplyJob(
          jobProvider.jobById, userProvider.user);
      print(checkApply);
      setState(() {
        isLoad = true;
      });
    });

    super.initState();
  }

  Future handleShowButton(String userType) async {
    // Người tuyển dụng không thể ứng tuyển => Không thể ứng tuyển (Hoàn thành)
    // Người ứng tuyển check là đã apply hay chưa => apply và cancel apply (Hoàn thành)
    // Thời hạn của job . Nếu thời hạn của job < Now => Hết hạn apply (Chưa hoàn thành)
    if (userType != "Nhà tuyển dụng") {
      if (checkApply == true) {
        jobProvider
            .cancelApply(context, userProvider.user.userId.toString(),
                jobProvider.jobById.jobId.toString())
            .whenComplete(
          () {
            setState(() {
              checkApply = false;
            });
          },
        );
      } else {
        bool _check = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ApplyJob(
                      job: jobProvider.jobById,
                      user: userProvider.user,
                    )));

        setState(() {
          checkApply = _check;
        });
      }
    } else
      return;
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
                : Container(
                    child: Column(
                      children: [
                        shimmerFromColor(height: 290.h, width: 1.sw),
                        SizedBox(
                          height: 26.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            shimmerFromColor(
                                width: 1.sw / 4 - 10.w, height: 20.h),
                            shimmerFromColor(
                                width: 1.sw / 4 - 10.w, height: 20.h),
                            shimmerFromColor(
                                width: 1.sw / 4 - 10.w, height: 20.h),
                            shimmerFromColor(
                                width: 1.sw / 4 - 10.w, height: 20.h)
                          ],
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        shimmerFromColor(width: 1.sw, height: 0.4.sh),
                      ],
                    ),
                  )),
      ),
      bottomNavigationBar: isLoad
          ? Consumer<UserProvider>(
              builder: (context, userProvider, child) {
                return BottomAppBar(
                    color: Colors.transparent,
                    elevation: 0.0,
                    child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.h, horizontal: 20.w),
                        // color: Colors.transparent,
                        height: 0.1.sh,
                        child: ElevatedButton(
                            onPressed: () async {
                              handleShowButton(
                                  userProvider.user.usertype.toString());
                            },
                            child:
                                userProvider.user.usertype == "Nhà tuyển dụng"
                                    ? Container(
                                        child: Text('Không thể ứng tuyển',
                                            style: textTheme.medium16(
                                                color: "FFFFFF")),
                                      )
                                    : checkApply == false
                                        ? Container(
                                            child: Text('Apply Now',
                                                style: textTheme.medium16(
                                                    color: "FFFFFF")),
                                          )
                                        : Container(
                                            child: Text('Cancel Apply',
                                                style: textTheme.medium16(
                                                    color: "FFFFFF")),
                                          ),
                            style: ElevatedButton.styleFrom(
                                primary: userProvider.user.usertype ==
                                        "Nhà tuyển dụng"
                                    ? HexColor("#8C6E75")
                                    : HexColor("#BB2649"),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(16.r))))));
              },
            )
          : shimmerFromColor(
              width: 0.8.sw,
              height: 0.08.sh,
            ),
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
              color: !job.isExpiration
                  ? HexColor("#BB2649")
                  : HexColor("#95969D")),
        ),
        Positioned(
            child: Container(
          padding: EdgeInsets.only(right: 24.w),
          child: Row(
            children: [
              buttonArrow(context, color: "FFFFFF"),
              Spacer(),
              FutureBuilder(
                future: jobProvider.checkIsBookMarkJob(job.jobId.toString()),
                builder: (context, snapshot) {
                  var _checkIsBookMark;
                  if (snapshot.hasData) {
                    _checkIsBookMark = snapshot.data;
                    return _checkIsBookMark == false
                        ? GestureDetector(
                            onTap: () {
                              jobProvider.addBookMarkJob(job.jobId.toString());
                            },
                            child: Icon(
                              Icons.bookmark_add,
                              color: Colors.white,
                              size: 23,
                            ),
                          )
                        : GestureDetector(
                            onTap: () {
                              jobProvider
                                  .deleteBookMarkJob(job.jobId.toString());
                            },
                            child: Icon(
                              Icons.bookmark,
                              color: HexColor("#26BB98"),
                              size: 23,
                            ),
                          );
                  } else
                    return shimmerFromColor(width: 23.w, height: 23.w);
                },
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
                      _itemHagTag(context, "${job.wokringTime}")
                    ],
                  ),
                  SizedBox(height: 24.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => OpenStreetMap(
                                          isSeen: true,
                                          latitude: job.latitude,
                                          longitude: job.longitude,
                                        )));
                          },
                          child: job.isExpiration
                              ? Text(
                                  "Đã hết hạn",
                                  style: textTheme.medium14(color: "FFFFFF"),
                                )
                              : Text("Thời gian hết hạn: ${job.agoTime}",
                                  style: textTheme.medium14(color: "FFFFFF"))),
                      Text(
                        "${job.wage}",
                        style: textTheme.medium14(color: "FFFFFF"),
                      ),
                      // Text(
                      //   "${job.location}",
                      //   style: textTheme.semibold16(),
                      // )
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
                    "Mô tả",
                    style: textTheme.medium14(),
                  ),
                ),
                Tab(
                  child: Text(
                    "Yêu cầu",
                    style: textTheme.medium14(),
                  ),
                ),
                Tab(
                  child: Text(
                    "Địa chỉ",
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
                _tabBarView('${job.requirement ?? ""}'),
                _tabLocation(
                    job.latitude!.toDouble(), job.longitude!.toDouble()),
                _tabBarView('${job.location}'),
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

  Widget _tabLocation(double latitude, double longitude) {
    return OpenStreetMap(
      isBack: false,
      isSeen: true,
      latitude: latitude,
      longitude: longitude,
    );
  }
}
