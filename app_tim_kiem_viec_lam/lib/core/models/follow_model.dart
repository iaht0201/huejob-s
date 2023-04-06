import 'dart:convert';

class FollowModel {
  FollowModel({
    required this.followid,
    required this.userId,
    required this.following_id,
    required this.follow_date,
  });

  int followid;
  String userId;
  String following_id;
  DateTime follow_date;
  factory FollowModel.fromJson(String str) =>
      FollowModel.fromMap(json.decode(str));
  factory FollowModel.fromMap(Map<String, dynamic> json) => FollowModel(
        followid: json["followid"],
        following_id: json["following_id"],
        userId: json["userId"],
        follow_date: DateTime.parse(json["follow_date"]),
      );
}
