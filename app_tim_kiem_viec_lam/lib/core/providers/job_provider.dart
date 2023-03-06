import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/bookmark_moder.dart';
import '../models/like_model.dart';
import '../models/post_model.dart';
import '../supabase/supabase.dart';

class JobProvider extends ChangeNotifier {
  List<LikesModel> _listLike = [];
  List<BookMarkModel> _listBookmark = [];
  List<PostModel> _posts = [];
  List<PostModel> _postById = [];
  get posts => _posts;
  get listBookmark => _listBookmark;
  get listLike => _listLike;

  String? _selectedJob;
  get selectedJob => _selectedJob;
  set setSelectedJob(value) {
    _selectedJob = value;
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

  Future getPotsById() async {
    final prefs = await SharedPreferences.getInstance();
    final response = await SupabaseBase.supabaseClient
        .from('posts')
        .select('*, users(*)')
        .eq("userId", prefs.getString('id'))
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
}
