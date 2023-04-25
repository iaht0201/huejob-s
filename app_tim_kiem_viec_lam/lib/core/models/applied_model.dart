import 'dart:convert';

import 'package:app_tim_kiem_viec_lam/core/models/user_model.dart';

class ApplyModel {
  ApplyModel(
      {this.jobAppliedId,
      required this.jobId,
      required this.userId,
      this.status,
      required this.note,
      this.applicationDate,
      this.fileUrl,
      this.users});

  String? jobAppliedId;
  String jobId;
  String userId;
  String? status;
  DateTime? applicationDate;
  String? note;
  String? fileUrl;
  final UserModel? users;
  factory ApplyModel.fromJson(String str) =>
      ApplyModel.fromMap(json.decode(str));
  factory ApplyModel.fromMap(Map<String, dynamic> json) => ApplyModel(
      jobAppliedId: json["apply_id"],
      jobId: json["job_id"],
      userId: json["user_id"],
      applicationDate: DateTime.parse(json["created_at"]),
      note: json["note"],
      status: json["status"],
      fileUrl: json["fileUrl"]);
  factory ApplyModel.fromMapWithUser(Map<String, dynamic> json) => ApplyModel(
      jobAppliedId: json["apply_id"],
      jobId: json["job_id"],
      userId: json["user_id"],
      applicationDate: DateTime.parse(json["created_at"]),
      note: json["note"],
      status: json["status"],
      users: UserModel.fromMap(json["users"]),
      fileUrl: json["fileUrl"]);
  Map<String, dynamic> toMap() {
    return {
      'job_id': jobId,
      'user_id': userId,
      'note': note,
      'status': status,
      'fileUrl': fileUrl
    };
  }
}
