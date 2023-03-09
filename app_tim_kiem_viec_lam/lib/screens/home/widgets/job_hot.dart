
import 'package:flutter/material.dart';

import 'package:hexcolor/hexcolor.dart';

class JobHot extends StatefulWidget {
  const JobHot({super.key});

  @override
  State<JobHot> createState() => _JobHotState();
}

class _JobHotState extends State<JobHot> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              "Job's hot",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [JobHots_Items(context), JobHots_Items(context)],
            ),
          )
        ],
      ),
    );
  }

  Widget JobHots_Items(BuildContext context) {
    return GestureDetector(
      onTap: () {
        bottomSheet(context);
      },
      child: Container(
        margin: EdgeInsets.only(right: 20),
        width: 350,
        height: 190,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: HexColor("#BB2649"),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: NetworkImage(
                          'https://inkythuatso.com/uploads/thumbnails/800/2021/11/logo-fpt-inkythuatso-1-01-01-14-33-35.jpg'),
                      fit: BoxFit.fill,
                    ),
                  )),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              flex: 9,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        "Senior PHP Developer",
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      "FPT ",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withOpacity(0.7)),
                    ),
                    // SizedBox(
                    //   height: 8,
                    // ),
                    // Text(
                    //   "Thừa Thiên Huế",
                    //   style: TextStyle(
                    //       fontSize: 12,
                    //       fontWeight: FontWeight.w500,
                    //       color: Colors.grey.withOpacity(0.4)),
                    // ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      "\$11.000 - \$12.000/Tháng",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withOpacity(0.8)),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Hagtag(context, "Full-time"),
                        SizedBox(
                          width: 20,
                        ),
                        Hagtag(context, "Thừa Thiên Huế")
                      ],
                    ),

                    // Spacer(),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.end,
                    //   children: [
                    //     Text(
                    //       "Xem thêm ...",
                    //       style: TextStyle(color: Colors.white),
                    //     ),
                    //   ],
                    // )
                    // ButtonApply(context)
                  ],
                ),
              ),
            ),
            Expanded(
                flex: 1,
                child: Container(
                  child: Icon(
                    Icons.bookmark_outline,
                    color: Colors.white,
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Widget Hagtag(BuildContext context, String text) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey.withOpacity(0.8)),
      child: Text(
        "${text}",
        style: TextStyle(),
      ),
    );
  }

  bottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          color: Colors.amber,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text('Modal BottomSheet'),
                ElevatedButton(
                  child: const Text('Close BottomSheet'),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  // Widget ButtonApply(BuildContext) {
  //   return Container(

  //     padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
  //     decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(10), color: HexColor("#FE4C4C")),
  //     child: Text(
  //       "Apply",
  //       style: TextStyle(
  //           fontSize: 20, color: Colors.white, fontWeight: FontWeight.w500),
  //     ),
  //   );
  // }
}
