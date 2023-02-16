import 'dart:convert';

import 'package:app_tim_kiem_viec_lam/core/models/user_model.dart';

class PostModel {
  PostModel({
    required this.postId,
    required this.userId,
    required this.createAt,
    required this.caption,
    required this.imageurl,
    required this.like_count,
    required this.users,
    
  });

  int postId;
  String userId;
  DateTime createAt;
  String caption;
  String imageurl;
  int like_count;
  UserModel users;
  Duration calculateDuration(DateTime now, DateTime createAt) {
    return now.difference(createAt);
  }

  // hàm tính thời gian trước
  get agoTime {
    String result;
    DateTime now = DateTime.now();
    Duration duration = calculateDuration(now, createAt);
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

  factory PostModel.fromJson(String str) => PostModel.fromMap(json.decode(str));
  factory PostModel.fromMap(Map<String, dynamic> json) => PostModel(
        postId: json["post_id"],
        userId: json["user_id"],
        createAt: DateTime.parse(json["create_at"]),
        caption: json["caption"],
        imageurl: json["imageurl"],
        like_count: json["like_count"],
        users: UserModel.fromMap(json["users"]),
      );
}
