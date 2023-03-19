import 'package:app_tim_kiem_viec_lam/screens/chat/chatscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hexcolor/hexcolor.dart';

class ListChatScreen extends StatefulWidget {
  const ListChatScreen({super.key});

  @override
  State<ListChatScreen> createState() => _ListChatScreenState();
}

class _ListChatScreenState extends State<ListChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("#BB2649"),
      body: SafeArea(
          child: Column(
        children: [_top(), _body()],
      )),
    );
  }

  Widget _top() {
    return Container(
      padding: EdgeInsets.only(top: 30, left: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Chat with \nwith your friends",
            style: TextStyle(
                fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(14),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.black12),
                child: Icon(
                  Icons.search,
                  size: 30,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                  child: Container(
                height: 100,
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: 8,
                  itemBuilder: (context, index) {
                    return Avatar(
                      image: "assets/images/avatar.png",
                      margin: EdgeInsets.only(right: 15),
                    );
                  },
                ),
              ))
            ],
          )
        ],
      ),
    );
  }

  Widget _body() {
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
          // _itemChat(
          //   avatar: 'assets/image/5.jpg',
          //   chat: 1,
          //   message:
          //       'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
          //   time: '18.00',
          // ),
          // _itemChat(
          //   chat: 0,
          //   message: 'Okey 🐣',
          //   time: '18.00',
          // ),
          // _itemChat(
          //   avatar: 'assets/image/5.jpg',
          //   chat: 1,
          //   message: 'It has survived not only five centuries, 😀',
          //   time: '18.00',
          // ),
          // _itemChat(
          //   chat: 0,
          //   message:
          //       'Contrary to popular belief, Lorem Ipsum is not simply random text. 😎',
          //   time: '18.00',
          // ),
          // _itemChat(
          //   avatar: 'assets/image/5.jpg',
          //   chat: 1,
          //   message:
          //       'The generated Lorem Ipsum is therefore always free from repetition, injected humour, or non-characteristic words etc.',
          //   time: '18.00',
          // ),
          // _itemChat(
          //   avatar: 'assets/image/5.jpg',
          //   chat: 1,
          //   message: '😅 😂 🤣',
          //   time: '18.00',
          // ),
          _itemChats(context,
              avatar: "assets/images/avatar.png",
              name: "Đoàn Quang Thái",
              time: '19:00',
              chat:
                  'test chat --> doan nayf luwu tin nhan moi nhatasdasdasdasdad'),
          _itemChats(context,
              avatar: "assets/images/avatar.png",
              name: "Đoàn",
              time: '19:00',
              chat:
                  'test chat --> doan nayf luwu tin nhan moi nhatasdasdasdasdad')
        ],
      ),
    ));
  }
}

_itemChats(BuildContext context,
    {String avatar = "", name = '', chat = '', time: '00.00'}) {
  return GestureDetector(
    onTap: () {
      // Navigator.push(
      //     context, MaterialPageRoute(builder: (context) => ChatScreen()));
    },
    child: Card(
      margin: EdgeInsets.symmetric(vertical: 20),
      elevation: 0,
      child: Row(
        children: [
          Avatar(
            margin: EdgeInsets.only(right: 20),
            size: 60,
            image: avatar,
          ),
          Expanded(
              child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "$name",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "$time",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.grey),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                '$chat',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colors.black54, fontWeight: FontWeight.bold),
              )
            ],
          ))
        ],
      ),
    ),
  );
}
// _itemChat({int? chat, String? avatar, message, time}) {
//   return Row(
//     mainAxisAlignment:
//         chat == 0 ? MainAxisAlignment.end : MainAxisAlignment.start,
//     crossAxisAlignment: CrossAxisAlignment.end,
//     children: [
//       avatar != null
//           ? Avatar(
//               image: avatar,
//               size: 50,
//             )
//           : Text(
//               '$time',
//               style: TextStyle(color: Colors.grey.shade400),
//             ),
//       Flexible(
//         child: Container(
//           margin: EdgeInsets.only(left: 10, right: 10, top: 20),
//           padding: EdgeInsets.all(20),
//           decoration: BoxDecoration(
//             color: chat == 0 ? Colors.indigo.shade100 : Colors.indigo.shade50,
//             borderRadius: chat == 0
//                 ? BorderRadius.only(
//                     topLeft: Radius.circular(30),
//                     topRight: Radius.circular(30),
//                     bottomLeft: Radius.circular(30),
//                   )
//                 : BorderRadius.only(
//                     topLeft: Radius.circular(30),
//                     topRight: Radius.circular(30),
//                     bottomRight: Radius.circular(30),
//                   ),
//           ),
//           child: Text('$message'),
//         ),
//       ),
//       chat == 1
//           ? Text(
//               '$time',
//               style: TextStyle(color: Colors.grey.shade400),
//             )
//           : SizedBox(),
//     ],
//   );
// }

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
            image: AssetImage(image),
          ),
        ),
      ),
    );
  }
}
