import 'dart:async';

import 'package:app_tim_kiem_viec_lam/core/models/model.dart';
import 'package:app_tim_kiem_viec_lam/core/models/user_model.dart';

import 'package:app_tim_kiem_viec_lam/core/providers/user_provider.dart';
import 'package:app_tim_kiem_viec_lam/screens/addPost/addPost_Screen.dart';
import 'package:app_tim_kiem_viec_lam/screens/add_job/add_job.dart';

import 'package:app_tim_kiem_viec_lam/screens/authentication/login/login.dart';
import 'package:app_tim_kiem_viec_lam/screens/chat/chatMessages.dart';
import 'package:app_tim_kiem_viec_lam/screens/chat/listChatScreen.dart';
import 'package:app_tim_kiem_viec_lam/screens/home/widgets/featured_jobs.dart';
import 'package:app_tim_kiem_viec_lam/screens/home/widgets/other_job.dart';
import 'package:app_tim_kiem_viec_lam/screens/home/widgets/recommend_jobs.dart';
import 'package:app_tim_kiem_viec_lam/screens/home/widgets/tag_list.dart';
import 'package:app_tim_kiem_viec_lam/screens/home/widgets/home_app_bar.dart';
import 'package:app_tim_kiem_viec_lam/screens/home/widgets/job_hot.dart';
import 'package:app_tim_kiem_viec_lam/screens/profile/profile_screen.dart';
import 'package:app_tim_kiem_viec_lam/screens/profile/profile_setting.dart';
import 'package:app_tim_kiem_viec_lam/screens/search/searchh_screen.dart';
import 'package:app_tim_kiem_viec_lam/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import '../../core/providers/authenciation_provider.dart';
import '../../core/providers/post_provider.dart';
import '../../widgets/avatar_widget.dart';
import '../profile/widgets/button_arrow.dart';
import '../social/social_screen.dart';
import 'widgets/post_widgets/post_feed_widget.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key, this.currentTab = 0});
  final int currentTab;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
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
  // Widget currentScreen = _ContentHome();
  late PostProvider jobProvider;
  late UserModel user;
  Widget currentScreen = _ContentHome();
  void initState() {
    super.initState();
    currentTab = widget.currentTab;
    if (currentTab == 1) {
      currentScreen = SocialScreen();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  @override
  Future<void> _dialogSelectAdd(BuildContext context, UserModel user) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Lựa chọn hình thức"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              user.usertype == "Nhà tuyển dụng"
                  ? GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddJobScreen(
                                      user: user,
                                    )));
                      },
                      child: Container(
                          child: Row(
                        children: [
                          Image.asset(
                            "assets/icons/job_add.png",
                            width: 30.w,
                            height: 30.w,
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Text(
                            "Đăng tuyển dụng",
                            style: textTheme.medium16(),
                          )
                        ],
                      )))
                  : Container(),
              SizedBox(
                height: 10.h,
              ),
              GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddPostScreen()));
                  },
                  child: Container(
                      child: Row(
                    children: [
                      Image.asset(
                        "assets/icons/social-media.png",
                        width: 30.w,
                        height: 30.w,
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Text("Đăng bài viết", style: textTheme.medium16())
                    ],
                  )))
            ],
          ),
        );
      },
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      endDrawer: Drawer(
        child: _drawerCustom(context),
      ),
      body: PageStorage(bucket: bucket, child: currentScreen),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          return FloatingActionButton(
            backgroundColor: HexColor("#BB2649"),
            onPressed: () {
              _dialogSelectAdd(context, userProvider.user);
            },
            elevation: 0,
            child: Icon(Icons.add, color: Colors.white),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 10,
        child: Container(
          height: 60.h,
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
                      minWidth: 30.w,
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
                            Icons.home_filled,
                            size: 20,
                            color: currentTab == 0
                                ? HexColor("#BB2649")
                                : Colors.grey,
                          ),
                          Text(
                            'Trang chủ',
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: currentTab == 0
                                  ? HexColor("#BB2649")
                                  : Colors.grey,
                            ),
                          )
                        ],
                      ),
                    ),
                    MaterialButton(
                      minWidth: 30.w,
                      onPressed: () {
                        setState(() {
                          currentScreen = SocialScreen();
                          currentTab = 1;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.change_circle_outlined,
                            size: 20,
                            color: currentTab == 1
                                ? HexColor("#BB2649")
                                : Colors.grey,
                          ),
                          Text(
                            'Tương tác',
                            style: TextStyle(
                              fontSize: 10.sp,
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
                      minWidth: 30.w,
                      onPressed: () {
                        setState(() {
                          currentScreen = ListChatScreen();
                          currentTab = 2;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.message_outlined,
                            size: 20,
                            color: currentTab == 2
                                ? HexColor("#BB2649")
                                : Colors.grey,
                          ),
                          Text(
                            'Nhắn tin',
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: currentTab == 2
                                  ? HexColor("#BB2649")
                                  : Colors.grey,
                            ),
                          )
                        ],
                      ),
                    ),
                    MaterialButton(
                      minWidth: 30.w,
                      onPressed: () {
                        _globalKey.currentState?.openEndDrawer();
                        // setState(() {
                        //   currentScreen = SocialScreen();
                        //   currentTab = 4;
                        // });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.menu,
                            size: 20,
                            color: currentTab == 3
                                ? HexColor("#BB2649")
                                : Colors.grey,
                          ),
                          Text(
                            'Lựa chọn',
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: currentTab == 3
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

  _drawerCustom(BuildContext context) {
    final _supabaseClient = AuthenciationNotifier();
    return SafeArea(
      child: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          return Container(
            color: HexColor("#FFFFFF"),
            width: 311.w, height: 812.h,
            // margin: EdgeInsets.only(left: 41.w),
            child: ListView(children: [
              Container(
                margin: EdgeInsets.only(top: 20.h),
                child: Stack(
                  children: [
                    Container(
                      // chua check hinh anh
                      child: Center(
                        child: Column(
                          children: [
                            AvatarWidget(context,
                                user: userProvider.user, radius: 45),
                            SizedBox(
                              height: 12.h,
                            ),
                            Text(
                              '${userProvider.user.fullname ?? userProvider.user.name}',
                              style: textTheme.semibold20(),
                            ),
                            SizedBox(
                              height: 4.h,
                            ),
                            Text(
                              "${userProvider.user.usertype}",
                              style: textTheme.regular11(color: "95969D"),
                            ),
                            SizedBox(
                              height: 6.h,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProfileScreen()));
                              },
                              child: Text(
                                "View Profile",
                                style: textTheme.medium14(),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 20.w,
                      child: GestureDetector(
                          onTap: () {
                            _globalKey.currentState?.closeEndDrawer();
                          },
                          child: Icon(Icons.close)),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 30.h,
              ),
              Container(
                margin: EdgeInsets.only(left: 20.w),
                child: Column(children: [
                  ListTile(
                    title: _itemDrawer(
                        context, Icons.info_outline, "Personal Info"),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title:
                        _itemDrawer(context, Icons.notifications, "Thông báo"),
                    onTap: () {},
                  ),
                  ListTile(
                    title: _itemDrawer(context, Icons.bookmark, "Đã lưu"),
                    onTap: () {},
                  ),
                  ListTile(
                    title: _itemDrawer(context, Icons.settings, "Cài đặt"),
                    onTap: () {},
                  ),
                  ListTile(
                    title: _itemDrawer(context, Icons.help_outline, "Trợ giúp"),
                    onTap: () {},
                  ),
                  ListTile(
                    title: _itemDrawer(context, Icons.logout, "Đăng xuất"),
                    onTap: () {
                      _supabaseClient.SignOut(context);
                    },
                  ),
                ]),
              )
            ]),
          );
        },
      ),
    );
  }

  _itemDrawer(
    BuildContext context,
    IconData icon,
    String title,
  ) {
    return Row(
      children: [
        Icon(icon),
        SizedBox(
          width: 16.w,
        ),
        Text('$title')
      ],
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
  late PostProvider jobProvider;
  List<PostModel> posts = [];
  int _page = 1;
  int _pageSize = 2;
  bool _isLoading = false;
  final ScrollController _scrollController = ScrollController();
  void initState() {
    jobProvider = Provider.of<PostProvider>(context, listen: false);
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
                  expandedHeight: 120.h,
                  flexibleSpace: LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      top = constraints.biggest.height;
                      if (top.toDouble() < 100.h) {
                        _opacity = 1;
                      } else {
                        _opacity = 0;
                      }
                      return FlexibleSpaceBar(
                          expandedTitleScale: 1,
                          collapseMode: CollapseMode.pin,
                          background: HomeAppBar(
                            user: userProvider.user,
                            isScroll: false,
                          ),
                          titlePadding: EdgeInsets.only(
                            left: 0.w,
                            right: 0.w,
                          ),
                          title: Container(
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  AnimatedOpacity(
                                      duration: Duration(milliseconds: 0),
                                      opacity: _opacity,
                                      child: HomeAppBar(
                                          user: userProvider.user,
                                          isScroll: true)),
                                ]),
                          ));
                    },
                  ));
            }),
            SliverList(
                delegate: SliverChildListDelegate([
              Container(
                // height: MediaQuery.of(context).size.height * 0.755,
                // padding:
                //     const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  color: HexColor("#FAFAFD"),
                  // borderRadius: BorderRadius.only(
                  //     topLeft: Radius.circular(20),
                  //     topRight: Radius.circular(20))
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 25,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        width: 1.sw,
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SearchScreen()));
                              },
                              child: Container(
                                width: 250.w,
                                height: 55.h,
                                decoration: BoxDecoration(
                                    color: HexColor("#F2F2F3"),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12))),
                                padding: EdgeInsets.symmetric(
                                    vertical: 13.h, horizontal: 24.w),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      "assets/icons/search.png",
                                      width: 20.w,
                                      height: 20.h,
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    Text(
                                      "Tìm kiếm công việc ",
                                      style: TextStyle(
                                          color: HexColor("#95969D"),
                                          fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),
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
                      Consumer<UserProvider>(
                        builder: (context, userProvider, child) {
                          return Column(
                            children: [
                              FeaturedJobs(),
                              RecommendJobs(user: userProvider.user),
                              OtherJobs(),
                            ],
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
            ]))
          ],
        ),
      ]),
    );
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
