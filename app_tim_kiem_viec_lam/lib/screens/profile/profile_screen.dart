import 'package:app_tim_kiem_viec_lam/core/models/model.dart';
import 'package:app_tim_kiem_viec_lam/core/models/user_model.dart';
import 'package:app_tim_kiem_viec_lam/core/providers/job_provider.dart';
import 'package:app_tim_kiem_viec_lam/core/providers/userProvider.dart';
import 'package:app_tim_kiem_viec_lam/screens/home/widgets/post_widgets/post_feed_widget.dart';
import 'package:app_tim_kiem_viec_lam/screens/profile/profile_edit.dart';
import 'package:app_tim_kiem_viec_lam/screens/profile/profile_setting.dart';
import 'package:app_tim_kiem_viec_lam/screens/profile/widgets/button_arrow.dart';
import 'package:app_tim_kiem_viec_lam/screens/profile/widgets/profile_information.dart';
import 'package:app_tim_kiem_viec_lam/screens/profile/widgets/profile_detail_information.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../../core/providers/authenciation_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late List<PostModel> posts;
  String? _imageUrl;
  @override
  void iniState() {
    super.initState();
    final provider = Provider.of<UserProvider>(context);
    // provider.fetchUser() ;
  }

  void updateImageUrl(String url) {
    setState(() {
      _imageUrl = url;
      print(_imageUrl);
    });
  }

  Widget build(BuildContext context) {
    final provider = Provider.of<AuthenciationNotifier>(context);
    final providerJob = Provider.of<JobProvider>(context);
    UserModel user;
    return Scaffold(
        backgroundColor: Colors.white,
        body: Consumer<UserProvider>(
          builder: (context, userProvider, _) {
            return CustomScrollView(
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
                            child: Center(
                              child: Text(
                                "@${userProvider.user!.fullname == null ? userProvider.user!.name : userProvider.user!.fullname}",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(color: Colors.black),
                              ),
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
                      ProfileInformation(
                          user: userProvider.user,
                          initials: "A",
                          onImageUrlChanged: updateImageUrl),
                      ProfileDetailInformation(user: userProvider.user),
                      FutureBuilder(
                        future: providerJob
                            .getPotsById(userProvider.user.userId.toString()),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            posts = snapshot.data;

                            return Column(
                              children: [
                                ...posts.map((post) {
                                  return PostItem(post: post);
                                }).toList()
                              ],
                            );
                          } else if (snapshot.hasError) {
                            return Text("Error: ${snapshot.error}");
                          } else {
                            return Container();
                          }
                        },
                      )
                    ],
                  )
                ]))
              ],
            );
          },
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
