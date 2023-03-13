// import 'package:app_tim_kiem_viec_lam/screens/home/widgets/post_widgets/postInteract_widget.dart';
import 'package:app_tim_kiem_viec_lam/screens/home/widgets/post_widgets/postInteract_widget.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../../core/models/post_model.dart';
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
    return Card(
      shadowColor: Colors.lightGreenAccent,
      elevation: 8,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5),
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _PostHeader(post: widget.post),
            const SizedBox(height: 4.0),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Text(widget.post.caption.toString())),
            GestureDetector(
                onTap: () {
                  _dialogBuilder(context);
                },
                child: widget.post.imageurl == null ||
                        widget.post.imageurl == ""
                    ? Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                      )
                    : Container(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        decoration: BoxDecoration(

                            // image: DecorationImage(
                            //   fit: BoxFit.fitWidth,
                            //   image: NetworkImage(
                            //     '${widget.post.imageurl.toString()}',
                            //   ),
                            // ),
                            ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: FadeInImage(
                              placeholder: AssetImage(
                                  "assets/images/no-image-width.png"),
                              image:
                                  NetworkImage(widget.post.imageurl.toString()),
                              fit: BoxFit.contain,
                              width: MediaQuery.of(context).size.width * 1),
                        ),
                      )),
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
      margin: EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Stack(
            children: [
              GestureDetector(
                onTap: () {
                  print(widget.post.userId);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ProfileScreen(clientID: widget.post.userId,)));
                },
                child: widget.post.users!.imageUrl == null
                    ? CircleAvatar(
                        radius: 20,
                        backgroundColor: HexColor("#BB2649"),
                        child: Text(
                            "${widget.post.users?.name.toString().substring(0, 1).toUpperCase()}",
                            style: TextStyle(fontSize: 40)))
                    : CircleAvatar(
                        radius: 20,
                        backgroundColor: HexColor("#BB2649"),
                        backgroundImage:
                            NetworkImage("${widget.post.users!.imageUrl}"),
                      ),
              )
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
                      "${widget.post.users?.name}",
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
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OpenStreetMap(
                                      isSeen: true,
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
