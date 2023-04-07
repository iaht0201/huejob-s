import 'dart:convert';

class ApplyModel {
  ApplyModel({
    this.jobAppliedId,
    required this.jobId,
    required this.userId,
    this.status,
    required this.note,
    this.applicationDate,
    this.fileUrl,
  });

  String? jobAppliedId;
  String jobId;
  String userId;
  String? status;
  DateTime? applicationDate;
  String? note;
  String? fileUrl;
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
