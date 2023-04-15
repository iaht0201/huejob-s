import 'package:app_tim_kiem_viec_lam/core/models/jobs_model.dart';
import 'package:app_tim_kiem_viec_lam/core/providers/jobs_provider.dart';
import 'package:app_tim_kiem_viec_lam/screens/detailJob/detail_job.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/user_provider.dart';
import '../../../utils/constant.dart';
import '../../../widgets/item_job_horizal.dart';

class SearchJobWidget extends StatefulWidget {
  const SearchJobWidget({super.key, this.query});
  final String? query;

  @override
  State<SearchJobWidget> createState() => _SearchJobWidgetState();
}

class _SearchJobWidgetState extends State<SearchJobWidget> {
  late JobsProvider jobProvider;
  void initState() {
    super.initState();
    jobProvider = Provider.of<JobsProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: jobProvider.searchJob(widget.query.toString()),
      builder: (context, snapshot) {
        List<JobModel> listJob = [];
        if (snapshot.hasData) {
          listJob = snapshot.data;
          return Container(
            child: Column(
              children: [
                ...listJob
                    .map((e) => ItemJobHorizal(
                          job: e,
                        ))
                    .toList(),
              ],
            ),
          );
        } else {
          return Container(
            child: Column(
              children: [
                ...List.generate(
                    7,
                    (index) => Container(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            shimmerFromColor(height: 80.h, width: 1.sw)
                          ],
                        ))).toList()
              ],
            ),
          );
        }
      },
    );
  }
}
