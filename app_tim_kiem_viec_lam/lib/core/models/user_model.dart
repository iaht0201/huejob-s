import 'dart:convert';

import 'package:meta/meta.dart';

class UserModel {
  final String? user_id;
  final String? name;
  final String? imageUrl;
  final String? email;
  final DateTime? birthday;
  final int? gender;
  final String? address;
  final int? phone_number;
  final String? experience;
  final String? education;

  final String? status;
  const UserModel(
      {this.user_id,
      this.name,
      this.imageUrl,
      this.email,
      this.birthday,
      this.gender,
      this.address,
      this.phone_number,
      this.experience,
      this.education,
      this.status});
  factory UserModel.fromJson(String str) => UserModel.fromMap(json.decode(str));
  factory UserModel.fromMap(Map<String, dynamic> json) => UserModel(
        user_id: json['user_id'],
        name: json['name'],
        imageUrl: json['imageUrl'],
        email: json['email'],
        birthday: json['birthday'],
        gender: json['gender'],
        address: json['address'],
        phone_number: json['phone_number'],
        experience: json['experience'],
        education: json['education'],
        status: json['status'],
      );
}
