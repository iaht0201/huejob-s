import 'package:app_tim_kiem_viec_lam/core/models/jobs_model.dart';
import 'package:app_tim_kiem_viec_lam/widgets/item_job_horizal.dart';
import 'package:app_tim_kiem_viec_lam/widgets/item_job_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/jobs_provider.dart';
import '../../../utils/constant.dart';

class JobBookMarkWidget extends StatefulWidget {
  const JobBookMarkWidget({super.key});

  @override
  State<JobBookMarkWidget> createState() => _JobBookMarkWidgetState();
}

class _JobBookMarkWidgetState extends State<JobBookMarkWidget> {
  late JobsProvider jobProvider;
  bool isLoading = false;
  void initState() {
    jobProvider = Provider.of<JobsProvider>(context, listen: false);
    super.initState();
    jobProvider.getBookMarkJob().whenComplete(() {
      setState(() {
        isLoading = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: false,
        bottom: false,
        child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(horizontal: 20.w),
          child: Builder(
            builder: (context) {
              return CustomScrollView(
                slivers: [
                  SliverOverlapInjector(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                        context),
                  ),
                  SliverGrid(
                      delegate: SliverChildListDelegate([
                        ...jobProvider.listBookmark
                            .map((e) => ItemJobWidget(job: e))
                            .toList()
                      ]),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2)),
                ],
              );
            },
          ),
        ));
  }
}
