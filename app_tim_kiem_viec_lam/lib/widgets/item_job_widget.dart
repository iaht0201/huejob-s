import 'package:app_tim_kiem_viec_lam/core/models/jobs_model.dart';
import 'package:app_tim_kiem_viec_lam/core/providers/jobs_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../screens/detailJob/detail_job.dart';
import '../screens/profile/profile_screen.dart';
import '../utils/constant.dart';

class ItemJobWidget extends StatefulWidget {
  ItemJobWidget({super.key, required this.job});
  JobModel job;

  @override
  State<ItemJobWidget> createState() => _ItemJobWidgetState();
}

class _ItemJobWidgetState extends State<ItemJobWidget> {
  late JobsProvider jobProvider;
  bool isBookMarked = false;
  bool isLoading = false;
  void initState() {
    jobProvider = Provider.of<JobsProvider>(context, listen: false);
    jobProvider.getBookMarkJob().whenComplete(() {
      setState(() {
        for (JobModel job in jobProvider.listBookmark) {
          if (job.jobId == widget.job.jobId) {
            isBookMarked = true;
          }
        }
        isLoading = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          DetailJobScreen(jobId: widget.job.jobId.toString())));
            },
            child: Container(
                padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 25.w),
                margin: EdgeInsets.only(right: 15.w, top: 20.h),
                width: 156.w,
                height: 190.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: GestureDetector(
                        onTap: () {
                          // _navigatorDrawer(context);
                          // Scaffold.of(context).openDrawer();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfileScreen(
                                      clientID: widget.job.userId)));
                        },
                        child: widget.job.users!.imageUrl == null
                            ? (CircleAvatar(
                                radius: 22.r,
                                backgroundColor: HexColor("#BB2649"),
                                child: Text(
                                    "${widget.job.users!.name.toString().substring(0, 1).toUpperCase()}",
                                    style: const TextStyle(fontSize: 25))))
                            : CircleAvatar(
                                radius: 22.r,
                                backgroundColor: HexColor("#BB2649"),
                                backgroundImage: NetworkImage(
                                    "${widget.job.users!.imageUrl}"),
                              ),
                      ),
                    ),
                    SizedBox(
                      height: 12.h,
                    ),
                    Text(
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      "${widget.job.jobName}",
                      style: textTheme.sub14(),
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
                    Text(
                      "${widget.job.users?.fullname ?? widget.job.users?.name}",
                      style:
                          textTheme.regular13(color: "#0D0D26", opacity: 0.6),
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    Text(
                      "${widget.job.wage}",
                      style: textTheme.medium12(),
                    ),
                  ],
                ))),
        isLoading
            ? Positioned(
                right: 25.h,
                top: 25.h,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
                  child: GestureDetector(
                    onTap: () {
                      if (isBookMarked) {
                        jobProvider
                            .deleteBookMarkJob(widget.job.jobId.toString());
                        setState(() {
                          isBookMarked = false;
                        });
                      } else {
                        jobProvider.addBookMarkJob(widget.job.jobId.toString());
                        setState(() {
                          isBookMarked = true;
                        });
                      }
                      // setState(() {
                      //   isBookMarked = !isBookMarked;
                      // });
                    },
                    child: Image.asset(
                      "assets/icons/${isBookMarked ? 'bookmark' : 'bookmark1'}.png",
                      width: 15.w,
                    ),
                  ),
                ))
            : Container()
      ],
    );
  }
}
