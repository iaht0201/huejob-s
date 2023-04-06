import 'dart:convert';

class UserTypeModel {
  UserTypeModel({
    required this.id,
    required this.typeVi,
    required this.typeEn,
  });

  String id;

  String typeVi;
  String typeEn;
  factory UserTypeModel.fromJson(String str) =>
      UserTypeModel.fromMap(json.decode(str));
  factory UserTypeModel.fromMap(Map<String, dynamic> json) => UserTypeModel(
        id: json["id"],
        typeEn: json["typeen"],
        typeVi: json["typevi"],
      );
}
