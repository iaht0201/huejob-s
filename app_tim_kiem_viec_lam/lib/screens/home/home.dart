import 'dart:async';

import 'package:app_tim_kiem_viec_lam/core/models/user_model.dart';
import 'package:app_tim_kiem_viec_lam/core/providers/job_provider.dart';
import 'package:app_tim_kiem_viec_lam/core/supabase/supabase.dart';
import 'package:app_tim_kiem_viec_lam/screens/home/widgets/tag_list.dart';
import 'package:app_tim_kiem_viec_lam/screens/home/widgets/home_app_bar.dart';
import 'package:app_tim_kiem_viec_lam/screens/home/widgets/job_hot.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/animation/animation_controller.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/ticker_provider.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/models/post_model.dart';
import '../../core/providers/authenciation_provider.dart';
import '../../data/data.dart';
import 'widgets/post_widgets/post_feed_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final List<UserModel> user = [];
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthenciationNotifier>(context);
    final providerJob = Provider.of<JobProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder(
                future: provider.getData(provider.user.user_id),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return HomeAppBar(user: snapshot.data);
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  } else {
                    return Container();
                  }
                },
              ),

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
      )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 252, 198, 3),
        onPressed: () {},
        elevation: 0,
        child: Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: Theme(
        data: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedItemColor: Theme.of(context).primaryColor,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Trang chủ',
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.bookmark_outline), label: 'Lưu trữ'),
            BottomNavigationBarItem(icon: Text(''), label: ''),
            BottomNavigationBarItem(
                icon: Icon(Icons.notifications_none), label: 'Case'),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_outline), label: 'Trang cá nhân')
          ],
        ),
      ),
    );
  }
}
