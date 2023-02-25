import 'package:app_tim_kiem_viec_lam/core/models/model.dart';
import 'package:app_tim_kiem_viec_lam/core/models/user_model.dart';
import 'package:app_tim_kiem_viec_lam/core/providers/job_provider.dart';
import 'package:app_tim_kiem_viec_lam/screens/home/widgets/post_widgets/post_feed_widget.dart';
import 'package:app_tim_kiem_viec_lam/screens/profile/profile_edit.dart';
import 'package:app_tim_kiem_viec_lam/screens/profile/profile_setting.dart';
import 'package:app_tim_kiem_viec_lam/screens/profile/widgets/button_arrow.dart';
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
  late UserModel user;
  late List<PostModel> posts;
  @override
  void iniState() {
    super.initState();
    final provider = Provider.of<AuthenciationNotifier>(context);
    user = provider.user;
  }

  Widget build(BuildContext context) {
    final provider = Provider.of<AuthenciationNotifier>(context);
    final providerJob = Provider.of<JobProvider>(context);
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    final devicePadding = MediaQuery.of(context).padding;

    return Scaffold(
        backgroundColor: Colors.white,
        body: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
                pinned: true,
                floating: false,
                delegate: _MyHeader(
                    child: FutureBuilder(
                  future: provider.getData(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      user = snapshot.data;
                      return Row(
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
                                "@${user.fullname == null ? user.name : user.fullname}",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(color: Colors.black),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(),
                          ),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Text("Error: ${snapshot.error}");
                    } else {
                      return Container();
                    }
                  },
                ))),
            SliverList(
                delegate: SliverChildListDelegate([
              FutureBuilder(
                future: provider.getData(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    user = snapshot.data;
                    return Column(
                      children: [
                        _ProfileInformation(user: user),
                        _ProfileDetailInformation(user: user),
                        FutureBuilder(
                          future:
                              providerJob.getPotsById(user.userId.toString()),
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
                    );
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  } else {
                    return Container();
                  }
                },
              ),
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

class _ProfileInformation extends StatefulWidget {
  _ProfileInformation({super.key, this.user});
  final UserModel? user;

  @override
  State<_ProfileInformation> createState() => __ProfileInformationState();
}

class __ProfileInformationState extends State<_ProfileInformation> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          child: Container(
            padding: EdgeInsets.only(bottom: 25),
            child: Column(
              children: [
                widget.user!.imageUrl == null
                    ? (CircleAvatar(
                        radius: 50,
                        backgroundColor: HexColor("#BB2649"),
                        child: Text(
                            "${widget.user?.name.toString().substring(0, 1).toUpperCase()}",
                            style: TextStyle(fontSize: 40))))
                    : CircleAvatar(
                        radius: 50,
                        backgroundColor: HexColor("#BB2649"),
                        backgroundImage:
                            NetworkImage("${widget.user!.imageUrl}"),
                      ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 75),
                  child: Row(
                    children: [
                      _buildUserInfor(context, "Đang Follow", "100"),
                      _buildUserInfor(context, "Follow", "100"),
                      _buildUserInfor(context, "Thích", "100")
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    EditProfile(user: widget.user)));
                      },
                      child: Row(
                        children: [
                          Icon(Icons.mode_edit_outlined),
                          Text("Chỉnh sửa thông tin")
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                          primary: HexColor("#BB2649"),
                          fixedSize: Size(200, 50)),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfileSettingScreen()));
                      },
                      child: Icon(
                        Icons.more_horiz_outlined,
                        color: Colors.black,
                      ),
                      style: ElevatedButton.styleFrom(
                          primary: HexColor("#FFFFFF"),
                          fixedSize: Size(50, 50)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

Expanded _buildUserInfor(BuildContext context, String type, String value) {
  return Expanded(
    child: Column(
      children: [
        Text(
          value,
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          type,
          style: Theme.of(context)
              .textTheme
              .bodySmall!
              .copyWith(color: Colors.grey.shade600, letterSpacing: 1.1),
        )
      ],
    ),
  );
}

class _ProfileDetailInformation extends StatefulWidget {
  _ProfileDetailInformation({super.key, this.user});
  final UserModel? user;
  @override
  State<_ProfileDetailInformation> createState() =>
      __ProfileDetailInformationState();
}

class __ProfileDetailInformationState extends State<_ProfileDetailInformation> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 8),
        margin: EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Chi tiết",
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
            SizedBox(
              height: 10,
            ),
            _InforUser(
              text: widget.user!.email,
              icon: Icons.email_outlined,
            ),
            _InforUser(
              text: widget.user!.getGender,
              icon: widget.user!.gender == 1 ? Icons.man : Icons.girl,
            ),
            _InforUser(
              text: widget.user!.birthday.toString(),
              icon: Icons.cake,
            ),
            _InforUser(
              text: widget.user!.phone_number.toString(),
              icon: Icons.phone,
            ),
            _InforUser(
              text: widget.user!.experience,
              icon: Icons.star,
            ),
            _InforUser(
              text: widget.user!.status,
              icon: Icons.note_alt_outlined,
            ),
          ],
        ),
      ),
    );
  }
}

class _InforUser extends StatelessWidget {
  _InforUser({super.key, this.icon, this.text});
  final String? text;
  final IconData? icon;
  @override
  Widget build(BuildContext context) {
    return text == null || text == "null"
        ? Container()
        : Container(
            margin: EdgeInsets.symmetric(vertical: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon),
                SizedBox(
                  width: 5,
                ),
                Container(
                    padding: EdgeInsets.symmetric(vertical: 2),
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: Text(
                      "${text}",
                      textAlign: TextAlign.justify,
                    ))
              ],
            ),
          );
  }
}

// class _ProfileContent extends StatefulWidget {
//   const _ProfileContent({super.key, this.posts});
//   final List<PostModel>? posts;
//   @override
//   State<_ProfileContent> createState() => __ProfileContentState();
// }

// class __ProfileContentState extends State<_ProfileContent> {
//   @override
//   Widget build(BuildContext context) {
//     final deviceHeight = MediaQuery.of(context).size.height;
//     final deviceWidth = MediaQuery.of(context).size.width;
//     final devicePadding = MediaQuery.of(context).padding;
//     return DefaultTabController(
//       length: 2,
//       child: Column(
//         children: [
//           TabBar(indicatorColor: HexColor("#BB2649"), tabs: [
//             Tab(
//               icon: Icon(
//                 Icons.grid_view_outlined,
//                 color: HexColor("#BB2649"),
//               ),
//             ),
//             Tab(
//               icon: Icon(
//                 Icons.bookmark,
//                 color: HexColor("#BB2649"),
//               ),
//             )
//           ]),
//           SizedBox(
//             height: deviceHeight,
//             child: TabBarView(children: [
//               Column(
//                 children: [
//                   ...widget.posts!.map((post) {
//                     return PostItem(post: post);
//                   }).toList()
//                 ],
//               ),
//               Icon(
//                 Icons.bookmark,
//                 color: HexColor("#BB2649"),
//               )
//             ]),
//           ),
//         ],
//       ),
//     );
//   }
// }
