import 'package:app_tim_kiem_viec_lam/core/providers/authenciation_provider.dart';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../core/models/user_model.dart';
import '../../core/providers/post_provider.dart';
import '../../core/providers/user_provider.dart';

import '../../widgets/textfiled_widget.dart';

class EditProfile extends StatefulWidget {
  EditProfile({super.key, this.user});
  UserModel? user;
  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  String? _fullname;
  int? _gender;
  DateTime _birthday = DateTime.now();
  String? _address;
  int? _phoneNumber;
  String? _experience;
  String? _job;
  String? _status;
  String? _imageUrl;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late UserProvider userProvider;

  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<UserProvider>(context, listen: false);
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _birthday,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _birthday)
      setState(() {
        _birthday = picked;
      });
  }

  Widget build(BuildContext context) {
    final imageProvider = Provider.of<PostProvider>(context);
    final provider = Provider.of<AuthenciationNotifier>(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
              pinned: true,
              floating: false,
              delegate: _MyHeader(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: buttonArrow(context),
                  ),
                  Expanded(
                    flex: 10,
                    child: Center(
                      child: Text(
                        "Chỉnh sửa thông tin",
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(color: Colors.black),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(),
                  ),
                ],
              ))),
          SliverList(
              delegate: SliverChildListDelegate([
            Consumer<UserProvider>(
              builder: (context, userProvider, _) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 24),
                        TextFieldWidget(
                          label: 'Tên tài khoản',
                          text: "${userProvider.user?.name}",
                          enbled: false,
                          onChanged: (name) {
                            // Không thể thay đổi
                          },
                        ),
                        const SizedBox(height: 24),
                        TextFieldWidget(
                          enbled: false,
                          label: 'Email',
                          text: "${userProvider.user?.email}",
                          onChanged: (email) {
                            // Không thể thay đổi
                          },
                        ),
                        TextFieldWidget(
                          enbled: true,
                          label: 'Họ và tên',
                          text: "${userProvider.user?.fullname ?? ""} ",
                          onChanged: (fullname) {
                            fullname == ""
                                ? _fullname = userProvider.user?.fullname
                                : _fullname = fullname;
                            print(fullname);
                          },
                        ),
                        TextFieldWidget(
                          enbled: true,
                          label: 'Giới tính',
                          text: "${userProvider.user?.gender ?? ""} ",
                          onChanged: (gender) {
                            gender == 0 || gender == 1
                                ? _gender = int.parse(gender)
                                : _gender = userProvider.user!.gender;
                          },
                        ),
                        Row(
                          children: [
                            Text("Ngày sinh"),
                            Text(
                              '${_birthday.day}/${_birthday.month}/${_birthday.year}',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            TextButton(
                                onPressed: () => _selectDate(context),
                                child: Text("Lựa chọn")),
                          ],
                        ),
                        TextFieldWidget(
                          enbled: true,
                          label: 'Số điện thoại',
                          text: "${userProvider.user?.phone_number ?? ""} ",
                          onChanged: (phone_number) {
                            phone_number == ""
                                ? userProvider.user?.phone_number
                                : _phoneNumber = int.parse(phone_number);
                            // _phoneNumber = phone_number as int?;
                          },
                        ),
                        TextFieldWidget(
                          enbled: true,
                          label: 'Kinh nghiệm',
                          text: "${userProvider.user?.experience ?? ""} ",
                          onChanged: (experience) {
                            experience == ""
                                ? _experience = userProvider.user?.experience
                                : _experience = experience;
                          },
                        ),
                        TextFieldWidget(
                          enbled: true,
                          label: 'Nghề nghiệp',
                          text: "${userProvider.user?.job ?? ""} ",
                          onChanged: (job) {
                            print(job);
                            job == ""
                                ? _job = userProvider.user?.job
                                : _job = job;
                          },
                        ),
                        const SizedBox(height: 24),
                        TextFieldWidget(
                          enbled: true,
                          label: 'Ghi chú',
                          text: "${userProvider.user?.status ?? ""}",
                          maxLines: 5,
                          onChanged: (status) {
                            status == null
                                ? _status = userProvider.user?.status
                                : _status = status;
                          },
                        ),
                        Container(
                          width: double.infinity,
                          // height: MediaQuery.of(context).size.height * 0.012,
                          margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.012,
                          ),
                          child: ElevatedButton(
                              onPressed: () async {
                                final newUser = UserModel(
                                    userId: userProvider.user!.userId,
                                    name: userProvider.user!.name,
                                    address:
                                        _address ?? userProvider.user.address,
                                    birthday: _birthday.toIso8601String(),
                                    job: _job ?? userProvider.user.address,
                                    email: userProvider.user!.email,
                                    experience: _experience ??
                                        userProvider.user.experience,
                                    fullname:
                                        _fullname ?? userProvider.user.fullname,
                                    gender: _gender,
                                    phone_number: _phoneNumber,
                                    status: _status ?? userProvider.user.status,
                                    imageUrl: userProvider.user!.imageUrl,
                                    usertype: userProvider.user.usertype);
                                userProvider.updateUser(context, newUser);
                              },
                              child: Container(
                                padding: EdgeInsets.all(
                                  15,
                                ),
                                child: Text('Hoàn tất',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22)),
                              ),
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.red,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(16)))),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          ])),
        ],
      ),
    );
  }

  buttonArrow(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(20.0),
        child: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
              clipBehavior: Clip.hardEdge,
              height: 55,
              width: 55,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(25)),
              child: Icon(Icons.arrow_back_ios)),
        ));
  }
}

class _MyHeader extends SliverPersistentHeaderDelegate {
  _MyHeader({required this.child});

  final Widget child;

  @override
  double get minExtent => 80.0;

  @override
  double get maxExtent => 80.0;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: child,
    );
  }

  @override
  bool shouldRebuild(_MyHeader oldDelegate) {
    return false;
  }
}
