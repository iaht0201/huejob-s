import 'dart:convert';

class LikesModel {
  LikesModel({
    required this.likeId,
    required this.postId,
    required this.userId,
    required this.createAt,
  });

  int likeId;
  int postId;
  String userId;
  DateTime createAt;
  factory LikesModel.fromJson(String str) =>
      LikesModel.fromMap(json.decode(str));
  factory LikesModel.fromMap(Map<String, dynamic> json) => LikesModel(
        likeId: json["like_id"],
        postId: json["post_id"],
        userId: json["user_id"],
        createAt: DateTime.parse(json["create_at"]),
      );
}
