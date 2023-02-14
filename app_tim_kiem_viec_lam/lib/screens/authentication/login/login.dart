import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

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
        body: SafeArea(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                  height: deviceHeight * 0.25,
                  child: FittedBox(
                    child: Image.asset('assets/images/logo3.png',
                        height: 320.0, width: 700.0),
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
                        const Text(
                          'Đăng Nhập',
                          style: TextStyle(
                              fontSize: 32, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: constraints.maxHeight * 0.02,
                        ),
                        Text('Chào mừng bạn trở lại với Motchill'),
                        SizedBox(
                          height: constraints.maxHeight * 0.08,
                        ),
                        Container(
                            height: constraints.maxHeight * 0.12,
                            decoration: BoxDecoration(
                              color: const Color(0xffB4B4B4).withOpacity(0.4),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(left: 15),
                              child: Center(
                                child: TextFormField(
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
                                  ),
                                ),
                              ),
                            )),
                        SizedBox(height: constraints.maxHeight * 0.04),
                        Container(
                          height: constraints.maxHeight * 0.12,
                          decoration: BoxDecoration(
                            color: const Color(0xffB4B4B4).withOpacity(0.4),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: Center(
                              child: TextFormField(
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
                                    hintText: 'Mật khẩu'),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                                onPressed: () {},
                                child: const Text('Quên mật khẩu?',
                                    style: TextStyle(
                                      color: Colors.red,
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

                                // Navigator.pushNamed(

                                //     context, AppRoutes.SplashRoutes,
                                //     arguments: "a");
                              },
                              child: Text('Đăng nhập',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22)),
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.red,
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
                            color: Colors.black,
                            fontSize: 18,
                          ),
                          children: [
                            TextSpan(
                                text: ' Đăng ký',
                                style:
                                    TextStyle(color: Colors.red, fontSize: 18),
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
      ),
    ));
  }
}
