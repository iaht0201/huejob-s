import 'package:app_tim_kiem_viec_lam/core/models/applied_model.dart';
import 'package:app_tim_kiem_viec_lam/core/models/user_model.dart';
import 'package:app_tim_kiem_viec_lam/core/providers/user_provider.dart';
import 'package:app_tim_kiem_viec_lam/core/supabase/supabase.dart';
import 'package:app_tim_kiem_viec_lam/data/home/featureJobsData.dart';
import 'package:app_tim_kiem_viec_lam/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/job_category_model.dart';
import '../models/jobs_model.dart';
import '../models/search_job_model.dart';

class JobsProvider extends ChangeNotifier {
  SupabaseClient _supbase = SupabaseBase.supabaseClient;

  List<JobsProvider> _listViewedJob = [];
  List<JobsProvider> get listViewedJob => _listViewedJob;
  List<JobModel> listJobsSearch = [];

  get newUser => null;

  set setListViewedJob(value) {
    _listViewedJob = value;
  }

  Future<void> fetchCategorySearchJob() async {
    //  Lam xong hagtag lựa chọn chủ đè muốn quan tâm => eq chủ đề đó
    var respon =
        await _supbase.from("jobs").select("*,users(*)").limit(50).execute();
    if (respon.data != null) {
      var data = respon.data;
      List<JobModel> _listJobs = [];

      for (int i = 0; i < data.length; i++) {
        _listJobs.add(JobModel.fromMap(data[i]));
      }
      listJobsSearch = _listJobs;
    }
    notifyListeners();
  }

// Dan loi
  Future fetchFeaturedJobs(UserModel user) async {
    List<JobModel> _listFeaturJob = [];
    for (int i = 0; i < user.careAbout!.length; i++) {
      var respon = await _supbase
          .from("jobs")
          .select("*,users(*)")
          .eq('category_job', "${user.careAbout?[i].jobName}")
          .limit(5)
          .order('created_at', ascending: true)
          .execute();
      if (respon.data != null && respon.data.isNotEmpty) {
        var data = respon.data;
        for (int i = 0; i < data.length; i++) {
          _listFeaturJob.add(JobModel.fromMap(data[i]));
        }
      }
    }
    print(_listFeaturJob);
    notifyListeners();
    return _listFeaturJob;
  }

  // fetch danh sach job da dang

  List<JobModel> get listJobRecruiter => _listJobRecruiter;
  List<JobModel> _listJobRecruiter = [];
  Future fetchJobByRecruiter({String action = "Tất cả"}) async {
    List<JobModel> _listJobRecruiter1 = [];
    _listJobRecruiter1.clear();
    final prefs = await SharedPreferences.getInstance();
    var respon;
    switch (action) {
      case "Đã hết hạn":
        respon = await _supbase
            .from("jobs")
            .select("*,users(*)")
            .eq('userId', '${prefs.getString('id')}')
            .lt('expiration_date', DateTime.now().toUtc())
            .order('applied_count', ascending: false)
            .execute();
        break;
      case "Chưa hết hạn":
        respon = await _supbase
            .from("jobs")
            .select("*,users(*)")
            .eq('userId', '${prefs.getString('id')}')
            .gte('expiration_date', DateTime.now().toUtc())
            .order('applied_count', ascending: false)
            .execute();
        break;
      default:
        respon = await _supbase
            .from("jobs")
            .select("*,users(*)")
            .eq('userId', '${prefs.getString('id')}')
            .order('applied_count', ascending: false)
            .execute();
        break;
    }

    if (respon.data != null) {
      var data = respon.data;

      for (int i = 0; i < data.length; i++) {
        _listJobRecruiter1.add(JobModel.fromMap(data[i]));
      }
      return _listJobRecruiter1;
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

  List<JobCategoryModel> _roleJob = [];
  List<JobCategoryModel> get getRoleJob => _roleJob;
  Future fetchPopularRoles({int limit = 100}) async {
    final response = await SupabaseBase.supabaseClient
        .from('jobcategory')
        .select('*')
        .limit(limit)
        .execute();

// Bổ sung thêm hàm count đếm xem có bao nhiêu job với roles đó
    if (response.data != null) {
      final List<JobCategoryModel> _roles = [];
      var data = await response.data;
      for (int i = 0; i < data.length; i++) {
        _roles.add(JobCategoryModel.fromMap(data[i]));
      }
      _roleJob = _roles;
      // return _roles;
    }
    notifyListeners();
  }

  Future searchJob(String query) async {
    final result = await _supbase
        .rpc('jobs_search_ver1', params: {'search': '${query}'}).execute();
    if (result.data == null) {
      print(result.status);
    }
    List<JobModel> _listJobs = [];
    var data = result.data;
    for (int i = 0; i < data.length; i++) {
      final jobModel = await JobModel.fromJson1(data[i], _supbase);
      _listJobs.add(jobModel);
    }
    return _listJobs;
  }

  Future<void> updateJob(BuildContext context, JobModel newJob) async {
    try {
      final response = await SupabaseBase.supabaseClient
          .from("jobs")
          .update(newJob.toMapAddJob())
          .eq('job_id', newJob.jobId)
          .execute();
      if (response != null) {
        Fluttertoast.showToast(
          msg: 'Cập nhập job thành công!',
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (BuildContext context) => HomePage()),
        );
        notifyListeners();
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Cập nhập job thất bại!',
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  Future<void> insertJob(BuildContext context, JobModel newJob) async {
    try {
      final response = await SupabaseBase.supabaseClient
          .from("jobs")
          .insert(newJob.toMapAddJob())
          .execute();
      if (response != null) {
        Fluttertoast.showToast(
          msg: 'Đăng bài tuyển dụng thành công !',
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (BuildContext context) => HomePage()),
        );
        notifyListeners();
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Đăng tuyển dụng thất bại, vui lòng thử lại sau!',
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  // Apply
  List<ApplyModel> _listApply = [];
  get listApply => _listApply;
  Future fetApplyJob(String jobId) async {
    _listApply.clear();
    var respon = await _supbase
        .from("applyjob")
        .select("*,users(*)")
        .eq('job_id', jobId)
        .execute();
    if (respon.data != null && respon.data.isNotEmpty) {
      var data = respon.data;
      for (int i = 0; i < data.length; i++) {
        _listApply.add(ApplyModel.fromMapWithUser(data[i]));
      }
    }
    print(_listApply);
    notifyListeners();
  }

  Future cancelApply(
      BuildContext context, String userApplyId, String jobId) async {
    await _supbase
        .from("applyjob")
        .delete()
        .eq('job_id', jobId)
        .eq('user_id', userApplyId)
        .execute();

    Fluttertoast.showToast(
      msg: 'Hủy thành công',
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
  }

  Future<void> inserApplyJob(BuildContext context, ApplyModel newApply) async {
    bool _checkApply = false;
    try {
      final response = await SupabaseBase.supabaseClient
          .from("applyjob")
          .insert(newApply.toMap())
          .execute();
      if (response != null) {
        Fluttertoast.showToast(
          msg: 'Ứng tuyển thành công',
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        _checkApply = true;
        Navigator.pop(context, _checkApply);
        notifyListeners();
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: '${e}',
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  Future<bool> checkIsApplyJob(JobModel job, UserModel userApply) async {
    final prefs = await SharedPreferences.getInstance();
    final response = await _supbase
        .from("applyjob")
        .select("*")
        .eq('job_id', job.jobId)
        .eq('user_id', prefs.getString('id'));
    if (response.isEmpty) {
      return false;
    }
    return true;
  }

  // bookmark
  Future<bool> checkIsBookMarkJob(String jobId) async {
    final prefs = await SharedPreferences.getInstance();
    final response = await _supbase
        .from("bookmarkJob")
        .select("*")
        .eq('job_id', jobId)
        .eq('userId', prefs.getString("id"));

    if (response.isEmpty) {
      return false;
    }
    return true;
  }

  Future<void> addBookMarkJob(String jobId) async {
    final prefs = await SharedPreferences.getInstance();
    await SupabaseBase.supabaseClient.from('bookmarkJob').insert({
      'job_id': jobId,
      'userId': prefs.getString("id"),
    }).execute();

    notifyListeners();
  }

  Future<void> deleteBookMarkJob(String jobId) async {
    final prefs = await SharedPreferences.getInstance();
    var respon = await SupabaseBase.supabaseClient
        .from('bookmarkJob')
        .delete()
        .eq('job_id', jobId)
        .eq('userId', prefs.getString("id"))
        .execute();
    print(respon);
    notifyListeners();
  }

  Future getJobId(String nameColumn) async {
    final prefs = await SharedPreferences.getInstance();
    var listJobBookMark = await _supbase
        .from('${nameColumn}')
        .select("job_id")
        .eq('userId', prefs.getString("id"))
        .execute();
    print(listJobBookMark);
    if (listJobBookMark.data != null) {
      List<String> _jobItem = [];
      var data = listJobBookMark.data;
      for (int i = 0; i < data.length; i++) {
        _jobItem.add(data[i]['job_id']);
        print("i: ${data[i]['job_id']}");
      }

      return _jobItem;
    }
    return [];
  }

  Future deleteJob(BuildContext context, String id) async {
    await _supbase.rpc('handledeletejob', params: {'jobid': '$id'});

    Fluttertoast.showToast(
      msg: 'Xóa thành công',
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );

    notifyListeners();
  }

  List<JobModel> _listJobBookMark = [];
  get listBookmark => _listJobBookMark;

  

  Future getBookMarkJob() async {
    List<JobModel> _listJob = [];
    var jobIds = await getJobId('bookmarkJob');

    for (int i = 0; i < jobIds.length; i++) {
      var respon = await _supbase
          .from("jobs")
          .select("*,users(*)")
          .eq('job_id', jobIds[i])
          .execute();
      if (respon.data != null && respon.data.isNotEmpty) {
        var data = respon.data;
        for (int i = 0; i < data.length; i++) {
          _listJob.add(JobModel.fromMap(data[i]));
        }
      }
    }
    _listJobBookMark = _listJob;
    print(_listJobBookMark);

    notifyListeners();
    // return _listJob;
  }

  Future<void> updateApliedJob(BuildContext context, ApplyModel newApplied,
      {String action = ""}) async {
    final prefs = await SharedPreferences.getInstance();

    final response = await SupabaseBase.supabaseClient
        .from('applyjob')
        .update(newApplied.toMap())
        .eq('apply_id', newApplied.jobAppliedId)
        .execute();
    if (response != null) {
      Fluttertoast.showToast(
        msg: 'Cập nhật trạng thái thành công!',
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
      notifyListeners();
    } else {
      Fluttertoast.showToast(
        msg: 'Cập nhật thất bại!',
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      notifyListeners();
    }
  }

  // void convertFromDateTimeToMilisecond(DateTime) {
  //   DateTime now = DateTime.now();

  // }
}
