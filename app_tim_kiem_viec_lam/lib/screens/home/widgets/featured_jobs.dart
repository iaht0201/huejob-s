import 'package:app_tim_kiem_viec_lam/core/models/jobs_model.dart';
import 'package:app_tim_kiem_viec_lam/core/models/user_model.dart';
import 'package:app_tim_kiem_viec_lam/core/providers/user_provider.dart';
import 'package:app_tim_kiem_viec_lam/screens/detailJob/detail_job.dart';
import 'package:app_tim_kiem_viec_lam/screens/see_more_screen/see_all_scree.dart';
import 'package:carousel_indicator/carousel_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/providers/jobs_provider.dart';
import '../../../data/home/featureJobsData.dart';
import '../../../utils/constant.dart';
import '../../profile/profile_screen.dart';

class FeaturedJobs extends StatefulWidget {
  const FeaturedJobs({super.key});

  @override
  State<FeaturedJobs> createState() => _FeaturedJobsState();
}

class _FeaturedJobsState extends State<FeaturedJobs> {
  late JobsProvider jobsProvider;
  late UserProvider userProvider;
  void initState() {
    jobsProvider = Provider.of<JobsProvider>(context, listen: false);
    userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.fetchUser();
    super.initState();
  }

  int jobIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 20.h, horizontal: 5.w),
        // height: 290.h,
        width: 1.sw,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 12.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Công việc quan tâm",
                      style: textTheme.sub16(),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    SeeAllScreen(styleJob: "Featured Jobs")));
                      },
                      child: Text(
                        "Xem thêm",
                        style: textTheme.regular13(color: "95969D"),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20.h),
                // width: 1.sw,
                // height: 210.h,
                child: FutureBuilder(
                  future: jobsProvider.fetchFeaturedJobs(userProvider.user),
                  builder: (context, snapshot) {
                    List<JobModel> jobs = [];
                    if (snapshot.hasData) {
                      jobs = snapshot.data;
                      print(jobs);
                      return Column(
                        children: [
                          CarouselSlider(
                              options: CarouselOptions(
                                // autoPlay: true,
                                autoPlayCurve: Curves.linear,
                                aspectRatio: 2.0,
                                height: 200.h,

                                // enlargeCenterPage: true,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    jobIndex = index;
                                    print(index);
                                  });
                                },
                              ),
                              items: jobs.map((e) {
                                return _itemFeaturedJobs(context, e);
                              }).toList()),
                          SizedBox(
                            height: 20.h,
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                jobs.length,
                                (index) => buildDot(index, context),
                              ),
                            ),
                          ),
                        ],
                      );
                    } else
                      return Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            shimmerFromColor(height: 200.h, width: 30.w),
                            shimmerFromColor(height: 200.h, width: 280.w),
                            shimmerFromColor(height: 200.h, width: 30.w),
                          ],
                        ),
                      );
                  },
                ),
              ),
            ]));
  }

  Container buildDot(int index, BuildContext context) {
    return Container(
      height: 10,
      width: jobIndex == index ? 25 : 10,
      margin: EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: HexColor("#BB2649"),
      ),
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

  Widget _itemFeaturedJobs(BuildContext context, JobModel item) {
    var _checkIsBookMark;
    return FutureBuilder(
      future: jobsProvider.checkIsBookMarkJob(item.jobId.toString()),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _checkIsBookMark = snapshot.data;
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          DetailJobScreen(jobId: item.jobId.toString())));
            },
            child: Container(
              margin: EdgeInsets.only(left: 13.w),
              decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    opacity: 0.2,
                    image: AssetImage(
                      'assets/images/jobs/effectFeature.png',
                    ),
                  ),
                  borderRadius: BorderRadius.circular(24.r),
                  color: HexColor("#BB2649")
                  // padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 24.w),
                  ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 24.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          padding: EdgeInsets.all(12),
                          child: Container(
                            child: GestureDetector(
                              onTap: () {
                                // _navigatorDrawer(context);
                                // Scaffold.of(context).openDrawer();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProfileScreen(
                                            clientID: item.userId)));
                              },
                              child: item.users!.imageUrl == null
                                  ? (CircleAvatar(
                                      radius: 18.r,
                                      backgroundColor: HexColor("#BB2649"),
                                      child: Text(
                                          "${item.users!.name.toString().substring(0, 1).toUpperCase()}",
                                          style:
                                              const TextStyle(fontSize: 25))))
                                  : CircleAvatar(
                                      radius: 18.r,
                                      backgroundColor: HexColor("#BB2649"),
                                      backgroundImage: NetworkImage(
                                          "${item.users!.imageUrl}"),
                                    ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 16.5.w,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 0.32.sw,
                              child: Text(
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                "${item.jobName}",
                                style: textTheme.semibold16(),
                              ),
                            ),
                            SizedBox(height: 3.h),
                            Text(
                              "${item.users!.name}",
                              style: textTheme.medium14(
                                  opacity: 0.6, color: "FFFFFF"),
                            ),
                          ],
                        ),
                        Spacer(),
                        _checkIsBookMark == false
                            ? GestureDetector(
                                onTap: () {
                                  jobsProvider
                                      .addBookMarkJob(item.jobId.toString());
                                  setState(() {
                                    _checkIsBookMark = true;
                                  });
                                },
                                child: Icon(
                                  Icons.bookmark_add,
                                  color: Colors.white,
                                ),
                              )
                            : GestureDetector(
                                onTap: () {
                                  jobsProvider
                                      .deleteBookMarkJob(item.jobId.toString());
                                  setState(() {
                                    _checkIsBookMark = true;
                                  });
                                },
                                child: Icon(
                                  Icons.bookmark,
                                  color: HexColor("#26BB98"),
                                ),
                              )
                      ],
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _itemHagTag(context, "${item.role}"),
                        _itemHagTag(context, "${item.categoryJob}")
                      ],
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${item.wage}",
                          style: textTheme.medium14(color: "FFFFFF"),
                        ),
                        Text(
                          "${item.getCity}",
                          style:
                              textTheme.medium14(opacity: 0.6, color: "FFFFFF"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return shimmerFromColor(height: 200.h, width: 280.w);
        }
      },
    );
  }
}
