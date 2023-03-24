import 'dart:async';

import 'package:app_tim_kiem_viec_lam/core/models/model.dart';
import 'package:app_tim_kiem_viec_lam/core/models/user_model.dart';

import 'package:app_tim_kiem_viec_lam/core/providers/userProvider.dart';
import 'package:app_tim_kiem_viec_lam/screens/addPost/addPost_Screen.dart';

import 'package:app_tim_kiem_viec_lam/screens/authentication/login/login.dart';
import 'package:app_tim_kiem_viec_lam/screens/chat/listChatScreen.dart';
import 'package:app_tim_kiem_viec_lam/screens/home/widgets/featuredJobs.dart';
import 'package:app_tim_kiem_viec_lam/screens/home/widgets/otherJobs.dart';
import 'package:app_tim_kiem_viec_lam/screens/home/widgets/recommendJobs.dart';

import 'package:app_tim_kiem_viec_lam/screens/home/widgets/home_app_bar.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import '../../core/providers/authenciation_provider.dart';
import '../../core/providers/postProvider.dart';
import '../home/widgets/post_widgets/post_feed_widget.dart';

class SocialScreen extends StatefulWidget {
  const SocialScreen({super.key});

  @override
  State<SocialScreen> createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen> {
  late UserProvider userProvider;
  late UserModel user;
  late PostProvider jobProvider;
  List<PostModel> posts = [];
  int _page = 1;
  int _pageSize = 2;
  bool _isLoading = false;
  ScrollController _scrollController = ScrollController();
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
    final provider = Provider.of<AuthenciationNotifier>(context);
    final providerJob = Provider.of<PostProvider>(context);
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
            SliverList(
                delegate: SliverChildListDelegate([
              Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  color: HexColor("#FAFAFD"),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // SizedBox(
                      //   height: 25,
                      // ),
                      // Container(
                      //   padding: EdgeInsets.symmetric(horizontal: 24.w),
                      //   width: 1.sw,
                      //   child: Row(
                      //     children: [
                      //       Container(
                      //         width: 250.w,
                      //         height: 55.h,
                      //         decoration: BoxDecoration(
                      //             color: HexColor("#F2F2F3"),
                      //             borderRadius:
                      //                 BorderRadius.all(Radius.circular(12))),
                      //         padding: EdgeInsets.symmetric(
                      //             vertical: 13.h, horizontal: 24.w),
                      //         child: Row(
                      //           children: [
                      //             Image.asset(
                      //               "assets/icons/search.png",
                      //               width: 20.w,
                      //               height: 20.h,
                      //             ),
                      //             SizedBox(
                      //               width: 10.w,
                      //             ),
                      //             Text(
                      //               "Tìm kiếm công việc ",
                      //               style: TextStyle(
                      //                   color: HexColor("#95969D"),
                      //                   fontSize: 15),
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //       SizedBox(
                      //         width: 12.w,
                      //       ),
                      //       Container(
                      //           width: 55.w,
                      //           height: 55.h,
                      //           decoration: BoxDecoration(
                      //               color: HexColor("#F2F2F3"),
                      //               borderRadius:
                      //                   BorderRadius.all(Radius.circular(12))),
                      //           padding: EdgeInsets.all(11),
                      //           child: Image.asset(
                      //             "assets/icons/filter.png",
                      //             width: 26.w,
                      //             height: 26.h,
                      //           )),
                      //     ],
                      //   ),
                      // ),

                      // posts
                      Consumer<PostProvider>(
                        builder: (context, postProvider, _) {
                          return Container(
                            child: Column(
                              children: [
                                ...postProvider.posts.map((e) {
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

// import 'package:app_tim_kiem_viec_lam/screens/chat/chatMessages.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:provider/provider.dart';

// import '../../core/providers/chatMessagerProvider.dart';
// import '../../core/providers/job_provider.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   Future<void> _loginUser(
//       ChatProvider appService, String _email, String _password) async {
//     await appService.signIn(_email, _password);

//     setState(() {});
//   }

//   Future<void> _signOut(ChatProvider appService) async {
//     await appService.signOut();

//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     final appService = Provider.of<ChatProvider>(context, listen: false);
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(appService.isAuthentificated()
//             ? appService.getCurrentUserEmail()
//             : 'Chat'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [

//             const SizedBox(height: 10.0),
//             ElevatedButton(
//               onPressed: () =>
//                   _loginUser(appService, "t123@gmail.com", '12345678'),
//               child: const Text('Login User 1'),
//             ),
//             const SizedBox(height: 10.0),
//             ElevatedButton(
//               onPressed: () =>
//                   _loginUser(appService, "test123@gmail.com", '12345678'),
//               child: const Text('Login User 2'),
//             ),
//             const SizedBox(height: 10.0),
//             ElevatedButton(
//               onPressed: () => _signOut(appService),
//               child: const Text('Sign out'),
//             ),
//             const SizedBox(height: 10.0),
//             ElevatedButton(
//               onPressed: () => Navigator.push(
//                   context, MaterialPageRoute(builder: (context) => ChatPage())),
//               child: const Text('Go To Chat'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
