import 'package:app_tim_kiem_viec_lam/core/models/comment.dart';
import 'package:app_tim_kiem_viec_lam/core/providers/user_provider.dart';
import 'package:app_tim_kiem_viec_lam/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../../core/models/chat_message.dart';

class CommentBubble extends StatelessWidget {
  final CommentModel comment;
  const CommentBubble({Key? key, required this.comment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var chatContents = [
      Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          return Column(
            children: [
              _itemChat(
                  avatar: '${comment.imageUrl}',
                  message: '${comment.content}',
                  name: '${comment.username}'),
              SizedBox(
                height: 20.h,
              )
            ],
          );
        },
      )
    ];

    chatContents = chatContents.reversed.toList();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      child: Row(
        children: chatContents,
      ),
    );
  }
}

_itemChat({String? avatar, message, time, name}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Avatar(
            image: avatar,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 0.8.sw,
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
                decoration: BoxDecoration(
                    color: HexColor("#344e41"),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '$name',
                          style: textTheme.sub16(color: "FFFFFF"),
                        ),
                        Spacer(),
                        Image.asset(
                          "assets/icons/more.png",
                          color: Colors.white,
                        )
                      ],
                    ),
                    Text(
                      '$message',
                      style: textTheme.regular13(color: "FFFFFF"),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 5.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Thích",
                    style: textTheme.regular16(color: "000000"),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Text("Phản hồi", style: textTheme.regular16(color: "000000")),
                ],
              )
            ],
          )
        ],
      ),
    ],
  );
}

class Avatar extends StatelessWidget {
  Avatar(
      {this.image,
      this.size = 50,
      this.margin = const EdgeInsets.only(right: 10)});
  final double size;
  final image;
  final EdgeInsets margin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: Container(
        width: size,
        height: size,
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
          image: new DecorationImage(
              image: NetworkImage(image), fit: BoxFit.cover),
        ),
      ),
    );
  }
}
