import 'dart:async';

import 'package:app_tim_kiem_viec_lam/core/supabase/supabase.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/chat_message.dart';

class ChatProvider extends ChangeNotifier {
  SupabaseClient _supabase = SupabaseBase.supabaseClient;
  // Lấy id của người gửi
  // Future<String> _getUserTo() async {
  //   final response = await _supabase
  //       .from('users')
  //       .select('userId')
  //       .not('userId', 'eq', getCurrentUserId())
  //       .execute();

  //   return response.data[0]['userId'];
  // }

//   StreamController<List<Message>> _messageController =
//       StreamController.broadcast();
// //  Real time lấy messages theo userId
//   void getMessages(String userFromId, String userToId) async {
//     final response = await _supabase
//         .from('messages')
//         .stream(primaryKey: ['id'])
//         .eq('user_from', userFromId)
//         .eq('user_to', userToId)
//         .execute();

//     if (response == null) {
//       print('Error fetching messages: ${response}');
//       return;
//     }
//   }
  // Stream<Lis t<Message>> getMessages(String userFromId, String userToID) {

  //   final _supabase = await
  //       .from('message')
  //       .stream(primaryKey: ['id'])
  //       // .stream(primaryKey: ['id'])
  //       .eq('user_from', userFromId)
  //       .eq('user_to', userToID)
  //       .order('created_at')
  //       .execute() ;

  // }
  // Stream<List<Message>> getMessages(String userFromId, String userToID) {

  //   return _supabase
  //       .from('message')
  //       .stream(primaryKey: ['id'])
  //       // .stream(primaryKey: ['id'])
  //       // .eq('user_from', userFromId)
  //       // .eq('user_to', userToID)
  //       .order('created_at').on
  //       .execute()
  //       .map((maps) => maps.map((item) {
  //             return Message.fromJson(item, userFromId);
  //           }).toList());
  // }
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
  // Stream<List<Message>> getMessages(String userToID) {
  //   return _supabase
  //       .from('message')
  //       .stream(primaryKey: ['userId'])
  //       .eq('userId', getCurrentUserId())
  //       .eq('userTo', userToID)
  //       .order('created_at', ascending: false)
  //       .execute()
  //       .map((maps) => maps
  //           .map((item) => Message.fromJson(item, getCurrentUserId()))
  //           .toList());
  // }

// Hàm lưu tin nhắn
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
