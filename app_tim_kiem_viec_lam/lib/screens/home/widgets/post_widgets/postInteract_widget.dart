import 'package:app_tim_kiem_viec_lam/core/models/bookmark_model.dart';
import 'package:app_tim_kiem_viec_lam/core/providers/post_provider.dart';
import 'package:app_tim_kiem_viec_lam/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
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
  bool isLoading = false;
  List listBookmark = [];
  late PostProvider postProvider;
  late List<PostModel> post;

  @override
  void initState() {
    postProvider = Provider.of<PostProvider>(context, listen: false);
    post = postProvider.posts;
    postProvider.getLike().whenComplete(() {
      for (LikesModel like in postProvider.listLike) {
        if (like.postId == widget.post!.postId) {
          setState(() {
            isLiked = true;
          });

          break;
        }
        isLoading = true;
      }
    });
    postProvider.getBookMark().whenComplete(() {
      for (BookMarkModel bookmark in postProvider.listBookmark) {
        if (bookmark.postId == widget.post!.postId) {
          setState(() {
            isBookMarked = true;
          });
        }
      }
      isLoading = true;
    });

    super.initState();
  }

  // Future<void> getBookMark() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final response = await SupabaseBase.supabaseClient
  //       .from('bookmarks')
  //       .select("*")
  //       .eq('userId', prefs.getString('id'))
  //       .execute();

  //   if (response.data != null) {
  //     final data = response.data;
  //     for (var bookmark in data) {
  //       listBookmark.add(BookMarkModel.fromMap(bookmark));
  //     }
  //   }

  //   print(response.data);
  // }

  // Future<void> addLike() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await SupabaseBase.supabaseClient.from('likes').insert({
  //     'post_id': widget.post!.postId,
  //     'userId': prefs.getString('id'),
  //   }).execute();
  //   widget.post!.like_count += 1;

  //   // setState(() {
  //   //   isLiked = true;
  //   // });
  // }

  // Future<void> deleteLike() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await SupabaseBase.supabaseClient
  //       .from('likes')
  //       .delete()
  //       .eq('post_id', widget.post!.postId)
  //       .eq('userId', prefs.getString('id'))
  //       .execute();
  //   widget.post!.like_count -= 1;
  // }

  // Future<void> addBookMark() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await SupabaseBase.supabaseClient.from('bookmarks').insert({
  //     'post_id': widget.post!.postId,
  //     'userId': prefs.getString('id'),
  //   }).execute();

  //   setState(() {
  //     isBookMarked = true;
  //   });
  // }

  // Future<void> deleteBookMark() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await SupabaseBase.supabaseClient
  //       .from('bookmarks')
  //       .delete()
  //       .eq('post_id', widget.post!.postId)
  //       .eq('userId', prefs.getString('id'))
  //       .execute();

  //   setState(() {
  //     isBookMarked = false;
  //   });
  // }

  Widget build(BuildContext context) {
    return Consumer<PostProvider>(
      builder: (context, postProvider, _) {
        return isLoading
            ? Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _InteracLikeIcon(
                        context,
                        widget.post!.like_count.toString(),
                        isLiked == false
                            ? Icons.thumb_up_outlined
                            : Icons.thumb_up, () {
                      if (isLiked == true) {
                        postProvider.deleteLike(widget.post);
                        isLiked = !isLiked;
                      } else {
                        postProvider.addLike(widget.post);
                        isLiked = !isLiked;
                      }
                    }),
                    SizedBox(
                      width: 18.w,
                    ),
                    Image.asset("assets/icons/comment.png"),
                    // _InteracIcon(context, Icons.forum, () {
                    //   print("message");
                    // }),
                    SizedBox(
                      width: 18.w,
                    ),
                    _InteracIcon(
                        context,
                        !isBookMarked
                            ? Icons.bookmark_outline
                            : Icons.bookmark_sharp, () {
                      if (isBookMarked) {
                        postProvider.deleteBookMark(widget.post);
                        setState(() {
                          isBookMarked = false;
                        });
                      } else {
                        postProvider.addBookMark(widget.post);
                        setState(() {
                          isBookMarked = true;
                        });
                      }
                    }),
                    Spacer(),
                    Image.asset("assets/icons/more.png")
                  ],
                ),
              )
            : Container();
      },
    );
  }

  _InteracLikeIcon(
      BuildContext context, String text, IconData icon, Function() onTap) {
    return GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            Icon(
              icon,
              color: icon == Icons.thumb_up
                  ? HexColor("#BB2649")
                  : HexColor("#95969D"),
            ),
            SizedBox(
              width: 4.w,
            ),
            Text(
              "${text}",
              style: textTheme.medium14(color: "95969D"),
            )
          ],
        ));
  }

  _InteracIcon(BuildContext context, IconData icon, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(icon, color: HexColor("#95969D")),
    );
  }
}
