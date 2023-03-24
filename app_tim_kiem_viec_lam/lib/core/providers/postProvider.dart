import 'package:app_tim_kiem_viec_lam/core/models/user_model.dart';
import 'package:app_tim_kiem_viec_lam/screens/home/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/bookmark_moder.dart';
import '../models/jobCategory_model.dart';
import '../models/like_model.dart';
import '../models/post_model.dart';
import '../supabase/supabase.dart';

class PostProvider extends ChangeNotifier {
  List<LikesModel> _listLike = [];
  List<BookMarkModel> _listBookmark = [];
  List<PostModel> _posts = [];
  List<PostModel> _postById = [];
  List<JobCategoryModel> _jobs = [];
  JobCategoryModel? _selectedOption;
  // String? _selectedJob;
  String? _address;
  double? _longitude;
  double? _latitude;
  double? get longitude => _longitude;
  double? get latitude => _latitude;
  get address => _address;
  set setAddress(value) {
    _address = value;
    notifyListeners();
  }

  List<PostModel> get posts => _posts;
  get listBookmark => _listBookmark;
  get listLike => _listLike;
  set setLatitude(value) {
    _latitude = value;
    notifyListeners();
  }

  set setLongtitude(value) {
    _longitude = value;
    notifyListeners();
  }
  // get selectedJob => _selectedJob;
  // set setSelectedJob(value) {
  //   _selectedJob = value;
  //   notifyListeners();
  // }

  List<JobCategoryModel> get jobs => _jobs;

  JobCategoryModel? get selectedOption => _selectedOption;
  set setSelectedOption(value) {
    _selectedOption = value;
    notifyListeners();
  }

  Future getPots() async {
    final response = await SupabaseBase.supabaseClient
        .from('posts')
        .select('*, users(*)')
        .order('create_at', ascending: false)
        .limit(10)
        .execute();

    if (response.data != null) {
      _posts.clear();
      var data = await response.data;
      //  _posts = await data ;
      for (int i = 0; i < data.length; i++) {
        _posts.add(PostModel.fromMap(data[i]));
      }
      notifyListeners();
      // return _posts;
    }
  }

  Future fetchPostMore(int page, int pageSize) async {
    final response = await SupabaseBase.supabaseClient
        .from('posts')
        .select('*, users(*)')
        .order('create_at', ascending: false)
        .range(page * page, (page + 1) * pageSize - 1)
        .execute();
    posts.clear();
    if (response.data != null) {
      var data = await response.data;
      //  _posts = await data ;
      for (int i = 0; i < data.length; i++) {
        _posts.add(PostModel.fromMap(data[i]));
      }

      // notifyListeners();
      return _posts;
      // return _posts;
    }
  }
  // bool _hasMorePosts = false;
  // get hasMorePosts => _hasMorePosts;
  // Future<void> fetchPostMore(int page, int pageSize) async {
  //   final response = await SupabaseBase.supabaseClient
  //       .from('posts')
  //       .select('*, users(*)')
  //       .order('create_at', ascending: false)
  //       .range(page * pageSize, (page + 1) * pageSize - 1)
  //       .execute();

  //   if (response.data != null) {
  //     _posts.clear();
  //     var data = await response.data;
  //     for (int i = 0; i < data.length; i++) {
  //       _posts.add(PostModel.fromMap(data[i]));
  //     }
  //     notifyListeners();

  //     // Tính toán giá trị của hasMorePosts
  //     if (data.length < pageSize) {
  //       _hasMorePosts = false;
  //     } else {
  //       _hasMorePosts = true;
  //     }
  //   }
  // }

  Future getPotsById(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final response = await SupabaseBase.supabaseClient
        .from('posts')
        .select('*, users(*)')
        .eq("userId", id)
        .order('create_at', ascending: false)
        .limit(10)
        .execute();

    if (response.data != null) {
      postById.clear();
      var data = await response.data;
      for (int i = 0; i < data.length; i++) {
        _postById.add(PostModel.fromMap(data[i]));
      }
    }
    notifyListeners();
  }

  get postById => _postById;

  Future<void> getLike() async {
    _listLike.clear();
    final prefs = await SharedPreferences.getInstance();
    final response = await SupabaseBase.supabaseClient
        .from('likes')
        .select("*")
        .eq('userId', prefs.getString('id'))
        .execute();

    if (response.data != null) {
      final data = response.data;
      for (var like in data) {
        _listLike.add(LikesModel.fromMap(like));
      }
    }
  }

  Future<void> getBookMark() async {
    final prefs = await SharedPreferences.getInstance();
    final response = await SupabaseBase.supabaseClient
        .from('bookmarks')
        .select("*")
        .eq('userId', prefs.getString('id'))
        .execute();

    if (response.data != null) {
      final data = response.data;
      for (var bookmark in data) {
        _listBookmark.add(BookMarkModel.fromMap(bookmark));
      }
    }
    notifyListeners();
  }

  // add follow

  Future<void> addLike(dynamic post) async {
    final prefs = await SharedPreferences.getInstance();
    await SupabaseBase.supabaseClient.from('likes').insert({
      'post_id': post!.postId,
      'userId': prefs.getString('id'),
    }).execute();
    post!.like_count += 1;

    notifyListeners();
  }

  Future<void> deleteLike(dynamic post) async {
    final prefs = await SharedPreferences.getInstance();
    await SupabaseBase.supabaseClient
        .from('likes')
        .delete()
        .eq('post_id', post!.postId)
        .eq('userId', prefs.getString('id'))
        .execute();
    post!.like_count -= 1;

    notifyListeners();
    // setState(() {
    //   isLiked = false;
    // });
  }

  Future<void> addBookMark(dynamic post) async {
    final prefs = await SharedPreferences.getInstance();
    await SupabaseBase.supabaseClient.from('bookmarks').insert({
      'post_id': post!.postId,
      'userId': prefs.getString('id'),
    }).execute();

    notifyListeners();
  }

  Future<void> deleteBookMark(dynamic post) async {
    final prefs = await SharedPreferences.getInstance();
    await SupabaseBase.supabaseClient
        .from('bookmarks')
        .delete()
        .eq('post_id', post!.postId)
        .eq('userId', prefs.getString('id'))
        .execute();
  }

  Future getJobCategory() async {
    final response = await SupabaseBase.supabaseClient
        .from('jobcategory')
        .select('*')
        .order("jobcategoryid", ascending: true)
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

  Future<void> insertPost(BuildContext context, PostModel newPost) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final response = await SupabaseBase.supabaseClient
          .from("posts")
          .insert(newPost.toMapHaveImage(newPost))
          .execute();
      if (response != null) {
        Fluttertoast.showToast(
          msg: 'Đăng bài viết thành công!',
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        _posts.add(newPost);
        print(_posts);
        // _posts = [..._posts, newPost];

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (BuildContext context) => HomePage()),
        );
        notifyListeners();
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Đăng bài viết thất bại, vui lòng thử lại sau!',
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }
}
