import 'package:app_tim_kiem_viec_lam/core/models/jobs_model.dart';
import 'package:app_tim_kiem_viec_lam/widgets/item_job_horizal.dart';
import 'package:app_tim_kiem_viec_lam/widgets/item_job_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/jobs_provider.dart';

class JobBookMarkWidget extends StatefulWidget {
  const JobBookMarkWidget({super.key});

  @override
  State<JobBookMarkWidget> createState() => _JobBookMarkWidgetState();
}

class _JobBookMarkWidgetState extends State<JobBookMarkWidget> {
  late JobsProvider jobProvider;
  void initState() {
    jobProvider = Provider.of<JobsProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        child: FutureBuilder(
          future: jobProvider.getBookMarkJob(),
          builder: (context, snapshot) {
            List<JobModel> jobs = [];

            if (snapshot.hasData) {
              jobs = snapshot.data;
              return Wrap(
                alignment: WrapAlignment.center,
                children: [...jobs.map((e) => ItemJobWidget(job: e)).toList()],
              );
            } else {
              return Text("${snapshot.error}");
            }
          },
        ),
      ),
    );
  }
}
