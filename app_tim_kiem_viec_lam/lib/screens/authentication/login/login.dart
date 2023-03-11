import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import 'package:provider/provider.dart';

import '../../../core/providers/authenciation_provider.dart';
import '../../../core/routes/routes.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  // show or not show
  var _isVisible = false;
  final _supabaseClient = AuthenciationNotifier();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            ColorFiltered(
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.6), BlendMode.multiply),
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
                      height: deviceHeight * 0.25,
                      child: FittedBox(
                        child: Image.asset(
                          'assets/images/logo_huejob.png',
                          fit: BoxFit.fitWidth,
                        ),
                      )),
                  Container(
                    height: deviceHeight * 0.65,
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: LayoutBuilder(
                      builder: (ctx, constraints) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Đăng Nhập',
                              style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: HexColor("#FFFFFF").withOpacity(1)),
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
                              height: constraints.maxHeight * 0.08,
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
                                          fillColor: Colors.white,
                                          hintStyle:
                                              TextStyle(color: Colors.white)),
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
                                        return "Mật khẩu không được để trống";
                                      else if (value.length < 5) {
                                        return "Mật khẩu không hợp lệ";
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
                                        hintStyle:
                                            TextStyle(color: Colors.white)),
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                    onPressed: () {},
                                    child: Text('Quên mật khẩu?',
                                        style: TextStyle(
                                          color: HexColor("#BB2649"),
                                        )))
                              ],
                            ),
                            Container(
                              width: double.infinity,
                              height: constraints.maxHeight * 0.12,
                              margin: EdgeInsets.only(
                                top: constraints.maxHeight * 0.03,
                              ),
                              child: ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      _supabaseClient.SigninnUser(context,
                                          email: emailController.text,
                                          password: passwordController.text);
                                    }
                                  },
                                  child: Text('Đăng nhập',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22)),
                                  style: ElevatedButton.styleFrom(
                                      primary: HexColor("#BB2649"),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16)))),
                            ),
                            SizedBox(
                              height: constraints.maxHeight * 0.03,
                            ),
                            RichText(
                                text: TextSpan(
                              text: 'Chưa có tài khoản!',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                              children: [
                                TextSpan(
                                    text: ' Đăng ký',
                                    style: TextStyle(
                                        color: HexColor("#BB2649"),
                                        fontSize: 18),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.pushNamed(
                                            context, AppRoutes.SignupRoutes,
                                            arguments: "a");
                                      })
                              ],
                            )),
                          ],
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
