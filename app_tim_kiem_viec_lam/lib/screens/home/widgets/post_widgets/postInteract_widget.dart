import 'package:app_tim_kiem_viec_lam/core/models/bookmark_model.dart';
import 'package:app_tim_kiem_viec_lam/core/models/comment_post_model.dart';
import 'package:app_tim_kiem_viec_lam/core/providers/post_provider.dart';
import 'package:app_tim_kiem_viec_lam/core/providers/user_provider.dart';
import 'package:app_tim_kiem_viec_lam/screens/comment/comment.dart';
import 'package:app_tim_kiem_viec_lam/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/models/like_model.dart';
import '../../../../core/models/post_model.dart';
import '../../../../core/providers/comment.dart';
import '../../../../core/supabase/supabase.dart';

class PostInteract extends StatefulWidget {
  PostInteract({super.key, this.post, this.userFrom, this.userTo, this.postId});
  PostModel? post;
  final String? userTo;
  final String? userFrom;
  final int? postId;
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
  final _formKey = GlobalKey<FormState>();
  final _msgController = TextEditingController();
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

  Future<void> _submit(CommentProvider appService) async {
    final _text = _msgController.text;

    if (_text.isEmpty) {
      return;
    }

    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      await appService.saveMessage(
          _text, widget.userTo.toString(), widget.postId!.toInt());

      _msgController.text = '';
    }
  }

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
                    Consumer<UserProvider>(
                      builder: (context, userProvider, _) {
                        return GestureDetector(
                            onTap: () {
                              _showBottomSheet(context);
                            },
                            child: Image.asset("assets/icons/comment.png"));
                      },
                    ),
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

  void _showBottomSheet(BuildContext context) {
    final appService = context.read<CommentProvider>();
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.r),
        ),
      ),
      isScrollControlled: true,
      isDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 0.8.sh,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Text(
                    'Bình luận',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 15.h,
                ),
                Container(
                  // padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 5.h),
                  height: 0.72.sh,
                  width: double.infinity,
                  child: StreamBuilder<List<CommentModel>>(
                    stream: appService.getCommentPost(
                        widget.userFrom.toString(),
                        widget.userTo.toString(),
                        widget.postId!.toInt()),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final comment = snapshot.data!;

                        List<CommentModel> filteredMessages = comment
                            .where((item) => item.postId == widget.postId)
                            .toList();

                        return Column(
                          children: [
                            Container(
                                height: 0.6.sh,
                                child: filteredMessages.length != 0
                                    ? ListView.builder(
                                        // reverse: true,
                                        itemCount: filteredMessages.length,
                                        itemBuilder: (context, index) {
                                          final comment =
                                              filteredMessages[index];

                                          return CommentBubble(
                                              comment: comment);
                                          ;
                                        },
                                      )
                                    : Text(
                                        "Hãy là người đầu tiên bình luận bài viết")),
                            SizedBox(
                              height: 10.h,
                            ),
                            Spacer(),
                            SafeArea(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Form(
                                  key: _formKey,
                                  child: TextFormField(
                                    controller: _msgController,
                                    decoration: InputDecoration(
                                        labelText: 'Nhập bình luận',
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: HexColor("#BB2649"),
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: HexColor("#BB2649"),
                                          ),
                                        ),
                                        labelStyle: TextStyle(
                                            color: HexColor("#000000")),
                                        suffixIcon: IconButton(
                                          onPressed: () => _submit(appService),
                                          icon: Icon(
                                            Icons.send_rounded,
                                            color: HexColor("#BB2649"),
                                          ),
                                        )),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }

                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
