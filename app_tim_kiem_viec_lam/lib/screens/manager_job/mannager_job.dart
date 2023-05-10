import 'package:app_tim_kiem_viec_lam/screens/add_job/add_job.dart';
import 'package:app_tim_kiem_viec_lam/screens/manager_job/widgets/test.dart';
import 'package:app_tim_kiem_viec_lam/widgets/item_job_horizal.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
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
  final List<String> items = [
    'Tất cả',
    'Thời gian đăng gần nhất',
    'Thời gian đăng xa nhất',
    'Job hot',
  ];
  String? selectedValueFiltter;
  late JobsProvider jobProvider;
  List<JobModel> _listJobRecruiter = [];
  List<String> _listSelected = [];
  List<JobModel> selectedJobs = [];
  List<JobModel> jobs = [];
  List<String> _hagtag = ["Tất cả", "Chưa hết hạn", "Đã hết hạn"];
  String selectedValue = "Tất cả";
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
            margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    ..._hagtag.asMap().entries.map(
                          (e) => _hagtagFillerJobItem(context, e.value, e.key),
                        ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    DropdownButtonHideUnderline(
                      child: DropdownButton2(
                        hint: Text(
                          'Tất cả',
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                        items: items
                            .map((item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ))
                            .toList(),
                        value: selectedValueFiltter,
                        onChanged: (value) {
                          setState(() {
                            selectedValueFiltter = value as String;
                          });
                        },
                        // buttonStyleData: const ButtonStyleData(
                        //   height: 40,
                        //   width: 140,
                        // ),
                        // menuItemStyleData: const MenuItemStyleData(
                        //   height: 40,
                        // ),
                      ),
                    ),
                  ],
                ),
                FutureBuilder(
                  future:
                      jobProvider.fetchJobByRecruiter(action: selectedValue),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        jobs = snapshot.data;
                        return Column(
                          children: [
                            ...jobs.map((e) => _itemJobManager(context,
                                job: e, type: selectedValue))
                          ],
                        );
                      } else {
                        return Text('Chưa có job nào $selectedValue');
                      }
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                ),
              ],
            ),
          );
        },
      )),
    );
  }

  _itemJobManager(BuildContext context, {JobModel? job, String? type}) {
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
                  color: job!.isExpiration == false
                      ? HexColor("#BB2649")
                      : HexColor("#95969D")
                  // padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 24.w),
                  ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddJobScreen(
                                      jobId: job.jobId,
                                      title: job.jobName.toString(),
                                    )));
                      },
                      child: Icon(
                        Icons.edit_outlined,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: 8.w,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (job.applied_count != 0) {
                          _showDialogWarningDeleteJob(context, id: job.jobId);
                        } else {
                          _showDialogDeleteJob(context, id: job.jobId);
                        }
                      },
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
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

  _hagtagFillerJobItem(BuildContext context, String type, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedValue = type;
        });
      },
      child: Container(
        // width: 100.w,
        margin: EdgeInsets.symmetric(horizontal: 10.w),
        // height: 40.h,
        decoration: BoxDecoration(
          color: selectedValue == type ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8.r),
          // image: DecorationImage(
          //     fit: BoxFit.fill,
          //     opacity: 0.8,
          //     image: AssetImage("assets/images/bg_hagtag.jpg"))
        ),
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
        child: Text(
          "$type",
          style: textTheme.medium14(color: "000000"),
        ),
      ),
    );
  }

  void _showDialogWarningDeleteJob(BuildContext context, {String? id}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cảnh báo'),
          content: Text('Job này hiện có người apply bạn có muốn xóa'),
          actions: <Widget>[
            Row(
              children: [
                TextButton(
                  child: Text('Đóng'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Tiếp tục'),
                  onPressed: () {
                    setState(() {
                      jobs.removeWhere((element) => element.jobId == id);
                    });

                    jobProvider.deleteJob(context, id.toString());
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _showDialogDeleteJob(BuildContext context, {String? id}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cảnh báo'),
          content: Text('Bạn chắc chắn muốn xóa job này!'),
          actions: <Widget>[
            Row(
              children: [
                TextButton(
                  child: Text('Đóng'),
                  onPressed: () {
                    // jobProvider.deleteJob(context, id.toString());
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Tiếp tục'),
                  onPressed: () {
                    setState(() {
                      jobs.removeWhere((element) => element.jobId == id);
                    });

                    jobProvider.deleteJob(context, id.toString());
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
