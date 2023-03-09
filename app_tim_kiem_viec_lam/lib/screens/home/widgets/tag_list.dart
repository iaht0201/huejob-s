
import 'package:flutter/material.dart';

class TagList extends StatefulWidget {
  const TagList({super.key});

  @override
  State<TagList> createState() => _TagListState();
}

class _TagListState extends State<TagList> {
  final List<String> tagList = [
    'Tất cả 🌟',
    'Phổ biến',
    'IT',
    'Thương mại điện tử',
    'Design',
    'Logitis'
  ];
  var selected = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        height: 40,
        child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selected = index;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: selected == index
                              ? Theme.of(context).primaryColor
                              : Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.2)),
                      color: selected == index
                          ? Theme.of(context).primaryColor.withOpacity(0.2)
                          : Colors.transparent),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Text(tagList[index]),
                ),
              );
            },
            separatorBuilder: (context, index) {
              return SizedBox(
                width: 15,
              );
            },
            itemCount: tagList.length));
  }
}
