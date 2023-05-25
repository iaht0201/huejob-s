import 'package:app_tim_kiem_viec_lam/core/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import '../../core/models/chat_message.dart';
import '../profile/widgets/button_arrow.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({super.key, required this.message});
  final Message message;
  @override
  State<ChatScreen> createState() => _ListChatScreenState();
}

class _ListChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("#BB2649"),
      body: SafeArea(
          child: Column(
        children: [
          _top(),
          _body(),

          // _formChat(),
        ],
      )),
    );
  }

  Widget _top() {
    // show ten cua nguoi dang nhan tin 
    return Container(
        padding: EdgeInsets.symmetric(vertical: 25, horizontal: 30),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back_ios,
                size: 25,
                color: Colors.white,
              ),
            ),
            Text(
              'Fiona',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ));
  }

  Widget _body() {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return Expanded(
            child: Container(
          padding: EdgeInsets.only(left: 25, right: 25, top: 25),
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(45), topRight: Radius.circular(45)),
              color: Colors.white),
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              // Hien thi phan tu chat
              _itemChat(
                avatar: '${userProvider.user.imageUrl}',
                chat: widget.message.isMine == true ? 1 : 0,
                message: '${widget.message.content}',
                time: '18.00',
              ),
            ],
          ),
        ));
      },
    );
  }
}

_itemChat({int? chat, String? avatar, message, time}) {
  return Row(
    // neu chat == 0 <=> la mine  
    mainAxisAlignment:
        chat == 0 ? MainAxisAlignment.end : MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      avatar != null
          ? CircleAvatar(
              radius: 35,
              backgroundColor: HexColor("#BB2649"),
              backgroundImage: NetworkImage("${avatar}"),
            )
          : Text(
              '$time',
              style: TextStyle(color: Colors.grey.shade400),
            ),
      Flexible(
        child: Container(
          margin: EdgeInsets.only(left: 10, right: 10, top: 20),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: chat == 0 ? Colors.indigo.shade100 : Colors.indigo.shade50,
            borderRadius: chat == 0
                ? BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                  )
                : BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
          ),
          child: Text('$message'),
        ),
      ),
      chat == 1
          ? Text(
              '$time',
              style: TextStyle(color: Colors.grey.shade400),
            )
          : SizedBox(),
    ],
  );
}

// Widget _formChat() {
//   return Expanded(
//     child: Align(
//        alignment: Alignment.bottomCenter,
//       child: Positioned(

//         child: Container(
//           height: 120,
//           padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
//           color: Colors.white,
//           child: TextField(
//             decoration: InputDecoration(
//               hintText: 'Type your message...',
//               suffixIcon: Container(
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(50),
//                     color: Colors.indigo),
//                 padding: EdgeInsets.all(14),
//                 child: Icon(
//                   Icons.send_rounded,
//                   color: Colors.white,
//                   size: 28,
//                 ),
//               ),
//               filled: true,
//               fillColor: Colors.blueGrey[50],
//               labelStyle: TextStyle(fontSize: 12),
//               contentPadding: EdgeInsets.all(20),
//               enabledBorder: OutlineInputBorder(
//                 borderSide: BorderSide(color: Colors.blueGrey),
//                 borderRadius: BorderRadius.circular(25),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderSide: BorderSide(color: Colors.blueGrey),
//                 borderRadius: BorderRadius.circular(25),
//               ),
//             ),
//           ),
//         ),
//       ),
//     ),
//   );
//}

class Avatar extends StatelessWidget {
  Avatar({this.image, this.size = 50, this.margin = const EdgeInsets.all(0)});
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
            image: NetworkImage(image),
          ),
        ),
      ),
    );
  }
}
