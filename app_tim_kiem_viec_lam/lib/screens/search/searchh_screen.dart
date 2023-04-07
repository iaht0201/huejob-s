import 'package:app_tim_kiem_viec_lam/core/models/job_category_model.dart';
import 'package:app_tim_kiem_viec_lam/core/models/jobs_model.dart';
import 'package:app_tim_kiem_viec_lam/core/providers/jobs_provider.dart';
import 'package:app_tim_kiem_viec_lam/data/home/category_data.dart';
import 'package:app_tim_kiem_viec_lam/utils/constant.dart';
import 'package:app_tim_kiem_viec_lam/widgets/item_job_horizal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../../core/models/search_job_model.dart';
import '../../core/providers/post_provider.dart';
import '../../widgets/item_job_widget.dart';
import '../profile/widgets/button_arrow.dart';
import '../see_more_screen/see_all_scree.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final ScrollController _scrollController = ScrollController();
  late final JobsProvider jobProvider;
  late final PostProvider postProvider;
  bool isLoad = false;
  @override
  void initState() {
    super.initState();
    jobProvider = Provider.of<JobsProvider>(context, listen: false);
    postProvider = Provider.of<PostProvider>(context, listen: false);
    postProvider.getJobCategory(limit: 9).whenComplete(() {
      setState(() {
        isLoad = true;
      });
    });
  }

  // List<SearchJobModel>? _results;
  bool _isLoading = false;
  List<JobModel> _results = [];
  String _input = '';
  _onSearchFieldChanged(String value) async {
    setState(() => _input = value);

    if (value.isEmpty) {
      setState(() => _results = []);
    } else {
      try {
        setState(() => _isLoading = true);
        // final results = await jobProvider.searchJob(_input);
        final results = await jobProvider.search(_input);
        setState(() {
          _results = results;
          if (value.isEmpty) {
            _results = [];
          }
          _isLoading = false;
        });
      } catch (e) {
        print(e);
      }
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("#FAFAFD"),
      body: SafeArea(
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverPersistentHeader(
                  pinned: true,
                  floating: false,
                  delegate: _MyHeader(
                    child: Column(children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: 1.sw,
                              child: Row(
                                children: [
                                  Expanded(
                                      child: _buttonArrow(context), flex: 3),
                                  Expanded(
                                      child: Center(
                                        child: Text("Search",
                                            style: textTheme.semibold16(
                                                color: "0D0D26")),
                                      ),
                                      flex: 6),
                                  Expanded(child: Container(), flex: 3),
                                ],
                              ),
                            ),
                          ]),
                      SizedBox(
                        height: 30.h,
                      ),
                      Container(
                        width: 1.sw,
                        alignment: Alignment.center,
                        margin: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Row(
                          children: [
                            Container(
                              width: 250.w,
                              height: 55.h,
                              decoration: BoxDecoration(
                                  color: HexColor("#F2F2F3"),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12.r))),
                              child: TextField(
                                  autofocus: true,
                                  onChanged: (query) =>
                                      _onSearchFieldChanged(query),
                                  decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 20.0.h),
                                    prefixIcon: const Icon(
                                      Icons.search_rounded,
                                      size: 35,
                                      color: Colors.black,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: HexColor("#F0F2F1")),
                                        borderRadius:
                                            BorderRadius.circular(12.r)),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: HexColor("#F0F2F1")),
                                        borderRadius:
                                            BorderRadius.circular(12.r)),
                                    // hintText: 'Bạn đang tìm ngành nghề nào?',
                                    // hintStyle: textTheme.regular13(),
                                    filled: true,
                                    fillColor: Colors.white,
                                  )),
                            ),
                            SizedBox(
                              width: 12.w,
                            ),
                            Container(
                                width: 55.w,
                                height: 55.h,
                                decoration: BoxDecoration(
                                    color: HexColor("#F2F2F3"),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12))),
                                padding: EdgeInsets.all(11),
                                child: Image.asset(
                                  "assets/icons/filter.png",
                                  width: 26.w,
                                  height: 26.h,
                                )),
                          ],
                        ),
                      ),
                    ]),
                  ),
                ),
                SliverList(
                    delegate: SliverChildListDelegate([
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 24.w),
                    height: 1.sh - 180.h,
                    // color: HexColor("##E5E5E5"),
                    child: _isLoading == false
                        ? SingleChildScrollView(
                            child: _results.isNotEmpty
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ..._results.map((jobs) {
                                        return ItemJobHorizal(job: jobs);
                                      }).toList()
                                    ],
                                  )
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _recentSearches(context),
                                      // Chinh sua lai chuc nang goi y tim kiem
                                      _popualarRoles(
                                          context, postProvider.jobs),
                                      _recentlyViewed(context),
                                      // Chuc nang da xem
                                    ],
                                  ),
                          )
                        : Container(
                            child: Column(
                              children: [
                                ...List.generate(
                                    10,
                                    (index) => shimmerFromColor(
                                        width: 1.sw, height: 50.h))
                              ],
                            ),
                          ),
                  )
                ])),
              ],
            )
          ],
        ),
      ),
    );
  }

  _buttonArrow(BuildContext conext) {
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
              clipBehavior: Clip.hardEdge,
              height: 25,
              width: 25,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(25.r)),
              child: Icon(
                Icons.close,
                size: 25,
                color: HexColor("0D0D26"),
              )),
        ));
  }

  _recentSearches(BuildContext context) {
    return Container();
  }

  _popualarRoles(conetx, List<JobCategoryModel> roles) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Popular Roles",
            style: textTheme.semibold16(color: "000000"),
          ),
          SizedBox(
            height: 24.h,
          ),
          isLoad == true
              ? Container(
                  width: 1.sw,
                  child: Wrap(
                    spacing: 10.w,
                    children: [
                      ...roles.map((e) => GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SeeAllScreen(
                                          styleJob: "${e.jobName}")));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.w, horizontal: 10.w),
                              margin: EdgeInsets.only(bottom: 10.h),
                              child: Text("${e.jobName}"),
                            ),
                          ))
                    ],
                  ))
              : Container(
                  width: 1.sw,
                  child: Wrap(spacing: 10.w, children: [
                    ...List.generate(9,
                        (index) => shimmerFromColor(width: 90.w, height: 30.h))
                  ]))
        ],
      ),
    );
  }

  _recentlyViewed(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(
            "Recently Viewed",
            style: textTheme.semibold16(color: "000000"),
          ),
        ],
      ),
    );
  }
}

class _MyHeader extends SliverPersistentHeaderDelegate {
  _MyHeader({required this.child});

  final Widget child;

  @override
  double get minExtent => 180.0.h;

  @override
  double get maxExtent => 180.0.h;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: HexColor("#FAFAFD").withOpacity(1),
      child: child,
    );
  }

  @override
  bool shouldRebuild(_MyHeader oldDelegate) {
    return false;
  }
}
