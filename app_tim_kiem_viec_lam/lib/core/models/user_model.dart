import 'dart:convert';

import 'package:meta/meta.dart';

class UserModel {
  final String? userId;
  final String? name;
  final String? imageUrl;
  final String? email;
  final String? birthday;
  final int? gender;
  final int? phone_number;
  final List<ExperienceModel>? experience;
  final AddressModel? address;
  final List<EducationModel>? education;
  final String? fullname;
  final String? status;
  final String? usertype;
  final String? firstname;
  final String? familyname;

  final String? caption;
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
      this.fullname,
      this.status,
      this.usertype,
      this.caption,
      this.familyname,
      this.firstname,
      this.education});

  factory UserModel.fromJson(String str) => UserModel.fromMap(json.decode(str));
  factory UserModel.fromMap(Map<String, dynamic> json) => UserModel(
        userId: json['userId'],
        name: json['name'],
        imageUrl: json['imageUrl'],
        email: json['email'],
        birthday: json['birthday'],
        gender: json['gender'],
        phone_number: json['phone_number'],
        caption: json['caption'],
        address: json['address'] != null ? jsonDecode(json['address']) : null,
        // address: json['address'] != null
        //     ? List<AddressModel>.from(jsonDecode(json['address'])
        //         .map((address) => AddressModel.fromMap(address)))
        //     : null,
        experience: json['experience'] != null
            ? List<ExperienceModel>.from(jsonDecode(json['experience']).map(
                (experienceJson) => ExperienceModel.fromMap(experienceJson)))
            : null,
        education: json['education'] != null
            ? List<EducationModel>.from(jsonDecode(json['education'])
                .map((education) => EducationModel.fromMap(education)))
            : null,
        status: json['status'],
        usertype: json['usertype'],
        fullname: json['fullname'],
        firstname: json['firstName'],
        familyname: json['familyName'],
      );
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
      'familyName': familyname,
      'firstName': firstname,
      'birthday': birthday,
      'gender': gender,
      'address': json.encode(address?.toMap()),
      'phone_number': phone_number,
      'fullname': fullname,
      'status': status,
      'usertype': usertype,
      'experience': experience != null
          ? jsonEncode(List<dynamic>.from(experience!.map((e) => e.toMap())))
          : null,
      'education': education != null
          ? jsonEncode(List<dynamic>.from(education!.map((e) => e.toJson())))
          : null,
    };
  }
}

class EducationModel {
  final String? schoolName;
  final String? degree;
  final String? fieldOfStudy;
  final String? startDate;
  final String? endDate;
  final String? description;
  EducationModel({
    this.schoolName,
    this.degree,
    this.fieldOfStudy,
    this.startDate,
    this.endDate,
    this.description,
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

class AddressModel {
  final String? addressName;
  final double? longitude;
  final double? latitude;
  AddressModel({this.addressName, this.latitude, this.longitude});
  factory AddressModel.fromMap(Map<String, dynamic> json) => AddressModel(
        addressName: json['address_name'],
        longitude: json['longitude'],
        latitude: json['latitude'],
      );

  Map<String, dynamic> toMap() => {
        'address_name': addressName,
        'longitude': longitude,
        'latitude': latitude,
      };
}
