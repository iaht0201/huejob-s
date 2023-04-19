import 'package:app_tim_kiem_viec_lam/core/models/usetype_model.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/authenciation_provider.dart';
import '../../../core/providers/user_provider.dart';
import '../../../core/routes/routes.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

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
  var _confirm = false;
  late UserProvider userProvider;
  List<String> itemsType = ['Người tìm việc', 'Nhà tuyển dụng'];
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    usernameController = TextEditingController();
    confirmpasswordController = TextEditingController();
    userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.fetchUseType();
  }

  String? selectedValue;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: (SingleChildScrollView(
            child: Stack(children: [
      ColorFiltered(
        colorFilter:
            ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.multiply),
        child: Image.asset(
          'assets/images/photo1.png',
          height: 1.sh,
          width: 2.sw,
          fit: BoxFit.fitWidth,
          alignment: Alignment.topCenter,
        ),
      ),
      Form(
        key: _formKey,
        child: Column(
          children: [
            Container(
                width: 1.sw,
                height: 0.2.sh,
                child: FittedBox(
                  child: Image.asset(
                    'assets/images/logo_huejob.png',
                    fit: BoxFit.fitWidth,
                  ),
                )),
            Container(
              height: 0.75.sh,
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 20.w),
              child: LayoutBuilder(
                builder: (ctx, constraints) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Đăng ký',
                        style: TextStyle(
                            fontSize: 32.sp,
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
                        height: constraints.maxHeight * 0.06.h,
                      ),

                      _confirm == false
                          ? Consumer<UserProvider>(
                              builder: (context, userProvider, child) {
                                // dropdownValue = userProvider.userType!.first.id;
                                return DropdownButtonFormField2(
                                  decoration: InputDecoration(
                                    isDense: true,
                                    fillColor: Colors.white,
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  buttonHeight: 35,
                                  isExpanded: true,
                                  hint: Text(
                                    'Lựa chọn',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.black),
                                  ),
                                  selectedItemHighlightColor: Colors.green,
                                  items: itemsType
                                      .map((String item) =>
                                          DropdownMenuItem<String>(
                                              value: item,
                                              child: Text(
                                                item,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              )))
                                      .toList(),
                                  validator: (value) {},
                                  onChanged: (value) {
                                    selectedValue = value;

                                    print(value);
                                  },
                                );
                              },
                            )
                          : Column(
                              children: [
                                Container(
                                    height: constraints.maxHeight * 0.12.h,
                                    decoration: BoxDecoration(
                                      color:
                                          HexColor("#FFFFFF").withOpacity(0.4),
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
                                              hintStyle: TextStyle(
                                                  color: Colors.white)),
                                        ),
                                      ),
                                    )),
                                SizedBox(
                                    height: constraints.maxHeight * 0.04.h),
                                Container(
                                    // height: constraints.maxHeight * 0.12.h,
                                    decoration: BoxDecoration(
                                      color:
                                          HexColor("#FFFFFF").withOpacity(0.4),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 15.w),
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
                                              hintStyle: TextStyle(
                                                  color: Colors.white)),
                                        ),
                                      ),
                                    )),
                                SizedBox(
                                    height: constraints.maxHeight * 0.04.h),
                                Container(
                                  height: constraints.maxHeight * 0.12.h,
                                  decoration: BoxDecoration(
                                    color: HexColor("#FFFFFF").withOpacity(0.4),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 16.w),
                                    child: Center(
                                      child: TextFormField(
                                        style: TextStyle(color: Colors.white),
                                        validator: (value) {
                                          if (value == null || value.isEmpty)
                                            return "Mật không được để trống !";
                                          else if (value.toString().length <
                                              8) {
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
                                            hintStyle:
                                                TextStyle(color: Colors.white)),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                    height: constraints.maxHeight * 0.04.h),
                                Container(
                                  height: constraints.maxHeight * 0.12.h,
                                  decoration: BoxDecoration(
                                    color: HexColor("#FFFFFF").withOpacity(0.4),
                                    borderRadius: BorderRadius.circular(16.r),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 16),
                                    child: Center(
                                      child: TextFormField(
                                        style: TextStyle(color: Colors.white),
                                        validator: (value) {
                                          if (value == null || value.isEmpty)
                                            return "Vui lòng nhập lại mật khẩu !";
                                          else if (value !=
                                              passwordController.text) {
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
                                            hintStyle:
                                                TextStyle(color: Colors.white)),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                      _confirm == false
                          ? Container(
                              width: double.infinity,
                              height: constraints.maxHeight * 0.12.h,
                              margin: EdgeInsets.only(
                                top: constraints.maxHeight * 0.04.h,
                              ),
                              child: ElevatedButton(
                                  onPressed: () {
                                    if (selectedValue == null) {
                                      Fluttertoast.showToast(
                                        msg: 'Vui lòng không được để trống',
                                        gravity: ToastGravity.BOTTOM,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                      );
                                    } else {
                                      setState(() {
                                        _confirm = true;
                                      });
                                    }
                                  },
                                  child: Text('Tiếp tục',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22)),
                                  style: ElevatedButton.styleFrom(
                                      primary: HexColor("#BB2649"),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16)))),
                            )
                          : Container(
                              width: double.infinity,
                              height: constraints.maxHeight * 0.12.h,
                              margin: EdgeInsets.only(
                                top: constraints.maxHeight * 0.04.h,
                              ),
                              child: ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      _supabaseClient.SignupUser(
                                        context,
                                        userType: selectedValue,
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
                                      primary: HexColor("#BB2649"),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16)))),
                            ),
                      SizedBox(
                        height: constraints.maxHeight * 0.03.h,
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
                                  color: HexColor("#BB2649"), fontSize: 18.sp),
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
