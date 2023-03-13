import 'dart:io';
import 'dart:typed_data';

import 'package:app_tim_kiem_viec_lam/core/providers/authenciation_provider.dart';
import 'package:app_tim_kiem_viec_lam/core/providers/jobCategoryProvider.dart';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';

import 'package:provider/provider.dart';

import '../../core/models/jobCategory_model.dart';
import '../../core/models/user_model.dart';
import '../../core/providers/job_provider.dart';
import '../../core/providers/userProvider.dart';
import '../../widgets/Profile_widget.dart';
import '../../widgets/Textfiled_widget.dart';

class SelectJobScreen extends StatefulWidget {
  SelectJobScreen({super.key, this.user});
  UserModel? user;
  @override
  State<SelectJobScreen> createState() => _SelectJobScreenState();
}

class _SelectJobScreenState extends State<SelectJobScreen> {
  late JobProvider jobCategoryProvider;

  bool isLoading = false;

  JobCategoryModel? _jobCategory;
  List<JobCategoryModel> jobCategorytList = [];

  // JobCategory
  @override
  void initState() {
    super.initState();
    jobCategoryProvider = Provider.of<JobProvider>(context, listen: false);
    jobCategoryProvider.getJobCategory();
    jobCategorytList = jobCategoryProvider.jobs;
  }

  List<JobCategoryModel> searchResult = [];
  void searchJobs(String query) {
    List<JobCategoryModel> results = [];
    results.addAll(jobCategorytList.where(
        (item) => item.jobName!.toLowerCase().contains(query.toLowerCase())));

    setState(() {
      searchResult = results;
    });
  }

  Widget build(BuildContext context) {
    final imageProvider = Provider.of<JobProvider>(context);
    final provider = Provider.of<AuthenciationNotifier>(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
              pinned: true,
              floating: false,
              delegate: _MyHeader(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(children: [
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      Row(
                        children: [
                          buttonArrow(context),
                          Text(
                            "Đối tượng ngành nghề",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                    ]),
                    Container(
                      child: TextField(
                          onChanged: (query) => searchJobs(query),
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(vertical: 20.0),
                            prefixIcon: const Icon(
                              Icons.search_rounded,
                              size: 35,
                              color: Colors.black,
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: HexColor("#F0F2F1")),
                                borderRadius: BorderRadius.circular(20)),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: HexColor("#F0F2F1")),
                                borderRadius: BorderRadius.circular(20)),
                            hintText: 'Bạn đang tìm ngành nghề nào?',
                            filled: true,
                            fillColor: Colors.white,
                          )),
                    ),
                  ]),
                ),
              )),
          SliverList(
              delegate: SliverChildListDelegate([
            Container(
              height: MediaQuery.of(context).size.height * 0.68,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Consumer<JobProvider>(
                      builder: (context, jobCategoryProvider, _) {
                        return Container(
                          height: MediaQuery.of(context).size.height * 0.68,
                          child: Column(
                            children: [
                              Expanded(
                                child: ListView.builder(
                                  itemCount: searchResult.isEmpty
                                      ? jobCategoryProvider.jobs.length
                                      : searchResult.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    JobCategoryModel job = searchResult.isEmpty
                                        ? jobCategoryProvider.jobs[index]
                                        : searchResult[index];
                                    return Column(
                                      children: [
                                        RadioListTile(
                                          title: Text('${job.jobName}'),
                                          value: job,
                                          groupValue: _jobCategory,
                                          onChanged: (value) {
                                            setState(() {
                                              _jobCategory = value;
                                            });
                                          },
                                          activeColor: Colors.red,
                                        ),
                                        const Divider(),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            )
          ]))
        ],
      ),
      bottomNavigationBar: BottomAppBar(
          child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        color: HexColor("#BB2649"),
        height: MediaQuery.of(context).size.height * 0.1,
        child: ElevatedButton(
            onPressed: () {
              jobCategoryProvider.setSelectedOption = _jobCategory;

              Navigator.of(context).pop();
            },
            child: Container(
              padding: EdgeInsets.all(
                10,
              ),
              child: Text('Hoàn tất',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Colors.black)),
            ),
            style: ElevatedButton.styleFrom(
                primary: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)))),
      )),
    );
  }

  buttonArrow(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(right: 5, top: 20, bottom: 20),
        child: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
              clipBehavior: Clip.hardEdge,
              height: 55,
              width: 55,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(25)),
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              )),
        ));
  }
}

class _MyHeader extends SliverPersistentHeaderDelegate {
  _MyHeader({required this.child});

  final Widget child;

  @override
  double get minExtent => 180.0;

  @override
  double get maxExtent => 180.0;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: HexColor("#BB2649").withOpacity(1),
      child: child,
    );
  }

  @override
  bool shouldRebuild(_MyHeader oldDelegate) {
    return false;
  }
}
