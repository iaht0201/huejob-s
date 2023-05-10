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
  final String? status;
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
      this.users,
      this.requirement,
      this.wokringTime,
      this.latitude,
      this.longitude,
      this.applied_count,
      this.status});
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
      latitude: json['latitude'],
      status: json['status']);

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
      latitude: json['latitude'],
      status: json['status']);
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

  get isExpiration {
    DateTime now = DateTime.now();
    DateTime endOfDay = DateTime(
      now.year,
      now.month,
      now.day,
    );

    int nowMiliSecond = endOfDay.millisecondsSinceEpoch;
    DateTime dateTime = DateTime.parse(expirationDate.toString());
    int expiration = dateTime.millisecondsSinceEpoch;
    if (nowMiliSecond > expiration) {
      return true;
    } else
      return false;
  }

  get countExpiration {
    DateTime now = DateTime.now();
    DateTime endOfDay = DateTime(
      now.year,
      now.month,
      now.day,
    );

    int nowMiliSecond = endOfDay.millisecondsSinceEpoch;
    DateTime dateTime = DateTime.parse(expirationDate.toString());
    int expiration = dateTime.millisecondsSinceEpoch;
    if (nowMiliSecond < expiration) {
      int differenceInDays = (expiration - now.millisecondsSinceEpoch);
      return differenceInDays;
    }
  }

  Duration calculateDuration(DateTime now, DateTime createAt) {
    return now.difference(createAt);
  }

  // hàm tính thời gian trước
  get agoTime {
    String result;
    DateTime now = DateTime.now();
    DateTime _expirationDate = DateTime.parse(expirationDate.toString());
    Duration duration = calculateDuration(_expirationDate, now);
    int second = duration.inSeconds;
    if (second >= 0 && second <= 59) {
      result = "${duration.inSeconds}giây";
    } else if (second > 59 && second <= 3599) {
      result = "${duration.inMinutes}p";
    } else if (second > 3599 && second <= 86399) {
      result = "${duration.inHours} giờ";
    } else {
      result = "${duration.inDays} ngày";
    }

    return result;
  }

  Map<String, dynamic> toMapAddJob() {
    return {
      // 'job_id': jobId,
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
      'expiration_date': expirationDate,
      'status': status
    };
  }

  JobModel copyWith({
    String? jobId,
    String? wage,
    String? description,
    String? expirationDate,
    String? userId,
    String? role,
    String? jobName,
    String? location,
    String? categoryJob,
    String? wokringTime,
    String? requirement,
    double? latitude,
    double? longitude,
    String? status,
  }) {
    return JobModel(
      jobId: this.jobId,
      wage: wage ?? this.wage,
      description: description ?? this.description,
      expirationDate: expirationDate ?? this.expirationDate,
      userId: userId ?? this.userId,
      role: role ?? this.role,
      jobName: jobName ?? this.jobName,
      location: location ?? this.location,
      categoryJob: categoryJob ?? this.categoryJob,
      wokringTime: wokringTime ?? this.wokringTime,
      requirement: requirement ?? this.requirement,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      status: status ?? this.status,
    );
  }
}
