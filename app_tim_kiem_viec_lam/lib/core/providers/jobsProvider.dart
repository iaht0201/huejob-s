import 'package:app_tim_kiem_viec_lam/core/supabase/supabase.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/jobsModel.dart';

class JobsProvider extends ChangeNotifier {
  SupabaseClient _supbase = SupabaseBase.supabaseClient;
  Future fetchFeaturedJobs(String job) async {
    var respon = await _supbase
        .from("jobs")
        .select("*,users(*)")
        .eq('category_job', 'Công nghệ thông tin')
        .limit(5)
        .order('created_at', ascending: true)
        .execute();
    if (respon.data != null) {
      var data = respon.data;
      List<JobModel> _listFeaturJob = [];

      for (int i = 0; i < data.length; i++) {
        _listFeaturJob.add(JobModel.fromMap(data[i]));
      }
      return _listFeaturJob;
    }
    notifyListeners();
  }
}
