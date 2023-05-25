// import 'package:app_tim_kiem_viec_lam/screens/home/widgets/post_widgets/postInteract_widget.dart';
import 'package:app_tim_kiem_viec_lam/core/providers/user_provider.dart';
import 'package:app_tim_kiem_viec_lam/screens/home/widgets/post_widgets/postInteract_widget.dart';
import 'package:app_tim_kiem_viec_lam/widgets/avatar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import '../../../../core/models/post_model.dart';
import '../../../../utils/constant.dart';
import '../../../addPost/map.dart';
import '../../../profile/profile_screen.dart';
import '../../../profile/widgets/profile_information.dart';

class PostItem extends StatefulWidget {
  PostItem({super.key, required this.post});
  final PostModel post;
  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _PostHeader(post: widget.post),
          SizedBox(height: 12.5.h),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 20.w),
              child: Text(
                widget.post.caption.toString(),
                style: textTheme.regular16(),
              )),
          GestureDetector(
              onTap: () {
                _dialogBuilder(context);
              },
              child: widget.post.imageurl == null || widget.post.imageurl == ""
                  ? Container(
                      // padding: EdgeInsets.symmetric(vertical: 10),
                      )
                  : Container(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: FadeInImage(
                            placeholder:
                                AssetImage("assets/images/no-image-width.png"),
                            image:
                                NetworkImage(widget.post.imageurl.toString()),
                            fit: BoxFit.contain,
                            width: MediaQuery.of(context).size.width * 1),
                      ),
                    )),
          SizedBox(
            height: 10.h,
          ),
          Consumer<UserProvider>(
            builder: (context, userProvider, child) {
              return PostInteract(
                post: widget.post,
                userTo: widget.post.userId,
                userFrom: userProvider.user.userId,
                postId: widget.post.postId,
              );
            },
          ),
          SizedBox(
            height: 15.h,
          ),
          Divider()
        ],
      ),
    );
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('${widget.post!.caption}'),
          content: widget.post.imageurl != null
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Image.network(widget.post.imageurl.toString()))
              : Container(),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Disable'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Enable'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class _PostHeader extends StatefulWidget {
  _PostHeader({super.key, required this.post});
  final PostModel post;
  @override
  State<_PostHeader> createState() => _PostHeaderState();
}

class _PostHeaderState extends State<_PostHeader> {
  String? _imageUrl;
  void updateImageUrl(String url) {
    setState(() {
      _imageUrl = url;
      print(_imageUrl);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      child: Row(
        children: [
          GestureDetector(
              onTap: () {
                print(widget.post.userId);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfileScreen(
                              clientID: widget.post.userId,
                            )));
              },
              child:
                  AvatarWidget(context, user: widget.post.users, radius: 20.r)),
          SizedBox(width: 8.0.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    "${widget.post.users?.name}",
                    style: textTheme.semibold16(color: "000000"),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Icon(
                    Icons.location_on_outlined,
                    size: 14,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OpenStreetMap(
                                    isSeen: true,
                                    isBack: true,
                                    latitude: widget.post.latitude,
                                    longitude: widget.post.longitude,
                                  )));
                    },
                    child: Text(
                      '${widget.post.getCity} • ',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 3.h,
              ),
              Row(
                children: [
                  Text(
                    '${widget.post.agoTime} • ',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12.0,
                    ),
                  ),
                  Text(
                    '${widget.post!.category_job}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
