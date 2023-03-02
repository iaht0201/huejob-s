import 'dart:async';

import 'package:app_tim_kiem_viec_lam/core/models/user_model.dart';
import 'package:app_tim_kiem_viec_lam/core/providers/job_provider.dart';
import 'package:app_tim_kiem_viec_lam/core/providers/userProvider.dart';
import 'package:app_tim_kiem_viec_lam/core/supabase/supabase.dart';
import 'package:app_tim_kiem_viec_lam/screens/authentication/login/login.dart';
import 'package:app_tim_kiem_viec_lam/screens/home/widgets/tag_list.dart';
import 'package:app_tim_kiem_viec_lam/screens/home/widgets/home_app_bar.dart';
import 'package:app_tim_kiem_viec_lam/screens/home/widgets/job_hot.dart';
import 'package:app_tim_kiem_viec_lam/screens/profile/profile_screen.dart';
import 'package:app_tim_kiem_viec_lam/screens/profile/profile_setting.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/animation/animation_controller.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/ticker_provider.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/models/post_model.dart';
import '../../core/providers/authenciation_provider.dart';
import '../../core/routes/routes.dart';
import '../../data/bottomNavigation_data.dart';
import '../../data/data.dart';
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

  // Widget getTabs() {
  //   return SalomonBottomBar(
  //       currentIndex: pageIndex,
  //       onTap: (index) {
  //         setState(() {
  //           pageIndex = index;
  //           if (index == 0) {
  //             {
  //               Navigator.pushReplacementNamed(context, AppRoutes.HomeRoutes);
  //             }
  //           } else if (index == 1) {
  //             Navigator.pushNamed(context, '/file');
  //           } else if (index == 2) {
  //             Navigator.pushNamed(context, '/destroy');
  //           } else {
  //             Navigator.push(context,
  //                 MaterialPageRoute(builder: (context) => ProfileScreen()));
  //           }
  //         });
  //       },
  //       items: List.generate(BottomNavigationData.length, (index) {
  //         return SalomonBottomBarItem(
  //           icon: Icon(BottomNavigationData[index]['icon']),
  //           title: Text(BottomNavigationData[index]['text']),
  //         );
  //       }));
  // }
}

class _ContentHome extends StatefulWidget {
  const _ContentHome({super.key});

  @override
  State<_ContentHome> createState() => __ContentHomeState();
}

class __ContentHomeState extends State<_ContentHome> {
  late UserProvider userProvider;
  late UserModel user;
   void initState() {
    super.initState();
    userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.fetchUser();
    user = userProvider.user;
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
             Consumer<UserProvider>(
                  builder: (context, userProvider, _) { 
                    return  HomeAppBar(user: userProvider.user);
                  }) ,
            // FutureBuilder(
            //   future: provider.getData(),
            //   builder: (context, snapshot) {
            //     if (snapshot.hasData) {
            //       return HomeAppBar(user: snapshot.data);
            //     } else if (snapshot.hasError) {
            //       return Text("Error: ${snapshot.error}");
            //     } else {
            //       return Container();
            //     }
            //   },
            // ),

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
            FutureBuilder(
              future: providerJob.getPots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    child: Column(
                      children: [
                        ...providerJob.posts.map((e) {
                          return PostItem(post: e);
                        })
                      ],
                    ),
                  );
                  // return Container(
                  //   height: MediaQuery.of(context).size.height * 0.8,
                  //   child: ListView.builder(
                  //     physics: BouncingScrollPhysics(),

                  //     itemCount: snapshot.data.length,
                  //     itemBuilder: (context, index) {
                  //       return PostItem(post: snapshot.data[index]);
                  //     },
                  //   ),
                  // );
                  // return  PostItem(post: snapshot.data[0]) ;

                } else if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                } else {
                  return Container();
                }
              },
            ),

            // ...posts.asMap().entries.map((item) {
            //   final Post post = posts[item.key];
            //   return PostItem(post: post);
            // }).toList()  ,
          ],
        );
      },
    ));
  }
}
