import 'package:app_tim_kiem_viec_lam/core/models/model.dart';
import 'package:app_tim_kiem_viec_lam/core/models/user_model.dart';

import 'package:app_tim_kiem_viec_lam/core/providers/user_provider.dart';
import 'package:app_tim_kiem_viec_lam/screens/home/widgets/post_widgets/post_feed_widget.dart';

import 'package:app_tim_kiem_viec_lam/screens/profile/widgets/button_arrow.dart';
import 'package:app_tim_kiem_viec_lam/screens/profile/widgets/profile_information.dart';
import 'package:app_tim_kiem_viec_lam/screens/profile/widgets/profile_detail_information.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';

import 'package:provider/provider.dart';

import '../../core/providers/authenciation_provider.dart';
import '../../core/providers/post_provider.dart';
import '../../utils/constant.dart';
import '../home/widgets/other_job.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, this.clientID});
  final String? clientID;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late List<PostModel> posts;
  bool _isLoading = false;
  String? _imageUrl;

  void updateImageUrl(String url) {
    setState(() {
      _imageUrl = url;

      print(_imageUrl);
    });
  }

  late PostProvider jobProvider;
  late UserProvider userProvider;

  @override
  void initState() {
    super.initState();
    jobProvider = Provider.of<PostProvider>(context, listen: false);
    userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.fetchUserByID(widget.clientID.toString()).whenComplete(
      () {
        jobProvider.getPotsById(widget.clientID.toString()).whenComplete(() {
          setState(() {
            _isLoading = true;
          });
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
                pinned: true,
                floating: true,
                delegate: _MyHeader(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: buttonArrow(context),
                    ),
                    Expanded(
                        flex: 10,
                        child: Consumer<UserProvider>(
                          builder: (context, userProvider, _) {
                            final UserModel user = widget.clientID == null
                                ? userProvider.user
                                : userProvider.userByID;
                            return Center(
                                child: user.name != null
                                    ? Text(
                                        "@${user.name}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(color: Colors.black),
                                      )
                                    : shimmerFromColor(
                                        width: 80.w, height: 20.h));
                          },
                        )),
                    Expanded(
                      flex: 2,
                      child: Container(),
                    ),
                  ],
                ))),
            SliverList(
                delegate: SliverChildListDelegate([
              Column(
                children: [
                  Consumer<UserProvider>(
                    builder: (context, userProvider, _) {
                      return _isLoading == true
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                widget.clientID == null ||
                                        widget.clientID ==
                                            userProvider.user.userId
                                    ? ProfileInformation(
                                        user: userProvider.user,
                                        onImageUrlChanged: updateImageUrl)
                                    : ProfileInformation(
                                        clientID: widget.clientID,
                                        user: userProvider.user,
                                        onImageUrlChanged: updateImageUrl),
                                ProfileDetailInformation(
                                    isClient: widget.clientID ==
                                            userProvider.user.userId
                                        ? false
                                        : true,
                                    user: widget.clientID == null
                                        ? userProvider.user
                                        : userProvider.userByID),
                                OtherJobs(),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 20.w),
                                  child: Text(
                                    "Bài viết",
                                    style: textTheme.sub16(),
                                  ),
                                ),
                                Consumer<PostProvider>(
                                  builder: (context, postProvider, _) {
                                    posts = postProvider.postById;
                                    return Container(
                                      child: Column(
                                        children: [
                                          ...posts.map((e) {
                                            return PostItem(post: e);
                                          })
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            )
                          : SizedBox(
                              height: 400.h,
                              child: Column(
                                children: [
                                  Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 22.w),
                                    height: 360.h,
                                    child: Stack(children: [
                                      Container(
                                        height: 200.h,
                                        child: shimmerFromColor(
                                            width: 1.sw, height: 200.h),
                                      ),
                                      Positioned(
                                          top: 150.h,
                                          right: 18.w,
                                          child:
                                              shimmerAvatarColor(radius: 55)),
                                      Positioned(
                                          top: 200.h,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              shimmerFromColor(
                                                  width: 200.w, height: 30.h),
                                              shimmerFromColor(
                                                  width: 200.w, height: 30.h),
                                              shimmerFromColor(
                                                  width: 0.8.sw, height: 50.h)
                                            ],
                                          ))
                                    ]),
                                  ),
                                ],
                              ),
                            );
                    },
                  ),

                  // Consumer<PostProvider>(
                  //   builder: (context, postProvider, _) {
                  //     posts = postProvider.postById;
                  //     return Container(
                  //       child: Column(
                  //         children: [
                  //           ...posts.map((e) {
                  //             return PostItem(post: e);
                  //           })
                  //         ],
                  //       ),
                  //     );
                  //   },
                  // ),
                  // FutureBuilder(
                  //   future: providerJob
                  //       .getPotsById(userProvider.user.userId.toString()),
                  //   builder: (context, snapshot) {
                  //     if (snapshot.hasData) {
                  //       posts = snapshot.data;

                  //       return Column(
                  //         children: [
                  //           ...posts.map((post) {
                  //             return PostItem(post: post);
                  //           }).toList()
                  //         ],
                  //       );
                  //     } else if (snapshot.hasError) {
                  //       return Text("Error: ${snapshot.error}");
                  //     } else {
                  //       return Container();
                  //     }
                  //   },
                  // )
                ],
              )
            ]))
          ],
        ));
  }

  _tabViewDetail(
    BuildContext context,
  ) {
    return Container(
      width: 1.sw,
      child: DefaultTabController(
        length: 3,
        child: Column(children: [
          TabBar(
              unselectedLabelColor: Colors.grey,
              indicatorColor: HexColor("#BB2649"),
              tabs: [
                Tab(
                  child: Text(
                    "Job",
                    style: textTheme.medium14(),
                  ),
                ),
                Tab(
                  child: Text(
                    "Bài viết",
                    style: textTheme.medium14(),
                  ),
                ),
                Tab(
                  child: Text(
                    "Hình ảnh",
                    style: textTheme.medium14(),
                  ),
                ),
              ]),
          Container(
            margin: EdgeInsets.only(left: 24.w, right: 24.w, top: 20.h),
            // color: Color(0xFFF44336),
            height: 500.h,
            child: TabBarView(
              children: [
                Container(),
                SingleChildScrollView(
                  child: Consumer<PostProvider>(
                    builder: (context, postProvider, _) {
                      posts = postProvider.postById;
                      return Container(
                        child: Column(
                          children: [
                            ...posts.map((e) {
                              return PostItem(post: e);
                            })
                          ],
                        ),
                      );
                    },
                  ),
                ),
                // _tabBarView('${job.description}'),
                // _tabBarView('${job.requirement ?? ""}'),
                // _tabLocation(
                //     job.latitude!.toDouble(), job.longitude!.toDouble()),
                // _tabBarView('${job.location}'),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

class _MyHeader extends SliverPersistentHeaderDelegate {
  _MyHeader({required this.child});

  final Widget child;

  @override
  double get minExtent => 70.0;

  @override
  double get maxExtent => 70.0;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      padding: EdgeInsets.only(top: 12.h),
      color: Colors.white,
      child: child,
    );
  }

  @override
  bool shouldRebuild(_MyHeader oldDelegate) {
    return false;
  }
}
