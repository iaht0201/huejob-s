import 'dart:convert';

class BookMarkModel {
  BookMarkModel({
    required this.bookmark_id,
    required this.postId,
    required this.userId,
    required this.createAt,
  });

  int bookmark_id;
  int postId;
  String userId;
  DateTime createAt;
  factory BookMarkModel.fromJson(String str) =>
      BookMarkModel.fromMap(json.decode(str));
  factory BookMarkModel.fromMap(Map<String, dynamic> json) => BookMarkModel(
        bookmark_id: json["bookmark_id"],
        postId: json["post_id"],
        userId: json["userId"],
        createAt: DateTime.parse(json["create_at"]),
      );
}
