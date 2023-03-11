import 'package:app_tim_kiem_viec_lam/screens/authentication/login/login.dart';
import 'package:app_tim_kiem_viec_lam/screens/authentication/register/register.dart';
import "package:flutter/material.dart";
import 'package:hexcolor/hexcolor.dart';

class OnBoaring extends StatefulWidget {
  const OnBoaring({super.key});

  @override
  State<OnBoaring> createState() => _OnBoaringState();
}

class _OnBoaringState extends State<OnBoaring> {
  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: HexColor("#BB2649"),
        child: Column(
          children: [
            // Text
            Expanded(
                flex: 3,
                child: Padding(
                  padding: EdgeInsets.only(top: 33, left: 24, right: 24),
                  child: Column(
                    children: [
                      Text(
                        "Huejob’s - Nơi bạn bắt đầu sự nghiệp thành công",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            // fontSize: 26,
                            fontSize: deviceWidth * 0.06,
                            color: Colors.white,
                            letterSpacing: 1,
                            height: 1.1),
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      Text(
                          "Hãy cùng chúng tôi tìm kiếm việc làm, xây dựng tương lai ngay bây giờ! ",
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: deviceWidth * 0.03,
                              // fontSize: 14,
                              color: Colors.white.withOpacity(0.7),
                              letterSpacing: 1.5,
                              height: 1.7))
                    ],
                  ),
                )),
            Expanded(
                flex: 8,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(
                        'assets/images/logohuejob.png',
                      ),
                    ),
                  ),
                )),
            Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.only(left: 24, right: 24, top: 20),
                  child: Center(
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(
                            top: 0.03,
                          ),
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignupView()));
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 14),
                                child: Text('Tham gia với chúng tôi',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      // fontSize: 22
                                      fontSize: deviceWidth * 0.05,
                                    )),
                              ),
                              style: ElevatedButton.styleFrom(
                                  primary: HexColor("#FE904B"),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)))),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Bạn đã có tài khoản ? ",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: deviceWidth * 0.03,
                                    // fontSize: 14,
                                    color: Colors.white,
                                    letterSpacing: 1.5,
                                    height: 1.7)),
                            SizedBox(
                              height: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginView()));
                              },
                              child: Text("Đăng nhập",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      // fontSize: 14,
                                      fontSize: deviceWidth * 0.03,
                                      color: HexColor('#FB724C'),
                                      letterSpacing: 1.5,
                                      height: 1.7)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
