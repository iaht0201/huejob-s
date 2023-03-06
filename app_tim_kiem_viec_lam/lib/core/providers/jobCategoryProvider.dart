import 'package:app_tim_kiem_viec_lam/core/models/jobCategory_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/post_model.dart';
import '../supabase/supabase.dart';

class JobCategory extends ChangeNotifier {
  List<JobCategoryModel> _jobs = [];
  List<JobCategoryModel> get jobs => _jobs;
  JobCategoryModel? _selectedOption;
  JobCategoryModel? get selectedOption => _selectedOption;
  set setSelectedOption(value) {
    _selectedOption = value;
    notifyListeners();
  }

  Future getJobCategory() async {
    final response = await SupabaseBase.supabaseClient
        .from('jobcategory')
        .select('*').order("jobcategoryid" , ascending: true)
        .execute();

    if (response.data != null) {
      _jobs.clear();
      var data = await response.data;
      for (int i = 0; i < data.length; i++) {
        _jobs.add(JobCategoryModel.fromMap(data[i]));
      }
    }

    notifyListeners();
  }
}
