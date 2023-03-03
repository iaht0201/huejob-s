// import 'package:app_tim_kiem_viec_lam/screens/home/widgets/post_widgets/postInteract_widget.dart';
import 'package:app_tim_kiem_viec_lam/screens/home/widgets/post_widgets/postInteract_widget.dart';
import 'package:flutter/material.dart';
import '../../../../core/models/post_model.dart';

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
            GestureDetector(
              onTap: () {
                _dialogBuilder(context);
              },
              child: widget.post.imageurl == null || widget.post.imageurl == ""
                  ? Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Image.network(widget.post.imageurl)),
            ),
            PostInteract(
              post: widget.post,
            )
          ],
        ),
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
                  child: Image.network(widget.post.imageurl))
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
                Row(
                  children: [
                    Text(
                      "${widget.post.users.name}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Icon(
                      Icons.location_on_outlined,
                      size: 14,
                    ),
                    Text(
                      '${widget.post.location} • ',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12.0,
                      ),
                    ),
                  ],
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
