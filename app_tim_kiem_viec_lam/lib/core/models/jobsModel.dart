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
  final String? wokringTime;
  final String? requirement;
  final double? latitude;
  final double? longitude;
  JobModel({
    this.jobId,
    this.wage,
    this.description,
    this.createdAt,
    this.expirationDate,
    this.userId,
    this.role,
    this.jobName,
    this.location,
    this.categoryJob,
    this.users,
    this.requirement,
    this.wokringTime,
    this.latitude,
    this.longitude,
  });
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
      requirement: json['requirement'],
      wokringTime: json['working_time'],
      users: UserModel.fromMap(json["users"]),
      longitude: json['longitude'],
      latitude: json['latitude']
      
      );
}
