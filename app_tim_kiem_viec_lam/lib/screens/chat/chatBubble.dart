import 'package:app_tim_kiem_viec_lam/core/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../../core/models/chat_message.dart';
import 'maskasread.dart';

class ChatBubble extends StatelessWidget {
  final Message message;
  const ChatBubble({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var chatContents = [
      Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          return Expanded(
              child: Container(
            padding: EdgeInsets.only(left: 10, right: 10, top: 25),
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(45),
                    topRight: Radius.circular(45)),
                color: Colors.white),
            child: Column(
              children: [
                _itemChat(
                  avatar: '${userProvider.userByID.imageUrl}',
                  chat: message.isMine ? 1 : 0,
                  message: '${message.content}',
                  name:
                      '${message.isMine ? userProvider.user.name : userProvider.userByID.name}',
                )
              ],
            ),
          ));
        },
      )
    ];

    if (message.isMine) {
      chatContents = chatContents.reversed.toList();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      child: Row(
        // mainAxisAlignment:
        //     message.isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: chatContents,
      ),
    );
  }
}

_itemChat({int? chat, String? avatar, message, time, name}) {
  return Column(
    children: [
      Row(
        mainAxisAlignment:
            chat == 1 ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          chat == 0
              ? (avatar == null
                  ? Text(
                      "A",
                      style: TextStyle(color: Colors.black),
                    )
                  : Avatar(
                      image: avatar,
                      size: 45,
                    ))
              : Container(),
          Flexible(
            child: Container(
              margin: EdgeInsets.only(left: 0.w, right: 0.w),
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: chat == 1 ? Colors.indigo.shade100 : Colors.red.shade300,
                borderRadius: chat == 1
                    ? BorderRadius.only(
                        topLeft: Radius.circular(10.r),
                        topRight: Radius.circular(10.r),
                        bottomLeft: Radius.circular(10.r),
                      )
                    : BorderRadius.only(
                        topLeft: Radius.circular(10.r),
                        topRight: Radius.circular(10.r),
                        bottomRight: Radius.circular(10.r),
                      ),
              ),
              child: Text('$message'),
            ),
          ),
        ],
      ),
      // Text(
      //   '$time',
      //   style: TextStyle(color: Colors.grey.shade400),
      // )
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
