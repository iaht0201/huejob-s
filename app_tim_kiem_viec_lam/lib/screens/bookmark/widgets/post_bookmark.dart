import 'package:app_tim_kiem_viec_lam/core/models/model.dart';
import 'package:app_tim_kiem_viec_lam/core/providers/post_provider.dart';
import 'package:app_tim_kiem_viec_lam/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../home/widgets/post_widgets/post_feed_widget.dart';

class PostBookMarkWidget extends StatefulWidget {
  const PostBookMarkWidget({super.key});

  @override
  State<PostBookMarkWidget> createState() => _PostBookMarkWidgetState();
}

class _PostBookMarkWidgetState extends State<PostBookMarkWidget> {
  late PostProvider postProvider;
  void initState() {
    postProvider = Provider.of<PostProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Builder(
        builder: (context) {
          return CustomScrollView(
            slivers: [
              SliverOverlapInjector(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              ),
              SliverList(
                  delegate: SliverChildListDelegate([
                FutureBuilder(
                  future: postProvider.getBookMarkPost(),
                  builder: (context, snapshot) {
                    List<PostModel> _listPost = [];
                    if (snapshot.hasData) {
                      _listPost = snapshot.data;
                      return Column(children: [
                        ..._listPost.map((e) => PostItem(post: e))
                      ]);
                    } else {
                      return Column(
                        children: [
                          ...List.generate(
                              3,
                              (index) =>
                                  shimmerFromColor(width: 1.sw, height: 200.h))
                        ],
                      );
                    }
                  },
                )
              ]))
            ],
          );
        },
      ),
    );
    // SingleChildScrollView(
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.start,
    //     children: [
    //       FutureBuilder(
    //         future: postProvider.getBookMarkPost(),
    //         builder: (context, snapshot) {
    //           List<PostModel> _listPost = [];
    //           if (snapshot.hasData) {
    //             _listPost = snapshot.data;
    //             return Column(
    //                 children: [..._listPost.map((e) => PostItem(post: e))]);
    //           } else {
    //             return Container();
    //           }
    //         },
    //       ),
    //       // posts
    //     ],
    //   ),
    // );
  }
}
