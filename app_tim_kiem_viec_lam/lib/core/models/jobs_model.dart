import 'dart:convert';

import 'package:app_tim_kiem_viec_lam/core/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
  final UserModel? users;
  final String? wokringTime;
  final String? requirement;
  final double? latitude;
  final double? longitude;
  final int? applied_count;
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
    this.applied_count,
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
      applied_count: json['applied_count'],
      longitude: json['longitude'],
      latitude: json['latitude']);

  factory JobModel.fromMap1(Map<String, dynamic> json) => JobModel(
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
      longitude: json['longitude'],
      applied_count: json['applied_count'],
      latitude: json['latitude']);
  static Future<JobModel> fromJson1(
      Map<String, dynamic> json, SupabaseClient client) async {
    final response = await client
        .from('users')
        .select('*')
        .eq('userId', json['userId'])
        .single()
        .execute();
    final user = UserModel.fromMap(response.data);
    return JobModel(
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
        users: user,
        longitude: json['longitude'],
        latitude: json['latitude']);
  }

  get getCity {
    List<String> parts = location!.split(",");
    if (parts.length > 2) {
      return parts[1].trim();
    } else {
      return;
    }
  }

  Map<String, dynamic> toMapAddJob() {
    return {
      'wage': wage,
      'description': description,
      'userId': userId,
      'role': role,
      'job_name': jobName,
      'location': location,
      'category_job': categoryJob,
      'requirement': requirement,
      'working_time': wokringTime,
      'longitude': longitude,
      'latitude': latitude,
    };
  }
}
