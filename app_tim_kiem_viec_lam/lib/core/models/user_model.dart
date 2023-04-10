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
  final List<ExperienceModel>? experience;
  final String? job;
  final String? fullname;
  final String? status;
  final String? usertype;
  final List<EducationModel>? education;
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
      this.status,
      this.usertype,
      this.education});

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
      experience: json['experience'] != null
          ? List<ExperienceModel>.from(
              json['experience'].map((x) => ExperienceModel.fromMap(x)))
          : null,
      education: json['education'] != null
          ? List<EducationModel>.from(
              json['education'].map((x) => EducationModel.fromMap(x)))
          : null,
      job: json['job'],
      status: json['status'],
      usertype: json['usertype'],
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
      'usertype': usertype
    };
  }
}

class EducationModel {
  final String schoolName;
  final String degree;
  final String fieldOfStudy;
  final String startDate;
  final String endDate;
  final String description;

  EducationModel({
    required this.schoolName,
    required this.degree,
    required this.fieldOfStudy,
    required this.startDate,
    required this.endDate,
    required this.description,
  });
  factory EducationModel.fromMap(Map<String, dynamic> json) => EducationModel(
        schoolName: json['schoolName'],
        degree: json['degree'],
        fieldOfStudy: json['fieldOfStudy'],
        startDate: json['startDate'],
        endDate: json['endDate'],
        description: json['description'],
      );

  Map<String, dynamic> toJson() {
    return {
      'schoolName': schoolName,
      'degree': degree,
      'fieldOfStudy': fieldOfStudy,
      'startDate': startDate,
      'endDate': endDate,
      'description': description,
    };
  }
}

class ExperienceModel {
  final String? jobTitle;
  final String? startDate;
  final String? endDate;
  final String? company_name;
  final String? description;

  ExperienceModel({
    this.jobTitle,
    this.startDate,
    this.endDate,
    this.company_name,
    this.description,
  });

  factory ExperienceModel.fromMap(Map<String, dynamic> json) => ExperienceModel(
        jobTitle: json['job_title'],
        startDate: json['start_date'],
        endDate: json['end_date'],
        company_name: json['company_name'],
        description: json['description'],
      );

  Map<String, dynamic> toMap() => {
        'job_title': jobTitle,
        'start_date': startDate,
        'end_date': endDate,
        'company_name': company_name,
        'description': description,
      };
}
