import 'dart:async';

import 'package:app_tim_kiem_viec_lam/core/supabase/supabase.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/chat_message.dart';

class ChatProvider extends ChangeNotifier {
  SupabaseClient _supabase = SupabaseBase.supabaseClient;

  Stream<List<Message>> getMessages(String userFromId, String userToID) {
    return _supabase
        .from('message')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .execute()
        .map((maps) => maps.map((item) {
              return Message.fromJson(item, userFromId);
            }).toList());
  }

  Future<void> getUserListMessager() async {
    final prefs = await SharedPreferences.getInstance();
    // get lấy 1 list id của người nhắn tin
    var _listToId = _supabase.from('message').select("user_to").execute();

  }

  Future<void> saveMessage(String content, String userTo) async {
    final prefs = await SharedPreferences.getInstance();

    // final userTo = await _getUserTo();
    // Lấy id người nhận
    final message = Message.create(
        content: content,
        userFrom: prefs.getString('id').toString(),
        userTo: userTo);
    // Tạo một Message với userTo là người nhận  và usrFrom  là isMine
    await _supabase.from('message').insert(message.toMap()).execute();
    // insert nó vào bảng message
  }

  Future<void> markAsRead(String messageId) async {
    // Check xem là đã đọc chưa
    await _supabase
        .from('message')
        .update({'mark_as_read': true})
        .eq('id', messageId)
        .execute();

    // if messageId đó đã đọc thì sẽ cập nhập mark_as_read là true
  }

  bool isAuthentificated() => _supabase.auth.currentUser != null;
  // Hàm get xem là thằng này đã login chưa => đã có token chưa

  String getCurrentUserId() =>
      isAuthentificated() ? _supabase.auth.currentUser!.id : '';
  //  Get id của thằng đang đăng nhập
  String getCurrentUserEmail() =>
      isAuthentificated() ? _supabase.auth.currentUser!.email ?? '' : '';
  // Get email của tài khoản đăng ký
  // get messageController => _messageController;
}
