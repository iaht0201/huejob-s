import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../core/providers/authenciation_provider.dart';
import '../../../core/routes/routes.dart';

class SignupView extends StatefulWidget {
  const SignupView({Key? key}) : super(key: key);

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final _supabaseClient = AuthenciationNotifier();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var _isVisible = false;
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    usernameController = TextEditingController();
    confirmpasswordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        body: (SingleChildScrollView(
            child: Stack(children: [
      ColorFiltered(
        colorFilter:
            ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.multiply),
        child: Image.asset(
          'assets/images/photo1.png',
          height: deviceHeight * 1,
          width: deviceWidth * 1,
          fit: BoxFit.fitWidth,
          alignment: Alignment.topCenter,
        ),
      ),
      Form(
        key: _formKey,
        child: Column(
          children: [
            Container(
                width: deviceWidth * 1,
                height: deviceHeight * 0.2,
                child: FittedBox(
                  child: Image.asset(
                    'assets/images/logo_huejob.png',
                    fit: BoxFit.fitWidth,
                  ),
                )),
            Container(
              height: deviceHeight * 0.75,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: LayoutBuilder(
                builder: (ctx, constraints) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Đăng ký',
                        style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: HexColor("#BB2649")),
                      ),
                      SizedBox(
                        height: constraints.maxHeight * 0.02,
                      ),
                      Text(
                        "Chào mừng bạn đến với HueJob's !",
                        style: TextStyle(
                            color: HexColor("#FFFFFF").withOpacity(0.8)),
                      ),
                      SizedBox(
                        height: constraints.maxHeight * 0.06,
                      ),
                      Container(
                          height: constraints.maxHeight * 0.12,
                          decoration: BoxDecoration(
                            color: HexColor("#FFFFFF").withOpacity(0.4),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(left: 15),
                            child: Center(
                              child: TextFormField(
                                style: TextStyle(color: Colors.white),
                                validator: (value) {
                                  if (value == null || value.isEmpty)
                                    return "Tên tài khoản không được để trống !";
                                  else {
                                    return null;
                                  }
                                },
                                controller: usernameController,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Tên tài khoản',
                                    hintStyle: TextStyle(color: Colors.white)),
                              ),
                            ),
                          )),
                      SizedBox(height: constraints.maxHeight * 0.04),
                      Container(
                          height: constraints.maxHeight * 0.12,
                          decoration: BoxDecoration(
                            color: HexColor("#FFFFFF").withOpacity(0.4),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(left: 15),
                            child: Center(
                              child: TextFormField(
                                style: TextStyle(color: Colors.white),
                                validator: (value) {
                                  if (value == null || value.isEmpty)
                                    return "Email không được để trống !";
                                  else if (!value.contains("@")) {
                                    return "Email không hợp lệ!";
                                  } else {
                                    return null;
                                  }
                                },
                                controller: emailController,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Email',
                                    hintStyle: TextStyle(color: Colors.white)),
                              ),
                            ),
                          )),
                      SizedBox(height: constraints.maxHeight * 0.04),
                      Container(
                        height: constraints.maxHeight * 0.12,
                        decoration: BoxDecoration(
                          color: HexColor("#FFFFFF").withOpacity(0.4),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: Center(
                            child: TextFormField(
                              style: TextStyle(color: Colors.white),
                              validator: (value) {
                                if (value == null || value.isEmpty)
                                  return "Mật không được để trống !";
                                else if (value.toString().length < 8) {
                                  return "Mật khẩu phải có ít nhất 8 ký tự!";
                                } else {
                                  return null;
                                }
                              },
                              controller: passwordController,
                              obscureText: _isVisible ? false : true,
                              decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _isVisible = !_isVisible;
                                        });
                                      },
                                      icon: Icon(
                                          _isVisible
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: Colors.grey)),
                                  border: InputBorder.none,
                                  hintText: 'Mật khẩu',
                                  hintStyle: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: constraints.maxHeight * 0.04),
                      Container(
                        height: constraints.maxHeight * 0.12,
                        decoration: BoxDecoration(
                          color: HexColor("#FFFFFF").withOpacity(0.4),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: Center(
                            child: TextFormField(
                              style: TextStyle(color: Colors.white),
                              validator: (value) {
                                if (value == null || value.isEmpty)
                                  return "Vui lòng nhập lại mật khẩu !";
                                else if (value != passwordController.text) {
                                  return "Mật khẩu không khớp !";
                                } else {
                                  return null;
                                }
                              },
                              controller: confirmpasswordController,
                              obscureText: _isVisible ? false : true,
                              decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _isVisible = !_isVisible;
                                        });
                                      },
                                      icon: Icon(
                                          _isVisible
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: Colors.grey)),
                                  border: InputBorder.none,
                                  hintText: 'Nhập lại mật khẩu',
                                  hintStyle: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: constraints.maxHeight * 0.12,
                        margin: EdgeInsets.only(
                          top: constraints.maxHeight * 0.04,
                        ),
                        child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _supabaseClient.SignupUser(
                                  context,
                                  email: emailController.text,
                                  password: passwordController.text,
                                  username: usernameController.text,
                                );
                              }
                            },
                            child: Text('Đăng ký',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 22)),
                            style: ElevatedButton.styleFrom(
                                primary: HexColor("#BB2649"),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16)))),
                      ),
                      SizedBox(
                        height: constraints.maxHeight * 0.03,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Đã có tài khoản?',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, AppRoutes.LoginRoute,
                                  arguments: "a");
                            },
                            child: Text(
                              'Đăng nhập',
                              style: TextStyle(
                                  color: HexColor("#BB2649"), fontSize: 18),
                            ),
                          ),
                        ],
                      )
                      // RichText(
                      //     text: TextSpan(
                      //   text: 'Đã có tài khoản!',
                      //   style: TextStyle(
                      //     color: Colors.white.withOpacity(0.7),
                      //     fontSize: 18,
                      //   ),
                      //   children: [

                      //   ],
                      // )),
                    ],
                  );
                },
              ),
            )
          ],
        ),
      )
    ]))));
  }
}
