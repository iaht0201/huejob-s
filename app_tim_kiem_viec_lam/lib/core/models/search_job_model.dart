import 'dart:convert';

import 'package:app_tim_kiem_viec_lam/core/models/jobs_model.dart';

class SearchJobModel {
  SearchJobModel(
      {this.name,
      this.email,
      this.phone_number,
      this.firstname,
      this.familyname,
      this.jobs,
      this.userId});
  final String? userId;
  final String? name;
  final String? email;
  final int? phone_number;
  final String? firstname;
  final String? familyname;
  final List<JobModel>? jobs;
  factory SearchJobModel.fromMap(Map<String, dynamic> json) => SearchJobModel(
      name: json['name'],
      email: json['email'],
      phone_number: json['phone_number'],
      firstname: json['firstname'],
      familyname: json['familyname'],
      jobs: List<JobModel>.from(
          json['jobs'].map((job) => JobModel.fromJson(job))));
}
