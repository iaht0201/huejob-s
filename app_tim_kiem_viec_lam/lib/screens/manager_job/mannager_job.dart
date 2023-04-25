import 'package:app_tim_kiem_viec_lam/widgets/item_job_horizal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../../core/models/jobs_model.dart';
import '../../core/providers/jobs_provider.dart';
import '../../utils/constant.dart';
import '../../widgets/avatar_widget.dart';
import '../profile/widgets/button_arrow.dart';
import 'mannager_apply.dart';
// import 'package:path/path.dart';

class MannagerJobScreen extends StatefulWidget {
  const MannagerJobScreen({Key? key}) : super(key: key);

  @override
  _MannagerJobScreenState createState() => _MannagerJobScreenState();
}

class _MannagerJobScreenState extends State<MannagerJobScreen> {
  late JobsProvider jobProvider;
  List<JobModel> _listJobRecruiter = [];
  List<String> _listSelected = [];
  List<JobModel> selectedJobs = [];

  bool isLoading = false;
  void initState() {
    super.initState();
    jobProvider = Provider.of<JobsProvider>(context, listen: false);
    jobProvider.fetchJobByRecruiter();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor("#FFFFFF"),
        elevation: 0,
        leading: buttonArrow(context),
        title: Text(
          "Quản lý job",
          style: textTheme.semibold16(color: "#000000"),
        ),
      ),
      body: SingleChildScrollView(child: Consumer<JobsProvider>(
        builder: (context, jobProvider, _) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                ...jobProvider.listJobRecruiter
                    .map((e) => _itemJobManager(context, job: e))
              ],
            ),
          );
        },
      )),
    );
  }

  _itemJobManager(BuildContext context, {JobModel? job}) {
    return Container(
      height: 195.h,
      width: 1.sw,
      margin: EdgeInsets.symmetric(vertical: 10.h),
      child: Stack(
        children: [
          Container(
            width: 1.sw,
          ),
          Positioned(
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(10),
              width: 1.sw,
              height: 150.h,
              decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    opacity: 0.2,
                    image: AssetImage(
                      'assets/images/jobs/effectFeature.png',
                    ),
                  ),
                  borderRadius: BorderRadius.circular(24.r),
                  color: HexColor("#BB2649")
                  // padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 24.w),
                  ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Icon(
                      Icons.edit_outlined,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 8.w,
                    ),
                    Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ]),
                  Row(
                    children: [
                      Radio(
                        fillColor: MaterialStatePropertyAll<Color>(
                            HexColor("#FFFFFF")),
                        activeColor: Colors.white,
                        focusColor: Colors.red,
                        visualDensity: VisualDensity.compact,
                        value: job!.jobId,
                        groupValue: _listSelected.contains(job.jobId)
                            ? job.jobId
                            : null,
                        onChanged: (value) {
                          setState(() {
                            if (_listSelected.contains(job.jobId) == true) {
                              print("a");
                              _listSelected.remove(job.jobId);
                            } else {
                              _listSelected.add(job.jobId.toString());
                            }
                          });
                          print(_listSelected);
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Positioned(
            right: 0,
            left: 0,
            bottom: 0,
            child: Container(
                width: 1.sw,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 25.w),
                margin: EdgeInsets.only(top: 17.h),
                // width: 1.sw,
                height: 150.h,
                // decoration: BoxDecoration(

                // ),
                child: Row(children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AvatarWidget(context, user: job?.users, radius: 22),
                      Text(
                        "${job?.users!.name}",
                        style:
                            textTheme.regular13(color: "#0D0D26", opacity: 0.6),
                      )
                    ],
                  ),
                  SizedBox(
                    width: 16.5.w,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 0.57.sw,
                        child: Text(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          "${job?.jobName}",
                          style: textTheme.sub14(),
                        ),
                      ),
                      Container(
                        width: 0.57.sw,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "💰 ${job?.wage}",
                              style: textTheme.medium12(),
                            ),
                            Text(
                              "💼 ${job?.categoryJob} - 🏭 ${job?.getCity}",
                              style: textTheme.regular13(
                                  color: "#0D0D26", opacity: 0.6),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      Row(
                        children: [
                          Text("Số đơn apply :  ${job.applied_count}",
                              style: textTheme.regular13(
                                  color: "#0D0D26", opacity: 0.6)),
                        ],
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MannagerApplyScreen(
                                        title: job.jobName.toString(),
                                        jobId: job.jobId.toString(),
                                      )));
                        },
                        child: Text("Xem chi tiết  → ",
                            style: textTheme.regular13(
                                color: "#0D0D26", opacity: 1)),
                      ),
                    ],
                  ),
                ])),
          ),
        ],
      ),
    );
  }
}
