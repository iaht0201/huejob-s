import 'package:app_tim_kiem_viec_lam/core/models/job_category_model.dart';
import 'package:app_tim_kiem_viec_lam/core/models/jobs_model.dart';
import 'package:app_tim_kiem_viec_lam/core/models/user_model.dart';
import 'package:app_tim_kiem_viec_lam/core/providers/jobs_provider.dart';
import 'package:app_tim_kiem_viec_lam/core/providers/user_provider.dart';
import 'package:app_tim_kiem_viec_lam/data/home/category_data.dart';
import 'package:app_tim_kiem_viec_lam/screens/detailJob/detail_job.dart';
import 'package:app_tim_kiem_viec_lam/screens/search/widget/searchjob_widget.dart';
import 'package:app_tim_kiem_viec_lam/screens/search/widget/searchuser_widget.dart';

import 'package:app_tim_kiem_viec_lam/utils/constant.dart';
import 'package:app_tim_kiem_viec_lam/widgets/avatar_widget.dart';
import 'package:app_tim_kiem_viec_lam/widgets/item_job_horizal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/models/search_job_model.dart';
import '../../core/providers/post_provider.dart';
import '../../widgets/item_job_widget.dart';
import '../profile/profile_screen.dart';
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
  bool isSearchUser = false;
  bool isSearchJob = false;
  String tempSearch = '';
  late List<JobModel> jobList = [];
  late List<UserModel> userList = [];
  TextEditingController _searchController = TextEditingController();
  List<String> _history = [];
  @override
  void initState() {
    super.initState();
    jobProvider = Provider.of<JobsProvider>(context, listen: false);
    userProvider = Provider.of<UserProvider>(context, listen: false);
    postProvider = Provider.of<PostProvider>(context, listen: false);
    // jobList = jobProvider.li;
    postProvider.getJobCategory(limit: 9).whenComplete(() {
      getHistory().whenComplete(() {
        setState(() {
          isLoad = true;
        });
      });
    });
  }

  Future getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _history = prefs.getStringList("historySearch")!;
    });

    print("session: ${_history}");
  }

  String _input = '';
  List<JobModel> searchResult = [];
  List<UserModel> searchUser = [];
  bool showDelete = false;
  searchJobs(String query) async {
    jobProvider.fetchCategorySearchJob();
    userProvider.fetchCategoryUser();
    setState(() => _input = query);
    List<JobModel> _results = [];
    List<UserModel> _searchUser = [];
    if (query.isEmpty) {
      setState(() {
        isSearchUser = false;
        isSearchJob = false;
      });
      _results = [];
      _searchUser = [];
    } else {
      try {
        setState(() => _isLoading = true);

        _results.addAll(jobProvider.listJobsSearch.where((item) =>
            item.jobName!.toLowerCase().contains(_input.toLowerCase()) ||
            item.users!.email!.toLowerCase().contains(_input.toLowerCase())));

        _searchUser.addAll(userProvider.listUserSearch.where((item) {
          if (item.name != null && item.name!.isNotEmpty) {
            return item.name!.toLowerCase().contains(_input.toLowerCase());
          }
          return false;
        }));

        print(_searchUser);
      } catch (e) {
        print(e);
      }
    }

    setState(() {
      searchResult = _results;
      searchUser = _searchUser;
      _isLoading = false;
    });
  }

  bool _isLoading = false;

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
                                        child: Text("Tìm kiếm",
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
                              child: TextFormField(
                                  controller: _searchController,
                                  autofocus: true,
                                  onChanged: (query) {
                                    searchJobs(query);
                                    if (query.isNotEmpty) {
                                      setState(() {
                                        showDelete = true;
                                      });
                                      if (tempSearch.length != _input.length) {
                                        isSearchUser = false;
                                        isSearchJob = false;
                                      }
                                    } else {
                                      setState(() {
                                        showDelete = false;
                                      });
                                    }
                                  },
                                  decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 20.0.h),
                                    prefixIcon: Image.asset(
                                      "assets/icons/search.png",
                                      width: 20.w,
                                      height: 20.h,
                                    ),
                                    suffix: Padding(
                                      padding: EdgeInsets.only(right: 10.w),
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _searchController.clear();
                                            searchResult.clear();
                                            searchUser.clear();
                                            isSearchUser = false;
                                            isSearchUser = false;
                                          });
                                        },
                                        child: Icon(
                                          Icons.cancel_outlined,
                                          size: 26,
                                          color: HexColor("#BB2649"),
                                        ),
                                      ),
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
                    height: 1.sh - 190.h,
                    child: _isLoading == false
                        ? SingleChildScrollView(
                            child: searchResult.isNotEmpty
                                ? isSearchUser
                                    ? SearchUserWidget(
                                        query: _input,
                                      )
                                    : isSearchJob
                                        ? SearchJobWidget(
                                            query: _input,
                                          )
                                        : Container(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                searchUser.isNotEmpty
                                                    ? Text(
                                                        "Người dùng",
                                                        style: textTheme
                                                            .medium14(),
                                                      )
                                                    : Container(),
                                                ...searchUser
                                                    .map((e) => GestureDetector(
                                                          onTap: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) => ProfileScreen(
                                                                        clientID: userProvider
                                                                            .user
                                                                            .userId)));
                                                          },
                                                          child: Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      top: 10.h,
                                                                      bottom:
                                                                          10.h),
                                                              child: Row(
                                                                children: [
                                                                  AvatarWidget(
                                                                      context,
                                                                      user: e,
                                                                      radius:
                                                                          25.r),
                                                                  SizedBox(
                                                                    width: 10.w,
                                                                  ),
                                                                  Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        "${e.name}",
                                                                        style: textTheme
                                                                            .regular16(),
                                                                      ),
                                                                      e.familyname == null ||
                                                                              e.firstname ==
                                                                                  null
                                                                          ? Container()
                                                                          : Text(
                                                                              " ${e.familyname} ${e.firstname}")
                                                                    ],
                                                                  )
                                                                ],
                                                              )),
                                                        ))
                                                    .take(3)
                                                    .toList(),
                                                SizedBox(
                                                  height: 10.h,
                                                ),
                                                searchUser.isNotEmpty
                                                    ? Center(
                                                        child: GestureDetector(
                                                            onTap: () async {
                                                              final SharedPreferences
                                                                  prefs =
                                                                  await SharedPreferences
                                                                      .getInstance();
                                                              _history
                                                                  .add(_input);
                                                              prefs.setStringList(
                                                                  "historySearch",
                                                                  _history
                                                                      .toSet()
                                                                      .toList());
                                                              setState(() {
                                                                tempSearch =
                                                                    _input;
                                                                isSearchUser =
                                                                    true;
                                                              });

                                                              print(tempSearch);
                                                            },
                                                            child: Text(
                                                                "Xem tất cả kết quả")))
                                                    : Container(),
                                                SizedBox(
                                                  height: 5.h,
                                                ),
                                                searchResult.isNotEmpty
                                                    ? Text("Job",
                                                        style: textTheme
                                                            .medium14())
                                                    : Container(),
                                                ...searchResult
                                                    .map((e) => ItemJobHorizal(
                                                          job: e,
                                                        ))
                                                    .take(5)
                                                    .toList(),
                                                SizedBox(
                                                  height: 10.h,
                                                ),
                                                Center(
                                                  child: GestureDetector(
                                                      onTap: () async {
                                                        final SharedPreferences
                                                            prefs =
                                                            await SharedPreferences
                                                                .getInstance();
                                                        _history.add(_input);
                                                        prefs.setStringList(
                                                            "historySearch",
                                                            _history
                                                                .toSet()
                                                                .toList());
                                                        setState(() {
                                                          tempSearch = _input;
                                                          isSearchJob = true;
                                                        });
                                                        print(tempSearch);
                                                      },
                                                      child: Text(
                                                          "Xem tất cả kết quả")),
                                                )
                                              ],
                                            ),
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
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Lịch sử tìm kiếm",
              style: textTheme.semibold16(color: "000000")),
          ..._history.reversed
              .map((e) {
                return Container(
                    child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        searchJobs(e);
                        setState(() {
                          _searchController.text = e;
                        });
                      },
                      child: Text(
                        "${e}",
                        style: textTheme.medium14(color: "000000"),
                      ),
                    ),
                    Spacer(),
                    TextButton(
                        onPressed: () async {
                          final SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          setState(() {
                            _history.remove(e);
                          });
                          prefs.setStringList("historySearch", _history);
                        },
                        child: Text("Xoá",
                            style:
                                TextStyle(fontSize: 14.h, color: Colors.black)))
                  ],
                ));
              })
              .take(7)
              .toList(),
          // _history.isNotEmpty
          //     ? TextButton(
          //         onPressed: () async {
          //           final SharedPreferences prefs =
          //               await SharedPreferences.getInstance();
          //           setState(() {
          //             _history.clear();
          //           });
          //           prefs.setStringList("historySearch", []);
          //         },
          //         child: Text("Xoá tất cả",
          //             style: TextStyle(fontSize: 14.h, color: Colors.black)))
          //     : Container()
        ],
      ),
    );
  }

  _popualarRoles(conetx, List<JobCategoryModel> roles) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Các chủ đề được quan tâm",
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
                              setState(() {
                                isSearchJob = true;
                                _input = e.jobName.toString();
                                _searchController.text = e.jobName.toString();
                                searchJobs(e.toString());
                              });
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
            "Đã xem",
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
  double get minExtent => 160.0.h;

  @override
  double get maxExtent => 160.0.h;

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
