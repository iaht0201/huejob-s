import 'dart:convert';

import 'package:app_tim_kiem_viec_lam/core/models/jobsModel.dart';

class SearchJobModel {
  SearchJobModel({required this.title, required this.searchList});

  String title;
  List<JobModel> searchList;
}
