import 'package:app_tim_kiem_viec_lam/core/models/job_category_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/constant.dart';

class CareAboutWidget extends StatelessWidget {
  const CareAboutWidget({super.key, this.careAbout});
  final List<JobCategoryModel>? careAbout;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 5.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Các ngành quan tâm",
            style: textTheme.sub16(),
          ),
          SizedBox(
            height: 12.h,
          ),
          _popualarRoles(context, careAbout!)
        ],
      ),
    );
  }

  _popualarRoles(BuildContext context, List<JobCategoryModel> roles) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          careAbout!.isNotEmpty
              ? Container(
                  width: 1.sw,
                  child: Wrap(
                    spacing: 10.w,
                    children: [
                      ...roles.map((e) => GestureDetector(
                            onTap: () {},
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.w, horizontal: 10.w),
                              margin: EdgeInsets.only(bottom: 10.h),
                              child: Text(
                                "${e.jobName}",
                                style: textTheme.regular13(color: "000000"),
                              ),
                            ),
                          ))
                    ],
                  ))
              : Container(
                  width: 1.sw,
                  child: Wrap(spacing: 10.w, children: [
                    ...List.generate(9,
                        (index) => shimmerFromColor(width: 90.w, height: 30.h))
                  ]))
        ],
      ),
    );
  }
}
