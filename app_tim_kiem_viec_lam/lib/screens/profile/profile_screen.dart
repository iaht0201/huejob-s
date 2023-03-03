import 'package:app_tim_kiem_viec_lam/core/models/model.dart';
import 'package:app_tim_kiem_viec_lam/core/models/user_model.dart';

import 'package:app_tim_kiem_viec_lam/core/providers/userProvider.dart';
import 'package:app_tim_kiem_viec_lam/screens/home/widgets/post_widgets/post_feed_widget.dart';

import 'package:app_tim_kiem_viec_lam/screens/profile/widgets/button_arrow.dart';
import 'package:app_tim_kiem_viec_lam/screens/profile/widgets/profile_information.dart';
import 'package:app_tim_kiem_viec_lam/screens/profile/widgets/profile_detail_information.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../core/providers/authenciation_provider.dart';
import '../../core/providers/job_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late List<PostModel> posts;
  String? _imageUrl;

  void updateImageUrl(String url) {
    setState(() {
      _imageUrl = url;
      print(_imageUrl);
    });
  }

  late JobProvider jobProvider;
  late UserProvider userProvider;
  @override
  void initState() {
    super.initState();
    jobProvider = Provider.of<JobProvider>(context, listen: false);
    userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.fetchUser();
    jobProvider.getPotsById();

    // user = userProvider.user;
  }
  // void iniState() {
  //   final provider = Provider.of<UserProvider>(context);
  //   final providerJob = Provider.of<JobProvider>(context);
  //   providerJob.getPotsById();
  //   super.initState();
  //   // provider.fetchUser() ;
  // }

  Widget build(BuildContext context) {
    final provider = Provider.of<AuthenciationNotifier>(context);
    final providerJob = Provider.of<JobProvider>(context);
    UserModel user;
    return Scaffold(
        backgroundColor: Colors.white,
        body: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
                pinned: true,
                floating: false,
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
                            return Center(
                              child: Text(
                                "@${userProvider.user!.fullname == null ? userProvider.user!.name : userProvider.user!.fullname}",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(color: Colors.black),
                              ),
                            );
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
                      return Column(
                        children: [
                          ProfileInformation(
                              user: userProvider.user,
                              initials: "A",
                              onImageUrlChanged: updateImageUrl),
                          ProfileDetailInformation(user: userProvider.user),
                        ],
                      );
                    },
                  ),

                  Consumer<JobProvider>(
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
}

class _MyHeader extends SliverPersistentHeaderDelegate {
  _MyHeader({required this.child});

  final Widget child;

  @override
  double get minExtent => 80.0;

  @override
  double get maxExtent => 80.0;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: child,
    );
  }

  @override
  bool shouldRebuild(_MyHeader oldDelegate) {
    return false;
  }
}
