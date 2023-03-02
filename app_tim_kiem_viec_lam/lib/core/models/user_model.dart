import 'dart:convert';

import 'package:meta/meta.dart';

class UserModel {
  final String? userId;
  final String? name;
  final String? imageUrl;
  final String? email;
  final String? birthday;
  final int? gender;
  final String? address;
  final int? phone_number;
  final String? experience;
  final String? job;
  final String? fullname;
  final String? status;
  const UserModel(
      {this.userId,
      this.name,
      this.imageUrl,
      this.email,
      this.birthday,
      this.gender,
      this.address,
      this.phone_number,
      this.experience,
      this.job,
      this.fullname,
      this.status});
  factory UserModel.fromJson(String str) => UserModel.fromMap(json.decode(str));
  factory UserModel.fromMap(Map<String, dynamic> json) => UserModel(
      userId: json['userId'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      email: json['email'],
      birthday: json['birthday'],
      gender: json['gender'],
      address: json['address'],
      phone_number: json['phone_number'],
      experience: json['experience'],
      job: json['job'],
      status: json['status'],
      fullname: json['fullname']);
  get getGender {
    if (gender == 1) {
      return "Nữ";
    } else if (gender == 2) {
      return "Nam";
    } else {
      return "Khác";
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'imageUrl': imageUrl,
      'email': email,
      'birthday': birthday,
      'gender': gender,
      'address': address,
      'phone_number': phone_number,
      'job': job,
      'fullname': fullname,
      'status': status,
    };
  }
}
