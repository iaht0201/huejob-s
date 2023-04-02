// import 'package:app_tim_kiem_viec_lam/screens/authentication/login/login.dart';
// import 'package:app_tim_kiem_viec_lam/screens/authentication/register/register.dart';
// import "package:flutter/material.dart";
// import 'package:hexcolor/hexcolor.dart';
// import "package:app_tim_kiem_viec_lam/utils/constant.dart" ;
// class OnBoaring extends StatefulWidget {
//   const OnBoaring({super.key});

//   @override
//   State<OnBoaring> createState() => _OnBoaringState();
// }

// class _OnBoaringState extends State<OnBoaring> {
//   @override
//   Widget build(BuildContext context) {
//     final deviceHeight = MediaQuery.of(context).size.height;
//     final deviceWidth = MediaQuery.of(context).size.width;
//     return Scaffold(
//       body: Container(
//         height: double.infinity,
//         width: double.infinity,
//         color: HexColor("#BB2649"),
//         child: Column(
//           children: [
//             // Text
//             Expanded(
//                 flex: 3,
//                 child: Padding(
//                   padding: EdgeInsets.only(top: 33, left: 24, right: 24),
//                   child: Column(
//                     children: [
//                       Text(
//                         "Huejob’s - Nơi bạn bắt đầu sự nghiệp thành công",
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             // fontSize: 26,
//                             fontSize: deviceWidth * 0.06,
//                             color: Colors.white,
//                             letterSpacing: 1,
//                             height: 1.1),
//                       ),
//                       SizedBox(
//                         height: 7,
//                       ),
//                       Text(
//                           "Hãy cùng chúng tôi tìm kiếm việc làm, xây dựng tương lai ngay bây giờ! ",
//                           style:  textTheme.description(color: "FFFFFF")
//                           // TextStyle(
//                           //     fontWeight: FontWeight.w400,
//                           //     fontSize: deviceWidth * 0.03,
//                           //     // fontSize: 14,
//                           //     color: Colors.white.withOpacity(0.7),
//                           //     letterSpacing: 1.5,
//                           //     height: 1.7)

//                               )
//                     ],
//                   ),
//                 )),
//             Expanded(
//                 flex: 8,
//                 child: Container(
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     image: DecorationImage(
//                       fit: BoxFit.cover,
//                       image: AssetImage(
//                         'assets/images/logohuejob.png',
//                       ),
//                     ),
//                   ),
//                 )),
//             Expanded(
//                 flex: 2,
//                 child: Padding(
//                   padding: const EdgeInsets.only(left: 24, right: 24, top: 20),
//                   child: Center(
//                     child: Column(
//                       children: [
//                         Container(
//                           width: double.infinity,
//                           margin: EdgeInsets.only(
//                             top: 0.03,
//                           ),
//                           child: ElevatedButton(
//                               onPressed: () {
//                                 Navigator.pushReplacement(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (context) => SignupView()));
//                               },
//                               child: Container(
//                                 padding: EdgeInsets.symmetric(
//                                     horizontal: 10, vertical: 14),
//                                 child: Text('Tham gia với chúng tôi',
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       // fontSize: 22
//                                       fontSize: deviceWidth * 0.05,
//                                     )),
//                               ),
//                               style: ElevatedButton.styleFrom(
//                                   primary: HexColor("#FE904B"),
//                                   shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(8)))),
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text("Bạn đã có tài khoản ? ",
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.w400,
//                                     fontSize: deviceWidth * 0.03,
//                                     // fontSize: 14,
//                                     color: Colors.white,
//                                     letterSpacing: 1.5,
//                                     height: 1.7)),
//                             SizedBox(
//                               height: 10,
//                             ),
//                             GestureDetector(
//                               onTap: () {
//                                 Navigator.pushReplacement(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (context) => LoginView()));
//                               },
//                               child: Text("Đăng nhập",
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.w500,
//                                       // fontSize: 14,
//                                       fontSize: deviceWidth * 0.03,
//                                       color: HexColor('#FB724C'),
//                                       letterSpacing: 1.5,
//                                       height: 1.7)),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ))
//           ],
//         ),
//       ),
//     );
//   }
// }
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
                "Skip",
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
                    "Next",
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
                "Explore",
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
                    height: 416.h - 274.h,
                    width: 416.w,
                  ),
                  Positioned(
                    left: -18.w,
                    top: -274.h,
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
                            // Padding(
                            //   padding: EdgeInsets.symmetric(
                            //     horizontal: 12.w,
                            //   ),
                            //   child: Row(
                            //     mainAxisAlignment:
                            //         MainAxisAlignment.spaceBetween,
                            //     children: [
                            //       Text(
                            //         "Skip",
                            //         style: textTheme.medium(color: "95969D"),
                            //         textAlign: TextAlign.center,
                            //       ),
                            //       ElevatedButton(
                            //         style: ButtonStyle(
                            //           backgroundColor:
                            //               MaterialStateProperty.all<Color>(
                            //                   HexColor("#BB2649")),
                            //         ),
                            //         onPressed: () {
                            //           _controller.nextPage(
                            //             duration: Duration(milliseconds: 100),
                            //             curve: Curves.bounceIn,
                            //           );
                            //         },
                            //         child: Padding(
                            //             padding: EdgeInsets.symmetric(
                            //                 vertical: 16.h, horizontal: 61.5.w),
                            //             child: Text(
                            //               "Next",
                            //               style:
                            //                   textTheme.medium(color: "FFFFFF"),
                            //               textAlign: TextAlign.center,
                            //             )),
                            //       ),
                            //     ],
                            //   ),
                            // )
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
