import 'package:app_tim_kiem_viec_lam/core/models/user_model.dart';
import 'package:app_tim_kiem_viec_lam/core/providers/userProvider.dart';
import 'package:app_tim_kiem_viec_lam/core/supabase/supabase.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/jobCategory_model.dart';
import '../models/jobsModel.dart';

class JobsProvider extends ChangeNotifier {
  SupabaseClient _supbase = SupabaseBase.supabaseClient;

  List<JobsProvider> _listViewedJob = [];
  List<JobsProvider> get listViewedJob => _listViewedJob;
  set setListViewedJob(value) {
    _listViewedJob = value;
  }

  Future fetchFeaturedJobs(String job) async {
    var respon = await _supbase
        .from("jobs")
        .select("*,users(*)")
        .eq('category_job', 'Lập trình viên')
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

  Future fetchRolesJob(String job) async {
    var respon = await _supbase
        .from("jobs")
        .select("*,users(*)")
        .eq('category_job', '${job}')
        .limit(20)
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

  // Gợi ý theo nghề nghiệp và vị trí
  Future fetchRecommendJobs() async {
    var respon = await _supbase
        .from("jobs")
        .select("*,users(*)")
        // .eq('category_job', 'Công nghệ thông tin')
        // .eq('users.address', user.address)
        .limit(10)
        .order('created_at', ascending: true)
        .execute();
    if (respon.data != null) {
      var data = respon.data;
      List<JobModel> _listJobs = [];

      for (int i = 0; i < data.length; i++) {
        _listJobs.add(JobModel.fromMap(data[i]));
      }
      return _listJobs;
    }
    notifyListeners();
  }

  Future fetchJobother() async {
    var respon = await _supbase
        .from("jobs")
        .select("*,users(*)")
        .limit(15)
        .order('created_at', ascending: true)
        .execute();
    if (respon.data != null) {
      var data = respon.data;
      List<JobModel> _listJobs = [];
      for (int i = 0; i < data.length; i++) {
        _listJobs.add(JobModel.fromMap(data[i]));
      }
      return _listJobs;
    }
    notifyListeners();
  }

  JobModel _jobById = JobModel();
  JobModel get jobById => _jobById;
  Future getJobById(String id) async {
    _jobById = new JobModel();
    var respon = await _supbase
        .from("jobs")
        .select("*,users(*)")
        .eq('job_id', id)
        .execute();
    if (respon.data != null) {
      var data = respon.data;
      _jobById = JobModel.fromMap(data[0]);
      print(_jobById);
    }
    notifyListeners();
  }

  Future fetchPopularRoles({int limit = 100}) async {
    final response = await SupabaseBase.supabaseClient
        .from('jobcategory')
        .select('*')
        .limit(limit)
        .order("jobcategoryid", ascending: true)
        .execute();

// Bổ sung thêm hàm count đếm xem có bao nhiêu job với roles đó
    if (response.data != null) {
      final List<JobCategoryModel> _roles = [];
      var data = await response.data;
      for (int i = 0; i < data.length; i++) {
        _roles.add(JobCategoryModel.fromMap(data[i]));
      }
      return _roles;
    }

    notifyListeners();
  }

  Future<List<JobModel>> searchJob(String name) async {
    final respon = await _supbase
        .from('jobs')
        .select("*,users(*)")
        .textSearch('job_name', '%${name}%',
            config: 'english ', type: TextSearchType.websearch)
        .limit(100)
        .execute();
    if (respon.data == null) {
      print(respon.status);
    }
    var data = respon.data;
    List<JobModel> _listJobs = [];

    for (int i = 0; i < data.length; i++) {
      _listJobs.add(JobModel.fromMap(data[i]));
    }
    print("jobs ${_listJobs}");
    return _listJobs;
  }
}
