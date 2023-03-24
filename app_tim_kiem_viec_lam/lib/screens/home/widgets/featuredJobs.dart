import 'package:app_tim_kiem_viec_lam/core/models/jobsModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../../core/providers/jobsProvider.dart';
import '../../../data/home/featureJobsData.dart';
import '../../../utils/constant.dart';

class FeaturedJobs extends StatefulWidget {
  const FeaturedJobs({super.key});

  @override
  State<FeaturedJobs> createState() => _FeaturedJobsState();
}

class _FeaturedJobsState extends State<FeaturedJobs> {
  late PageController _controller;
  late JobsProvider jobsProvider;
  void initState() {
    _controller = PageController(initialPage: 0);
    jobsProvider = Provider.of<JobsProvider>(context, listen: false);
    jobsProvider.fetchFeaturedJobs('Công nghệ thông tin');
    super.initState();
  }

  final List<String> imgList = [
    'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
    'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
    'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
    'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
        // height: 290.h,
        width: 1.sw,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Featured Jobs",
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
              Container(
                margin: EdgeInsets.only(top: 20.h),
                // width: 1.sw,
                // height: 210.h,
                child: FutureBuilder(
                  future: jobsProvider.fetchFeaturedJobs("Công Nghệ Thông Tin"),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<JobModel> jobs = snapshot.data;
                      print(jobs);
                      return CarouselSlider(
                          options: CarouselOptions(
                            autoPlay: true,
                            aspectRatio: 2.0,
                            enlargeCenterPage: true,
                          ),
                          items: jobs.map((e) {
                            return _itemFeaturedJobs(context, e);
                          }).toList());

                      // return CarouselSlider(
                      //   options: CarouselOptions(
                      //     autoPlay: true,
                      //     aspectRatio: 2.0,
                      //     enlargeCenterPage: true,
                      //   ),
                      //   items: jobs.map(( e) {
                      //     return Container(
                      //       child: Text("${e.nameJob}"),
                      //     ) ;
                      //   }).toList(),
                      // );
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    } else
                      return CircularProgressIndicator();
                  },
                ),
              ),

              //     PageView.builder(
              //   controller: _controller,
              //   // itemCount: jobData.length,
              //   itemBuilder: (context, index) {
              //     return

              //      Row(
              //       children: [
              //         Container(
              //           width: 327.w,
              //           height: 126.h,
              //           decoration: BoxDecoration(
              //             image: DecorationImage(
              //               image: AssetImage(
              //                 'assets/images/jobs/featureBg.png',
              //               ),
              //               fit: BoxFit.fill,
              //             ),
              //             color: Colors.white,
              //             borderRadius: BorderRadius.circular(24.r),
              //           ),
              //           padding: EdgeInsets.symmetric(
              //               vertical: 20.h, horizontal: 24.w),
              //         ),
              //       ],
              //     );
              //   },
              // )
            ]));
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
    return Container(
      // margin: EdgeInsets.only(top: 20.h),
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
                  child: CircleAvatar(
                    child: Image(
                      image: NetworkImage(
                          "${item.users!.imageUrl ?? 'https://png.pngtree.com/png-vector/20190710/ourmid/pngtree-user-vector-avatar-png-image_1541962.jpg'}"),
                      width: 32.w,
                      height: 32.h,
                    ),
                  ),
                ),
                SizedBox(
                  width: 16.5.w,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${item.jobName}",
                      style: textTheme.semibold16(),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      "${item.users!.name}",
                      style: textTheme.medium14(opacity: 0.6, color: "FFFFFF"),
                    ),
                  ],
                ),
                Spacer(),
                Icon(
                  Icons.bookmark_add,
                  color: Colors.white,
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
                  "${item.location}",
                  style: textTheme.medium14(opacity: 0.6, color: "FFFFFF"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
