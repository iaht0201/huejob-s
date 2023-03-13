import 'dart:async';

import 'package:app_tim_kiem_viec_lam/core/models/model.dart';
import 'package:app_tim_kiem_viec_lam/core/models/user_model.dart';

import 'package:app_tim_kiem_viec_lam/core/providers/userProvider.dart';
import 'package:app_tim_kiem_viec_lam/screens/addPost/addPost_Screen.dart';

import 'package:app_tim_kiem_viec_lam/screens/authentication/login/login.dart';
import 'package:app_tim_kiem_viec_lam/screens/home/widgets/tag_list.dart';
import 'package:app_tim_kiem_viec_lam/screens/home/widgets/home_app_bar.dart';
import 'package:app_tim_kiem_viec_lam/screens/home/widgets/job_hot.dart';
import 'package:app_tim_kiem_viec_lam/screens/profile/profile_screen.dart';
import 'package:app_tim_kiem_viec_lam/screens/profile/profile_setting.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import '../../core/providers/authenciation_provider.dart';
import '../../core/providers/job_provider.dart';
import '../profile/widgets/button_arrow.dart';
import 'widgets/post_widgets/post_feed_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int pageIndex = 0;
  int currentTab = 0;
  final List screens = [
    HomePage(),
    ProfileScreen(),
    // BookMark Screen
    // Noti
    ProfileSettingScreen(),
    LoginView(),
  ];
  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = _ContentHome();
  late JobProvider jobProvider;
  late UserModel user;
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(bucket: bucket, child: currentScreen),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: HexColor("#BB2649"),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddPostScreen()));
        },
        elevation: 0,
        child: Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 10,
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                flex: 6,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    MaterialButton(
                      minWidth: 40,
                      onPressed: () {
                        setState(() {
                          currentScreen = _ContentHome();
                          currentTab = 0;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.dashboard,
                            color: currentTab == 0
                                ? HexColor("#BB2649")
                                : Colors.grey,
                          ),
                          Text(
                            'Trang chủ',
                            style: TextStyle(
                              color: currentTab == 0
                                  ? HexColor("#BB2649")
                                  : Colors.grey,
                            ),
                          )
                        ],
                      ),
                    ),
                    MaterialButton(
                      minWidth: 40,
                      onPressed: () {
                        setState(() {
                          currentScreen = ProfileSettingScreen();
                          currentTab = 1;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.people_outlined,
                            color: currentTab == 1
                                ? HexColor("#BB2649")
                                : Colors.grey,
                          ),
                          Text(
                            'Hồ sơ',
                            style: TextStyle(
                              color: currentTab == 1
                                  ? HexColor("#BB2649")
                                  : Colors.grey,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Container(),
                flex: 1,
              ),
              Expanded(
                flex: 6,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    MaterialButton(
                      minWidth: 40,
                      onPressed: () {
                        setState(() {
                          currentScreen = HomePage();
                          currentTab = 3;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.bookmark_sharp,
                            color: currentTab == 3
                                ? HexColor("#BB2649")
                                : Colors.grey,
                          ),
                          Text(
                            'Bookmark',
                            style: TextStyle(
                              color: currentTab == 3
                                  ? HexColor("#BB2649")
                                  : Colors.grey,
                            ),
                          )
                        ],
                      ),
                    ),
                    MaterialButton(
                      minWidth: 40,
                      onPressed: () {
                        setState(() {
                          currentScreen = ProfileSettingScreen();
                          currentTab = 4;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.people_outlined,
                            color: currentTab == 4
                                ? HexColor("#BB2649")
                                : Colors.grey,
                          ),
                          Text(
                            'Hồ sơ',
                            style: TextStyle(
                              color: currentTab == 4
                                  ? HexColor("#BB2649")
                                  : Colors.grey,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContentHome extends StatefulWidget {
  const _ContentHome({super.key});

  @override
  State<_ContentHome> createState() => __ContentHomeState();
}

class __ContentHomeState extends State<_ContentHome> {
  late UserProvider userProvider;
  late UserModel user;
  late JobProvider jobProvider;
  List<PostModel> posts = [];
  int _page = 1;
  int _pageSize = 2;
  bool _isLoading = false;
  ScrollController _scrollController = ScrollController();
  void initState() {
    jobProvider = Provider.of<JobProvider>(context, listen: false);
    userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.fetchUser();

    jobProvider.getPots();
    // _loadPosts();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  void _scrollListener() {
    final double maxScroll = _scrollController.position.maxScrollExtent;
    final double currentScroll = _scrollController.position.pixels;
    final double delta = MediaQuery.of(context).size.height * 0.20;
    if (maxScroll - currentScroll <= delta) {
      _loadPosts();
    }
  }
  // void _scrollListener() {
  //   if (!_isLoading &&
  //       _scrollController.position.pixels ==
  //           _scrollController.position.maxScrollExtent) {
  //     _loadPosts();
  //   }
  // }

  void _loadPosts() async {
    setState(() {
      _isLoading = true;
    });
    // Load additional posts
    List<PostModel> newPosts =
        await jobProvider.fetchPostMore(_page, _pageSize);
    setState(() {
      posts.addAll(newPosts);
      _isLoading = false;
      _page++;
    });
  }

  void _loadMorePosts() async {
    if (_isLoading) return;
    _isLoading = true;
    await jobProvider.fetchPostMore(_page, _pageSize);
    _pageSize++;
    _isLoading = false;
  }

  double top = 0.0;
  double _opacity = 0;
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthenciationNotifier>(context);
    final providerJob = Provider.of<JobProvider>(context);
    return Scaffold(
      body: Stack(children: [
        CustomScrollView(
          slivers: [
            Consumer<UserProvider>(builder: (context, userProvider, _) {
              return SliverAppBar(
                  automaticallyImplyLeading: false,
                  shape: ContinuousRectangleBorder(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(100),
                          bottomRight: Radius.circular(100))),
                  backgroundColor: HexColor("#BB2649"),
                  pinned: true,
                  expandedHeight: 120,
                  flexibleSpace: LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      top = constraints.biggest.height;
                      if (top.toDouble() < 100) {
                        _opacity = 1;
                      } else {
                        _opacity = 0;
                      }
                      return FlexibleSpaceBar(
                          expandedTitleScale: 1,
                          collapseMode: CollapseMode.pin,
                          background: HomeAppBar(
                              user: userProvider.user, isScroll: false),
                          titlePadding: EdgeInsets.only(
                            left: 0,
                            right: 0,
                          ),
                          title: Container(
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  AnimatedOpacity(
                                      duration: Duration(milliseconds: 0),
                                      //opacity: top == MediaQuery.of(context).padding.top + kToolbarHeight ? 1.0 : 0.0,
                                      opacity: _opacity,
                                      child: HomeAppBar(
                                          user: userProvider.user,
                                          isScroll: true)),
                                ]),
                          ));
                    },
                  ));
            }),
            // SliverPersistentHeader(
            //     pinned: true,
            //     floating: false,
            //     delegate: _MyHeader(
            //       child: Consumer<UserProvider>(
            //           builder: (context, userProvider, _) {
            //         return HomeAppBar(user: userProvider.user);
            //       }),
            //       // Padding(
            //       //   padding: EdgeInsets.symmetric(horizontal: 20),
            //       //   child: Column(children: [
            //       //     Row(
            //       //         mainAxisAlignment: MainAxisAlignment.start,
            //       //         children: [
            //       //           Row(
            //       //             children: [
            //       //               buttonArrow(context),
            //       //               Text(
            //       //                 "Đối tượng ngành nghề",
            //       //                 style: Theme.of(context)
            //       //                     .textTheme
            //       //                     .titleLarge!
            //       //                     .copyWith(color: Colors.white),
            //       //               ),
            //       //             ],
            //       //           ),
            //       //         ]),
            //       //     Container(
            //       //       child: TextField(
            //       //           // onChanged: (query) => searchJobs(query),
            //       //           decoration: InputDecoration(
            //       //         contentPadding: EdgeInsets.symmetric(vertical: 20.0),
            //       //         prefixIcon: const Icon(
            //       //           Icons.search_rounded,
            //       //           size: 35,
            //       //           color: Colors.black,
            //       //         ),
            //       //         focusedBorder: OutlineInputBorder(
            //       //             borderSide:
            //       //                 BorderSide(color: HexColor("#F0F2F1")),
            //       //             borderRadius: BorderRadius.circular(20)),
            //       //         enabledBorder: OutlineInputBorder(
            //       //             borderSide:
            //       //                 BorderSide(color: HexColor("#F0F2F1")),
            //       //             borderRadius: BorderRadius.circular(20)),
            //       //         hintText: 'Bạn đang tìm ngành nghề nào?',
            //       //         filled: true,
            //       //         fillColor: Colors.white,
            //       //       )),
            //       //     ),
            //       //   ]),
            //       // ),
            //     )),
            SliverList(
                delegate: SliverChildListDelegate([
              Container(
                // height: MediaQuery.of(context).size.height * 0.755,
                // padding:
                //     const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  color: Colors.white,
                  // borderRadius: BorderRadius.only(
                  //     topLeft: Radius.circular(20),
                  //     topRight: Radius.circular(20))
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: TextField(
                            decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 20.0),
                          prefixIcon: const Icon(
                            Icons.search_rounded,
                            size: 35,
                            color: Colors.black,
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: HexColor("#F0F2F1")),
                              borderRadius: BorderRadius.circular(20)),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: HexColor("#F0F2F1")),
                              borderRadius: BorderRadius.circular(20)),
                          hintText: 'Bạn đang tìm kiếm loại công việc nào ?',
                        )),
                      ),
                      JobHot(),
                      TagList(),
                      Consumer<JobProvider>(
                        builder: (context, postProvider, _) {
                          return
                              // Container(
                              //   height: 1000,
                              //   child: ListView.builder(
                              //     itemCount: providerJob.posts.length,
                              //     itemBuilder: (context, index) {
                              //       return PostItem(post: jobProvider.posts[index]);
                              //     },
                              //   ),
                              // );
                              Container(
                            child: Column(
                              children: [
                                ...jobProvider.posts.map((e) {
                                  return PostItem(post: e);
                                }).toList(),
                                _isLoading
                                    ? CircularProgressIndicator()
                                    : SizedBox.shrink(),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ]))
          ],
        ),
      ]),
    );

    // SingleChildScrollView(child: LayoutBuilder(
    //   builder: (BuildContext context, BoxConstraints constraints) {
    //     return Column(
    //       mainAxisAlignment: MainAxisAlignment.start,
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         Consumer<UserProvider>(builder: (context, userProvider, _) {
    //           return HomeAppBar(user: userProvider.user);
    //         }),

    //         SizedBox(
    //           height: 20,
    //         ),
    //         Container(
    //           padding: EdgeInsets.symmetric(horizontal: 20),
    //           child: TextField(
    //               decoration: InputDecoration(
    //             contentPadding: EdgeInsets.symmetric(vertical: 20.0),
    //             prefixIcon: const Icon(
    //               Icons.search_rounded,
    //               size: 35,
    //               color: Colors.black,
    //             ),
    //             focusedBorder: OutlineInputBorder(
    //                 borderSide: BorderSide(color: HexColor("#F0F2F1")),
    //                 borderRadius: BorderRadius.circular(20)),
    //             enabledBorder: OutlineInputBorder(
    //                 borderSide: BorderSide(color: HexColor("#F0F2F1")),
    //                 borderRadius: BorderRadius.circular(20)),
    //             hintText: 'Bạn đang tìm kiếm loại công việc nào ?',
    //           )),
    //         ),
    //         // CategorList(),
    //         JobHot(),
    //         TagList(),
    //         Consumer<JobProvider>(
    //           builder: (context, postProvider, _) {
    //             return
    //                 // Container(
    //                 //   height: 1000,
    //                 //   child: ListView.builder(
    //                 //     itemCount: providerJob.posts.length,
    //                 //     itemBuilder: (context, index) {
    //                 //       return PostItem(post: jobProvider.posts[index]);
    //                 //     },
    //                 //   ),
    //                 // );
    //                 Container(
    //               child: Column(
    //                 children: [
    //                   ...posts.map((e) {
    //                     return PostItem(post: e);
    //                   }).toList(),
    //                   _isLoading
    //                       ? CircularProgressIndicator()
    //                       : SizedBox.shrink(),
    //                 ],
    //               ),
    //             );
    //           },
    //         ),
    //         // FutureBuilder(
    //         //   future: providerJob.getPots(),
    //         //   builder: (context, snapshot) {
    //         //     if (snapshot.hasData) {
    //         //       return Container(
    //         //         child: Column(
    //         //           children: [
    //         //             ...providerJob.posts.map((e) {
    //         //               return PostItem(post: e);
    //         //             })
    //         //           ],
    //         //         ),
    //         //       );
    //         //     } else if (snapshot.hasError) {
    //         //       return Text("Error: ${snapshot.error}");
    //         //     } else {
    //         //       return Container();
    //         //     }
    //         //   },
    //         // ),
    //       ],
    //     );
    //   },
    // ));
  }
}

class _MyHeader extends SliverPersistentHeaderDelegate {
  _MyHeader({required this.child});

  final Widget child;

  @override
  double get minExtent => 130.0;

  @override
  double get maxExtent => 130.0;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      decoration: BoxDecoration(
          // color: Colors.transparent
          color: HexColor("#BB2649").withOpacity(1),
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(0), bottomRight: Radius.circular(0))),
      child: child,
    );
  }

  @override
  bool shouldRebuild(_MyHeader oldDelegate) {
    return false;
  }
}
