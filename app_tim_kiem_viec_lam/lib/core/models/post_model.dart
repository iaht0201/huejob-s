import 'dart:convert';

import 'package:app_tim_kiem_viec_lam/core/models/user_model.dart';
import 'package:flutter/foundation.dart';

class PostModel {
  PostModel({
    this.postId,
    required this.userId,
    this.createAt,
    required this.caption,
    required this.imageurl,
    this.like_count,
    this.users,
    required this.category_job,
    required this.location,
    required this.latitude,
    required this.longitude,
  });

  int? postId;
  String userId;
  DateTime? createAt;
  String? caption;
  String imageurl;
  int? like_count;
  UserModel? users;
  String category_job;
  String location;
  double latitude;
  double longitude;
  Duration calculateDuration(DateTime now, DateTime createAt) {
    return now.difference(createAt);
  }

  // hàm tính thời gian trước
  get agoTime {
    String result;
    DateTime now = DateTime.now();
    Duration duration = calculateDuration(now, createAt!);
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

  get getCity {
    List<String> parts = location.split(",");
    if (parts.length > 2) {
      return parts[1].trim();
    } else {
      return;
    }
  }

  factory PostModel.fromJson(String str) => PostModel.fromMap(json.decode(str));
  factory PostModel.fromMap(Map<String, dynamic> json) => PostModel(
      postId: json["post_id"],
      userId: json["userId"],
      createAt: DateTime.parse(json["create_at"]),
      caption: json["caption"],
      imageurl: json["imageurl"],
      like_count: json["like_count"],
      users: UserModel.fromMap(json["users"]),
      category_job: json['category_job'],
      location: json['location'],
      longitude: json['longitude'],
      latitude: json['latitude']);

  // Map<String, dynamic> toMapNoImage(PostModel newPost) {
  //   return {
  //     'userId': userId,
  //     'caption': caption,
  //     'category_job': category_job,
  //     'location': location,
  //   };
  // }

  Map<String, dynamic> toMapHaveImage(PostModel newPost) {
    return {
      'userId': userId,
      'caption': caption,
      'category_job': category_job,
      'location': location,
      'imageurl': imageurl,
      'longitude': longitude,
      'latitude': latitude
    };
  }
}
