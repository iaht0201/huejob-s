import 'package:app_tim_kiem_viec_lam/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:app_tim_kiem_viec_lam/data/onboaring/dataOnboaring.dart';

import '../authentication/login/login.dart';

class OnBoaring extends StatefulWidget {
  const OnBoaring({super.key});

  @override
  State<OnBoaring> createState() => _OnBoaringState();
}

class _OnBoaringState extends State<OnBoaring> {
  int currentIndex = 0;
  // Chuyen page
  late PageController _controller;

  void initState() {
    _controller = PageController(initialPage: 0);
    super.initState();
  }

  handleShowButton(BuildContext context, int currentIndexm) {
    if (currentIndex == 1 || currentIndex == 2) {
      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 12.w,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginView()));
              },
              child: Text(
                "Bỏ qua",
                style: textTheme.medium(color: "95969D"),
                textAlign: TextAlign.center,
              ),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(HexColor("#BB2649")),
              ),
              onPressed: () {
                _controller.nextPage(
                  duration: Duration(milliseconds: 100),
                  curve: Curves.bounceIn,
                );
              },
              child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 16.h, horizontal: 61.5.w),
                  child: Text(
                    "Tiếp tục",
                    style: textTheme.medium(color: "FFFFFF"),
                    textAlign: TextAlign.center,
                  )),
            ),
          ],
        ),
      );
    } else if (currentIndex == 3) {
      return ElevatedButton(
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all<Color>(HexColor("#BB2649")),
        ),
        onPressed: () {
          _controller.nextPage(
            duration: Duration(milliseconds: 100),
            curve: Curves.bounceIn,
          );
        },
        child: Container(
            width: 1.sh,
            margin: EdgeInsets.symmetric(horizontal: 8.w),
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: GestureDetector(
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginView()));
              },
              child: Text(
                "Tham gia ngay",
                style: textTheme.medium(color: "FFFFFF"),
                textAlign: TextAlign.center,
              ),
            )),
      );
    } else {
      return Container();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: 1.sh,
          width: 1.sw,
          color: HexColor("FFFFFF"),
          // padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: 416.h - 300.h,
                    width: 416.w,
                  ),
                  Positioned(
                    left: -18.w,
                    top: -300.h,
                    child: Container(
                        decoration: BoxDecoration(
                            color: HexColor("#BB2649").withOpacity(0.2),
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(350.r),
                                bottomRight: Radius.circular(350.r)))),
                    height: 416.h,
                    width: 416.w,
                  ),
                ],
              ),
              SizedBox(
                height: 35.h,
              ),
              Expanded(
                  child: PageView.builder(
                controller: _controller,
                itemCount: onBoaringdata.length,
                onPageChanged: (int index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 45.w),
                          child: Image.asset(
                            '${onBoaringdata[index].image}',
                            height: 300.h,
                            width: 300.w,
                          )),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 44.w),
                        child: Column(
                          children: [
                            Center(
                                child: Text(
                              "${onBoaringdata[index].title}",
                              style: textTheme.headline1,
                            )),
                            SizedBox(
                              height: 18.h,
                            ),
                            Wrap(
                              children: [
                                Text(
                                  "${onBoaringdata[index].discription}",
                                  style: textTheme.description(color: "95969D"),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 56.h,
                            ),
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  onBoaringdata.length,
                                  (index) => buildDot(index, context),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 72.h,
                            ),
                            handleShowButton(context, currentIndex)
                          ],
                        ),
                      )
                    ],
                  );
                },
              ))
            ],
          )),
    );
  }

  Container buildDot(int index, BuildContext context) {
    return Container(
      height: 10.h,
      width: currentIndex == index ? 25.w : 10.w,
      margin: EdgeInsets.only(right: 5.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: HexColor("#BB2649"),
      ),
    );
  }
}
