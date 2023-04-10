import 'dart:io';
import 'dart:math';

import 'package:app_tim_kiem_viec_lam/core/models/applied_model.dart';
import 'package:app_tim_kiem_viec_lam/core/models/user_model.dart';
import 'package:app_tim_kiem_viec_lam/core/supabase/supabase.dart';
import 'package:app_tim_kiem_viec_lam/data/home/featureJobsData.dart';
import 'package:app_tim_kiem_viec_lam/screens/detailJob/detail_job.dart';
import 'package:app_tim_kiem_viec_lam/screens/profile/widgets/button_arrow.dart';
import 'package:app_tim_kiem_viec_lam/utils/constant.dart';
import 'package:app_tim_kiem_viec_lam/widgets/text_field_widgets.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../../core/models/jobs_model.dart';
import '../../core/providers/user_provider.dart';
import '../../widgets/avatar_widget.dart';
import '../../widgets/show_frame_profile.dart';
import '../profile/profile_screen.dart';

class ApplyJob extends StatefulWidget {
  const ApplyJob({super.key, required this.job, required this.user});
  final JobModel job;
  final UserModel user;
  @override
  State<ApplyJob> createState() => _ApplyJobState();
}

class _ApplyJobState extends State<ApplyJob> {
  final ScrollController _scrollController = ScrollController();
  double top = 0.0;
  double _opacity = 0;
  PlatformFile? _file;
  File? file;
  String? _note;
  IconData iconFile(file) {
    String icon = file.extension;
    switch (icon) {
      case 'pdf':
        return Icons.picture_as_pdf_outlined;

      default:
        return Icons.description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                automaticallyImplyLeading: false,
                backgroundColor: HexColor("#FFFFFF"),
                pinned: true,
                expandedHeight: 170.h,
                flexibleSpace: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    top = constraints.biggest.height;
                    if (top.toDouble() < 100) {
                      _opacity = 1;
                    } else {
                      _opacity = 0;
                    }
                    // Neu < 100 thi chi show text , con khong show 1 app bar ở backgroud
                    return FlexibleSpaceBar(
                      expandedTitleScale: 1,
                      collapseMode: CollapseMode.pin,
                      background: _AppBarJobApply(
                        context,
                        job: widget.job,
                        isScroll: false,
                      ),
                      titlePadding: EdgeInsets.only(
                        left: 0,
                        right: 0,
                      ),
                      // title: Container(
                      //   child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //       children: [
                      //         AnimatedOpacity(
                      //             duration: Duration(milliseconds: 0),
                      //             //opacity: top == MediaQuery.of(context).padding.top + kToolbarHeight ? 1.0 : 0.0,
                      //             opacity: _opacity,
                      //             child: HomeAppBar(
                      //                 user: userProvider.user, isScroll: true)),
                      //       ]),
                      // )
                    );
                  },
                ),
              ),
              SliverList(
                  delegate: SliverChildListDelegate([
                Container(
                  margin:
                      EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                  width: 1.sw,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ShowProfile(user: widget.user),
                      // _showProfile(context, widget.user),
                      _submitFile(context)
                    ],
                  ),
                )
              ]))
            ],
          ),
        ],
      ),
      bottomNavigationBar: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          return BottomAppBar(
              color: Colors.transparent,
              elevation: 0.0,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
                // color: Colors.transparent,
                height: 0.1.sh,
                child: ElevatedButton(
                    onPressed: () async {
                      if (file != null) {
                        Random random = new Random();
                        final fileBytes = await file?.readAsBytes();
                        int randomNumber = random.nextInt(100);

                        final fileName =
                            '${userProvider.user.userId}/${randomNumber}_${_file?.name}';
                        final storageResponse = await SupabaseBase
                            .supabaseClient.storage
                            .from('job')
                            .uploadBinary(fileName, fileBytes!);

                        final publicUrl = SupabaseBase.supabaseClient.storage
                            .from('job')
                            .getPublicUrl(fileName);
                        ApplyModel newApply = ApplyModel(
                            jobId: widget.job.jobId.toString(),
                            userId: widget.user.userId.toString(),
                            note: _note ?? "",
                            fileUrl: publicUrl);
                        print('Public URL: $publicUrl');
                        print(storageResponse);
                        jobProvider.inserApplyJob(context, newApply);
                      }
                    },
                    child: Container(
                      child: Text('Apply',
                          style: textTheme.medium16(color: "FFFFFF")),
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: HexColor("#BB2649"),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r)))),
              ));
        },
      ),
    );
  }

  _AppBarJobApply(BuildContext context,
      {required JobModel job, required bool isScroll}) {
    return SafeArea(
      child: Container(
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
                    alignment: Alignment.center,
                    child: Text(
                      "Apply",
                      style: textTheme.semibold20(color: "000000"),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(),
                ),
              ],
            ),
            Container(
              // width: 1.sw,
              padding: EdgeInsets.symmetric(horizontal: 44.w),
              child: Row(
                children: [
                  AvatarWidget(context, user: job.users, radius: 35),
                  SizedBox(
                    width: 16.5.w,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${job.jobName} ",
                        style: textTheme.sub14(),
                      ),
                      // Spacer(),
                      Text(
                        "${job.users!.name}",
                        style:
                            textTheme.regular13(color: "#0D0D26", opacity: 0.6),
                      )
                    ],
                  ),
                  Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "\$96,000/y",
                        style: textTheme.medium12(),
                      ),
                      Text(
                        "Los Angels, US",
                        style:
                            textTheme.regular13(color: "#0D0D26", opacity: 0.6),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _submitFile(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Text(
          "Cover Later (Optional)",
          style: textTheme.semibold16(color: "000000"),
        ),
        SizedBox(
          height: 16.h,
        ),
        DottedBorder(
          color: HexColor("#BB2649"),
          borderType: BorderType.RRect,
          radius: Radius.circular(12),
          padding: EdgeInsets.all(6),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 40.h),
              height: 327.h,
              width: 327.w,
              color: Colors.transparent,
              child: Column(
                children: [
                  Text(
                    "Upload your CV or Resume and use it when you apply for jobs",
                    textAlign: TextAlign.center,
                    style: textTheme.medium14(color: "95969D"),
                  ),
                  SizedBox(
                    height: 32.h,
                  ),
                  Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: HexColor("#BB2649").withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12.r)),
                        alignment: Alignment.center,
                        width: 286.w,
                        height: 73.h,
                        child: _file == null
                            ? Container(
                                alignment: Alignment.center,
                                width: 270.w,
                                child: Text(
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  "Upload a Doc/Docx/PDF",
                                  style: textTheme.medium14(color: "BB2649"),
                                ),
                              )
                            : Container(
                                padding: EdgeInsets.symmetric(horizontal: 10.w),
                                child: Row(
                                  children: [
                                    Icon(
                                      iconFile(_file),
                                      color: Colors.red,
                                    ),
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                    Text(_file!.name)
                                  ],
                                ),
                              ),
                      ),
                      _file?.name == null
                          ? Container()
                          : Positioned(
                              right: 8.w,
                              top: 8.h,
                              child: GestureDetector(
                                onTap: () {
                                  print("xoas");
                                  setState(() {
                                    _file = null;
                                  });
                                },
                                child: Icon(
                                  Icons.close_rounded,
                                  color: HexColor("#BB2649"),
                                ),
                              ))
                    ],
                  ),
                  SizedBox(
                    height: 32.h,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: HexColor("#BB2649"),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r))),
                      onPressed: () async {
                        FilePickerResult? result =
                            await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['docx', 'pdf', 'doc'],
                        );

                        if (result != null) {
                          file = File(result.files[0].path.toString());
                          // await
                          setState(() {
                            _file = result.files[0];
                          });
                        } else {
                          // User canceled the picker
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 13.h, horizontal: 43.w),
                        child: Text(
                          "Upload",
                          style: textTheme.medium16(color: "FFFFFF"),
                        ),
                      ))
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
        Container(
          // width: 0.6.sw,
          child: TextFieldWid(
            maxLines: 3,
            label: 'Hãy viết gì đó cho nhà tuyển dụng',
            text: '',
            enbled: true,
            onChanged: (value) {
              _note = value;
            },
          ),
        ),
      ],
    ));
  }
}
