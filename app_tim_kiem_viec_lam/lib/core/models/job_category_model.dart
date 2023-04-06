import 'dart:convert';

import 'package:meta/meta.dart';

class JobCategoryModel {
  final int? id;
  final String? jobName;

  const JobCategoryModel({
    this.id,
    this.jobName,
  });
  factory JobCategoryModel.fromJson(String str) =>
      JobCategoryModel.fromMap(json.decode(str));
  factory JobCategoryModel.fromMap(Map<String, dynamic> json) => JobCategoryModel(
        id: json['jobcategoryid'],
        jobName: json['jobname'],
      );

  get name => null;

  Map<String, dynamic> toMap() {
    return {
      'jobcategoryid': id,
      'jobname': jobName,
    };
  }
}
