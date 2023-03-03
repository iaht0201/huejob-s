import 'dart:async';

import 'package:app_tim_kiem_viec_lam/core/models/model.dart';
import 'package:app_tim_kiem_viec_lam/core/models/user_model.dart';
import 'package:app_tim_kiem_viec_lam/core/providers/jobProvider.dart';
import 'package:app_tim_kiem_viec_lam/core/providers/userProvider.dart';

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
        onPressed: () {},
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
  late List<PostModel> posts;
  void initState() {
    super.initState();
    jobProvider = Provider.of<JobProvider>(context, listen: false);
    userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.fetchUser();
    jobProvider.getPots();

    // user = userProvider.user;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthenciationNotifier>(context);
    final providerJob = Provider.of<JobProvider>(context);
    return SingleChildScrollView(child: LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Consumer<UserProvider>(builder: (context, userProvider, _) {
              return HomeAppBar(user: userProvider.user);
            }),

            SizedBox(
              height: 20,
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
                    borderSide: BorderSide(color: HexColor("#F0F2F1")),
                    borderRadius: BorderRadius.circular(20)),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: HexColor("#F0F2F1")),
                    borderRadius: BorderRadius.circular(20)),
                hintText: 'Bạn đang tìm kiếm loại công việc nào ?',
              )),
            ),
            // CategorList(),
            JobHot(),
            TagList(),
            Consumer<JobProvider>(
              builder: (context, postProvider, _) {
                posts = postProvider.posts;
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
            // FutureBuilder(
            //   future: providerJob.getPots(),
            //   builder: (context, snapshot) {
            //     if (snapshot.hasData) {
            //       return Container(
            //         child: Column(
            //           children: [
            //             ...providerJob.posts.map((e) {
            //               return PostItem(post: e);
            //             })
            //           ],
            //         ),
            //       );
            //     } else if (snapshot.hasError) {
            //       return Text("Error: ${snapshot.error}");
            //     } else {
            //       return Container();
            //     }
            //   },
            // ),
          ],
        );
      },
    ));
  }
}
