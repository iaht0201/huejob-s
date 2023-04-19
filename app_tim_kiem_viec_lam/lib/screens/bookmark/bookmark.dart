import 'package:app_tim_kiem_viec_lam/screens/bookmark/widgets/job_bookmark.dart';
import 'package:app_tim_kiem_viec_lam/screens/bookmark/widgets/post_bookmark.dart';
import 'package:app_tim_kiem_viec_lam/screens/profile/widgets/button_arrow.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../../core/providers/jobs_provider.dart';
import '../../core/providers/post_provider.dart';
import '../../utils/constant.dart';

class BookMarkScreen extends StatefulWidget {
  const BookMarkScreen({super.key});

  @override
  State<BookMarkScreen> createState() => _BookMarkScreenState();
}

class _BookMarkScreenState extends State<BookMarkScreen> {
  final ScrollController _scrollController = ScrollController();
  double top = 0.0;
  double _opacity = 0;
  late JobsProvider jobProvider;
  late PostProvider postProvider;
  void initState() {
    jobProvider = Provider.of<JobsProvider>(context, listen: false);
    postProvider = Provider.of<PostProvider>(context, listen: false);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        DefaultTabController(
          length: 2,
          child: CustomScrollView(
            // controller: _scrollController,
            slivers: [
              SliverAppBar(
                automaticallyImplyLeading: false,
                backgroundColor: HexColor("#FFFFFF"),
                pinned: true,
                expandedHeight: 130.h,
                flexibleSpace: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    top = constraints.biggest.height;
                    if (top.toDouble() < 100.h) {
                      _opacity = 1;
                    } else {
                      _opacity = 0;
                    }
                    return FlexibleSpaceBar(
                      expandedTitleScale: 1,
                      collapseMode: CollapseMode.pin,
                      background: _bookMarkAppBar(context),
                      titlePadding: EdgeInsets.only(
                        left: 0,
                        right: 0,
                      ),
                      title: AnimatedOpacity(
                          duration: Duration(milliseconds: 0),
                          opacity: _opacity,
                          child: _tabBar(context)),
                    );
                  },
                ),
              ),
              SliverList(
                  delegate: SliverChildListDelegate([
                Container(
                  height: 1.sh,
                  child: TabBarView(
                    children: [
                      JobBookMarkWidget(),
                      PostBookMarkWidget(),
                    ],
                  ),
                ),
              ]))
            ],
          ),
        )
      ],
    ));
  }

  _bookMarkAppBar(BuildContext context) {
    return SafeArea(
      child: Container(
          width: 1.sw,
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: buttonArrow(context),
                  ),
                  Expanded(
                    flex: 6,
                    child: Container(
                      margin: EdgeInsets.only(top: 20.h),
                      alignment: Alignment.topCenter,
                      child: Text("Đã lưu",
                          style: textTheme.semibold20(color: "000000")),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(),
                  ),
                ],
              ),
              _tabBar(context)
            ],
          )),
    );
  }

  _tabBar(context) {
    return TabBar(
      indicatorColor: HexColor("#BB2649"),
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      tabs: [
        Tab(
            height: 40.h,
            icon: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/icons/job-search.png",
                  width: 25.w,
                ),
                SizedBox(
                  width: 10.w,
                ),
                Text(
                  "Jobs",
                  style: textTheme.regular16(color: "000000"),
                )
              ],
            )),
        Tab(
            height: 40.h,
            icon: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/icons/social-media.png",
                  width: 25.w,
                ),
                SizedBox(
                  width: 10.w,
                ),
                Text(
                  "Posts",
                  style: textTheme.regular16(color: "000000"),
                )
              ],
            )),
      ],
    );
  }
}
