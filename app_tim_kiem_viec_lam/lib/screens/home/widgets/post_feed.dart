import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart';

import '../../../core/models/post_model.dart';

class PostItem extends StatefulWidget {
  PostItem({super.key, required this.post});
  final PostModel post;
  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5),
        margin: EdgeInsets.symmetric(vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _PostHeader(post: widget.post),
            const SizedBox(height: 4.0),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Text(widget.post.caption)),
            // widget.post.imageUrl != null
            //     ? Container()
            //     : const SizedBox(height: 6.0),

            widget.post.imageurl != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Image.network(widget.post.imageurl))
                : Container(),
            _PostInteract()
          ],
        ),
      ),
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
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 20.0,
                child: CircleAvatar(
                  radius: 18.0,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: widget.post.users.imageUrl != ""
                      ? NetworkImage("${widget.post.users.imageUrl}")
                      : NetworkImage(
                          "https://static2.yan.vn/YanNews/2167221/202102/facebook-cap-nhat-avatar-doi-voi-tai-khoan-khong-su-dung-anh-dai-dien-e4abd14d.jpg"),
                ),
              ),
            ],
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${widget.post.users.name}",
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
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
                      'Công nghệ thông tin',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12.0,
                      ),
                    ),
                    // Icon(
                    //   Icons.public,
                    //   color: Colors.grey[600],
                    //   size: 12.0,
                    // )
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_horiz_outlined),
            onPressed: () => print('More'),
          ),
        ],
      ),
    );
  }
}

class _PostInteract extends StatefulWidget {
  const _PostInteract({super.key});

  @override
  State<_PostInteract> createState() => __PostInteractState();
}

class __PostInteractState extends State<_PostInteract> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InteracIcon(context, "Thích", Icons.favorite_border),
          InteracIcon(context, "Nhận xét", Icons.comment_outlined) , 
          InteracIcon(context, "Nhận xét", Icons.bookmark_outline) , 
          InteracIcon(context, "Nhận xét", Icons.share_outlined)
        ],
      ),
    );
  }

  InteracIcon(BuildContext context, String text, IconData icon) {
    return GestureDetector(
        onTap: () {
          print(text);
        },
        child: Icon(icon));
  }
}
