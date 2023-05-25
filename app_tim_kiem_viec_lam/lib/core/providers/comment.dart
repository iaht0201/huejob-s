import 'dart:async';

import 'package:app_tim_kiem_viec_lam/core/providers/user_provider.dart';
import 'package:app_tim_kiem_viec_lam/core/supabase/supabase.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/chat_message.dart';
import '../models/comment.dart';
import '../models/user_model.dart';

class CommentProvider extends ChangeNotifier {
  SupabaseClient _supabase = SupabaseBase.supabaseClient;

  Stream<List<CommentModel>> getCommentPost(
      String userFromId, String userToID, int postId) {
    return _supabase
        .from('comment_post')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .eq('post_id', postId)
        .execute()
        .map((maps) => maps.map((item) {
              return CommentModel.fromJson(item, userFromId);
            }).toList());
  }

  Future<UserModel> fetchUser(String id) async {
    final response =
        await _supabase.from('users').select('*').eq('userId', id).execute();
    var data = response.data;
    return UserModel.fromJson(data);
  }

  Future<void> saveMessage(String content, String userTo, int postId) async {
    final prefs = await SharedPreferences.getInstance();

    // final userTo = await _getUserTo();
    // Lấy id người nhận
    final commentPost = CommentModel.create(
        content: content,
        userFrom: prefs.getString('id').toString(),
        userTo: userTo,
        postId: postId);
    // Tạo một Message với userTo là người nhận  và usrFrom  là isMine
    await _supabase.from('comment_post').insert(commentPost.toMap()).execute();
    // insert nó vào bảng message
  }
}
