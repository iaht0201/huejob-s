import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/post_model.dart';
import '../supabase/supabase.dart';

class JobProvider extends ChangeNotifier {
  List<PostModel> posts = [];
  Future insertLike() async {
    
  }
  Future getPots() async {
    final response = await SupabaseBase.supabaseClient
        .from('posts')
        .select('*, users(*)')
        .order('create_at', ascending: false)
        .limit(10)
        .execute();

    if (response.data != null) {
      posts.clear();
      var data = await response.data;
      for (int i = 0; i < data.length; i++) {
        posts.add(PostModel.fromMap(data[i]));
      }
      return posts;
    }
  }

  
}
