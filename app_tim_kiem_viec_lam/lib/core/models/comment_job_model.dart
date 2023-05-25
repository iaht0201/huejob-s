import 'package:app_tim_kiem_viec_lam/core/models/user_model.dart';
import 'package:app_tim_kiem_viec_lam/core/supabase/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CommentJobModel {
  final String id;
  final String content;
  final String userFrom;
  final String userTo;
  final DateTime createAt;
  final String? username;
  final String jobId;
  final String? imageUrl;

  CommentJobModel(
      {required this.id,
      required this.content,
      required this.userFrom,
      required this.userTo,
      required this.createAt,
      required this.jobId,
      this.username,
      this.imageUrl});

  CommentJobModel.create(
      {required this.content,
      required this.userFrom,
      required this.userTo,
      this.imageUrl,
      this.username,
      required this.jobId})
      : id = '',
        createAt = DateTime.now();

  CommentJobModel.fromJson(Map<String, dynamic> json, String userId)
      : id = json['id'],
        content = json['content'],
        userFrom = json['user_from'],
        userTo = json['user_to'],
        createAt = DateTime.parse(json['created_at']),
        jobId = json['job_id'],
        imageUrl = json['imageUrl'],
        username = json['username'];

  Map toMap() {
    return {
      'content': content,
      'user_from': userFrom,
      'user_to': userTo,
      'job_id': jobId,
    };
  }
}
