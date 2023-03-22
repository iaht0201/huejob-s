import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../data/home/featureJobs.dart';
import '../../../utils/constant.dart';

class FeaturedJobs extends StatefulWidget {
  const FeaturedJobs({super.key});

  @override
  State<FeaturedJobs> createState() => _FeaturedJobsState();
}

class _FeaturedJobsState extends State<FeaturedJobs> {
  late PageController _controller;
  void initState() {
    _controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
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
                // width: 327.w,
                // height: 200.h,
                margin: EdgeInsets.only(top:20.h),
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
                  padding:
                      EdgeInsets.symmetric(vertical: 20.h, horizontal: 24.w),
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
                            child: Image(
                              image: AssetImage("assets/images/jobs/job1.png"),
                              width: 32.w,
                              height: 32.h,
                            ),
                          ),
                          SizedBox(
                            width: 16.5.w,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Jr Executive",
                                style: textTheme.semibold16(),
                              ),
                              SizedBox(height: 3.h),
                              Text(
                                "Burger King",
                                style: textTheme.medium14(
                                    opacity: 0.6, color: "FFFFFF"),
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
                          _itemHagTag(context, "Full-Time"),
                          _itemHagTag(context, "Junior")
                        ],
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "\$98,00/year",
                            style: textTheme.medium14(color: "FFFFFF"),
                          ),
                          Text(
                            "Texas, USA",
                            style: textTheme.medium14(
                                opacity: 0.6, color: "FFFFFF"),
                          ),
                        ],
                      ),
                    ],
                  ),
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
}
