import 'dart:convert';

import 'package:app_tim_kiem_viec_lam/core/models/user_model.dart';

class JobModel {
  final String? jobId;
  final String? wage;
  final String? description;
  final String? createdAt;
  final String? expirationDate;
  final String? userId;
  final String? role;
  final String? jobName;
  final String? location;
  final String? categoryJob;
  UserModel? users;

  JobModel(
      {this.jobId,
      this.wage,
      this.description,
      this.createdAt,
      this.expirationDate,
      this.userId,
      this.role,
      this.jobName,
      this.location,
      this.categoryJob,
      this.users});
  factory JobModel.fromJson(String str) => JobModel.fromMap(json.decode(str));
  factory JobModel.fromMap(Map<String, dynamic> json) => JobModel(
        jobId: json['job_id'],
        wage: json['wage'],
        description: json['description'],
        createdAt: json['created_at'],
        expirationDate: json['expiration_date'],
        userId: json['userId'],
        role: json['role'],
        jobName: json['job_name'],
        location: json['location'],
        categoryJob: json['category_job'],
        users: UserModel.fromMap(json["users"]),
      );
}
