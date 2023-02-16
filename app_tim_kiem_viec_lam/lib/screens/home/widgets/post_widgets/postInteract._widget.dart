import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/models/like_model.dart';
import '../../../../core/models/post_model.dart';
import '../../../../core/supabase/supabase.dart';

class PostInteract extends StatefulWidget {
  PostInteract({super.key, this.post});
  PostModel? post;

  @override
  State<PostInteract> createState() => _PostInteractState();
}

class _PostInteractState extends State<PostInteract> {
  bool isLiked = false;
  bool isBookMarked = false;
  List listLike = [];
  @override
  void initState() {
    super.initState();
    getLike().whenComplete(() {
      for (LikesModel like in listLike) {
        if (like.postId == widget.post!.postId) {
          setState(() {
            isLiked = true;
          });

          break;
        }
      }
    });
  }

  Future<void> getLike() async {
    final prefs = await SharedPreferences.getInstance();
    final response = await SupabaseBase.supabaseClient
        .from('likes')
        .select("*")
        .eq('user_id', prefs.getString('id'))
        .execute();

    if (response.data != null) {
      final data = response.data;
      for (var like in data) {
        listLike.add(LikesModel.fromMap(like));
      }
    }

    print(response.data);
  }

  Future<void> addLike() async {
    final prefs = await SharedPreferences.getInstance();
    await SupabaseBase.supabaseClient.from('likes').insert({
      'post_id': widget.post!.postId,
      'user_id': prefs.getString('id'),
    }).execute();
    widget.post!.like_count += 1;
    setState(() {
      isLiked = true;
    });
  }

  Future<void> deleteLike() async {
    final prefs = await SharedPreferences.getInstance();
    await SupabaseBase.supabaseClient
        .from('likes')
        .delete()
        .eq('post_id', widget.post!.postId)
        .eq('user_id', prefs.getString('id'))
        .execute();
    widget.post!.like_count -= 1;
    setState(() {
      isLiked = false;
    });
  }

  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _InteracLikeIcon(context, widget.post!.like_count.toString(),
              isLiked ? Icons.favorite : Icons.favorite_border, () {
            if (isLiked) {
              deleteLike();
            } else {
              addLike();
            }
            ;
          }),
          _InteracIcon(context, Icons.message, () {
            print("message");
          }),
          _InteracIcon(context,
              !isBookMarked ? Icons.bookmark_outline : Icons.bookmark_sharp,
              () {
            print("bookmark");
          }),
          _InteracIcon(context, Icons.share, () {
            print("share");
          }),
        ],
      ),
    );
  }

  _InteracLikeIcon(
      BuildContext context, String text, IconData icon, Function() onTap) {
    return GestureDetector(
        onTap: onTap,
        child: Row(
          children: [Icon(icon), Text("${text} lượt thích")],
        ));
  }

  _InteracIcon(BuildContext context, IconData icon, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(icon),
    );
  }
}
