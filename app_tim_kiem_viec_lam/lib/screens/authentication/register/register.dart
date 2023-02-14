import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

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
        body: SafeArea(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                  height: deviceHeight * 0.15,
                  child: FittedBox(
                    child: Image.asset('assets/images/avatar.png',
                        height: 200.0, width: 700.0),
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
                        const Text(
                          'Đăng ký',
                          style: TextStyle(
                              fontSize: 32, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: constraints.maxHeight * 0.02,
                        ),
                        Text('Chào mừng bạn đến với Motchill'),
                        SizedBox(
                          height: constraints.maxHeight * 0.06,
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
                                      return "Tên tài khoản không được để trống !";
                                    else {
                                      return null;
                                    }
                                  },
                                  controller: usernameController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Tên tài khoản',
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
                                    hintText: 'Mật khẩu'),
                              ),
                            ),
                          ),
                        ),
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
                                    hintText: 'Nhập lại mật khẩu'),
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
                          text: 'Đã có tài khoản!',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                          children: [
                            TextSpan(
                                text: 'Đăng nhập',
                                style:
                                    TextStyle(color: Colors.red, fontSize: 18),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.pushNamed(
                                        context, AppRoutes.LoginRoute,
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
