import 'package:app_tim_kiem_viec_lam/core/models/applied_model.dart';
import 'package:app_tim_kiem_viec_lam/screens/applyJob/apply_job.dart';
import 'package:app_tim_kiem_viec_lam/screens/manager_job/widgets/document.dart';
import 'package:app_tim_kiem_viec_lam/widgets/avatar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../../core/providers/jobs_provider.dart';
import '../../utils/constant.dart';
import '../profile/widgets/button_arrow.dart';
import 'package:path/path.dart' as p;

class MannagerApplyScreen extends StatefulWidget {
  const MannagerApplyScreen(
      {Key? key, required this.title, required this.jobId})
      : super(key: key);
  final String title;
  final String jobId;
  @override
  _MannagerApplyScreenState createState() => _MannagerApplyScreenState();
}

class _MannagerApplyScreenState extends State<MannagerApplyScreen> {
  late JobsProvider jobProvider;
  void initState() {
    super.initState();
    jobProvider = Provider.of<JobsProvider>(context, listen: false);
    jobProvider.fetApplyJob(widget.jobId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor("#FFFFFF"),
        elevation: 0,
        leading: buttonArrow(context),
        title: Text(
          "${widget.title}",
          style: textTheme.semibold16(color: "#000000"),
        ),
      ),
      body: SingleChildScrollView(child: Consumer<JobsProvider>(
        builder: (context, jobProvider, _) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: Column(
              children: [
                ...jobProvider.listApply
                    .map((e) => _itemApplyJob(context, applied: e))
              ],
            ),
          );
        },
      )),
    );
  }

  IconData iconFile(file) {
    String icon = file.extension;
    switch (icon) {
      case 'pdf':
        return Icons.picture_as_pdf_outlined;

      default:
        return Icons.description;
    }
  }

  _itemApplyJob(BuildContext context, {required ApplyModel applied}) {
    Uri uri = Uri.parse('${applied.fileUrl}');
    String fileName = p.basename(uri.path);
    print(fileName);
    return Stack(
      children: [
        Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(bottom: 20.h),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                    style: BorderStyle.solid, color: HexColor("#BB2649")),
                borderRadius: BorderRadius.circular(10.r)),
            height: 180.h,
            // color: Colors.red,
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AvatarWidget(context, user: applied.users, radius: 30.r),
                    SizedBox(
                      width: 8.w,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${applied.users!.name}",
                          style: textTheme.regular16(),
                        ),
                        Text(
                          "Trạng thái: Đang chờ",
                          style: textTheme.regular13(
                              color: "0D0D26", opacity: 0.7),
                        ),
                        Text(
                          "Ghi chú: ${applied.note}",
                          style: textTheme.regular13(
                              color: "0D0D26", opacity: 0.7),
                        ),
                      ],
                    ),
                    Spacer(),
                    TextButton(
                        onPressed: () {}, child: Text("Cập nhập trạng thái")),

                    // Text(
                    //   "${applied.users!.name}",
                    //   style: textTheme.regular16(),
                    // )
                  ],
                ),
                SizedBox(
                  height: 12.h,
                ),
                GestureDetector(
                  onTap: () {
                    print("a");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DocumentApply(
                                  urlFile: applied.fileUrl.toString(),
                                  title: fileName,
                                )));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: HexColor("#BB2649").withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12.r)),
                    alignment: Alignment.center,
                    width: 286.w,
                    height: 73.h,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Row(
                        children: [
                          Icon(Icons.picture_as_pdf),
                          SizedBox(
                            width: 5.w,
                          ),
                          Text(fileName)
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )),
      ],
    );
  }
}
