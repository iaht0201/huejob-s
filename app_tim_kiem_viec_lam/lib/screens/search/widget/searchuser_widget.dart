import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../core/models/user_model.dart';
import '../../../core/providers/user_provider.dart';
import '../../../utils/constant.dart';
import '../../../widgets/avatar_widget.dart';
import '../../detailJob/detail_job.dart';
import '../../profile/profile_screen.dart';

class SearchUserWidget extends StatefulWidget {
  const SearchUserWidget({super.key, this.query});
  final String? query;

  @override
  State<SearchUserWidget> createState() => _SearchUserWidgetState();
}

class _SearchUserWidgetState extends State<SearchUserWidget> {
  late UserProvider userProvider;
  void initState() {
    super.initState();
    userProvider = Provider.of<UserProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: userProvider.fetchUserByQuery(query: widget.query),
        builder: (context, snapshot) {
          List<UserModel> listUser = [];
          if (snapshot.hasData) {
            listUser = snapshot.data;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Người dùng",
                  style: textTheme.semibold16(color: "000000"),
                ),
                ...listUser
                    .map((e) => GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProfileScreen(
                                        clientID: userProvider.user.userId)));
                          },
                          child: Container(
                              margin: EdgeInsets.only(top: 10.h, bottom: 10.h),
                              child: Row(
                                children: [
                                  AvatarWidget(context, user: e, radius: 25.r),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${e.name}",
                                        style: textTheme.regular16(),
                                      ),
                                      e.familyname == null ||
                                              e.firstname == null
                                          ? Container()
                                          : Text(
                                              " ${e.familyname} ${e.firstname}")
                                    ],
                                  )
                                ],
                              )),
                        ))
                    .toList(),
              ],
            );
          }
          return Container(
            child: Column(
              children: [
                ...List.generate(
                    7,
                    (index) => Container(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            children: [
                              shimmerAvatarColor(radius: 30.r),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  shimmerFromColor(width: 0.5.sw, height: 15.h),
                                  shimmerFromColor(width: 0.4.sw, height: 15.h)
                                ],
                              )
                            ],
                          ),
                        )).toList()
              ],
            ),
          );
        },
      ),
    );
  }
}
