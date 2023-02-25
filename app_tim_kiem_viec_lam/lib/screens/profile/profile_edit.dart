import 'package:app_tim_kiem_viec_lam/core/providers/authenciation_provider.dart';
import 'package:app_tim_kiem_viec_lam/core/providers/job_provider.dart';
import 'package:app_tim_kiem_viec_lam/core/routes/routes.dart';
import 'package:app_tim_kiem_viec_lam/core/supabase/supabase.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/models/user_model.dart';
import '../../widgets/Profile_widget.dart';
import '../../widgets/Textfiled_widget.dart';

class EditProfile extends StatefulWidget {
  EditProfile({super.key, this.user});
  UserModel? user;
  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  String? _fullname;
  int _gender = 0;
  DateTime _birthday = DateTime.now();
  String? _address;
  int? _phoneNumber;
  String? _experience;
  String? _education;
  String? _status;
  String? _imageUrl;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  void initState() {
    super.initState();
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

  void updateImageUrl(String url) {
    setState(() {
      _imageUrl = url;
      print(_imageUrl);
    });
  }

  Widget build(BuildContext context) {
    final imageProvider = Provider.of<JobProvider>(context);

    return Scaffold(
      body: Form(
        key: _formKey,
        child: Stack(
          children: [
            SizedBox(
              width: double.infinity,
              child: Image.network(
                  "https://scontent.fhan14-2.fna.fbcdn.net/v/t1.6435-9/186108637_2905919732980317_6630388559144209132_n.jpg?_nc_cat=106&ccb=1-7&_nc_sid=e3f864&_nc_ohc=12h0bSodmTgAX-5Pw4u&_nc_ht=scontent.fhan14-2.fna&oh=00_AfA8vAiCrvQxMvVpj8DNl0ml4EQe7S4JCEC6Bsg3e4ixhg&oe=641FA289"),
            ),
            Positioned(
                top: 150, // căn giữa theo chiều dọc
                bottom: 0, // căn giữa theo chiều dọc
                left: 25, // căn giữa theo chiều ngang
                right: 25, // căn giữa theo chiều ngang

                child: ProfileWidget(
                    onImageUrlChanged: updateImageUrl,
                    initials:
                        "${widget.user!.name.toString().substring(0, 1).toUpperCase()}")),
            Positioned(child: Container()),
            buttonArrow(context),
            _scroll(context)
          ],
        ),
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

  _scroll(BuildContext context) {
    final provider = Provider.of<AuthenciationNotifier>(context);
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      maxChildSize: 0.81,
      minChildSize: 0.5,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                const SizedBox(height: 24),
                TextFieldWidget(
                  label: 'Tên tài khoản',
                  text: "${widget.user?.name}",
                  enbled: false,
                  onChanged: (name) {
                    // _name = name;
                    // print(_name);
                  },
                ),
                const SizedBox(height: 24),
                TextFieldWidget(
                  enbled: false,
                  label: 'Email',
                  text: "${widget.user?.email}",
                  onChanged: (email) {},
                ),
                TextFieldWidget(
                  enbled: true,
                  label: 'Họ và tên',
                  text:
                      "${widget.user?.fullname != null ? widget.user?.fullname : ""} ",
                  onChanged: (fullname) {
                    _fullname = fullname;
                  },
                ),
                TextFieldWidget(
                  enbled: true,
                  label: 'Giới tính',
                  text:
                      "${widget.user?.gender != null ? widget.user?.gender : ""} ",
                  onChanged: (email) {},
                ),
                Row(
                  children: [
                    Text("Ngày sinh"),
                    TextButton(
                        onPressed: () => _selectDate(context),
                        child: Text("Lựa chọn")),
                  ],
                ),
                TextFieldWidget(
                  enbled: true,
                  label: 'Số điện thoại',
                  text:
                      "${widget.user?.phone_number != null ? widget.user?.phone_number : ""} ",
                  onChanged: (email) {},
                ),
                TextFieldWidget(
                  enbled: true,
                  label: 'Kinh nghiệm',
                  text:
                      "${widget.user?.experience != null ? widget.user?.experience : ""} ",
                  onChanged: (email) {},
                ),
                TextFieldWidget(
                  enbled: true,
                  label: 'Học vấn',
                  text:
                      "${widget.user?.education != null ? widget.user?.education : ""} ",
                  onChanged: (email) {},
                ),
                const SizedBox(height: 24),
                TextFieldWidget(
                  enbled: true,
                  label: 'Ghi chú',
                  text: "sdasdasdasdasdasdasdasdasd",
                  maxLines: 5,
                  onChanged: (about) {},
                ),
                Container(
                  width: double.infinity,
                  // height: MediaQuery.of(context).size.height * 0.012,
                  margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.012,
                  ),
                  child: ElevatedButton(
                      onPressed: () {
                        Future<void> updateUser() async {
                          final prefs = await SharedPreferences.getInstance();
                          final updates = {
                           
                            'userId': prefs.getString('id'),
                            'fullname': _fullname,
                            "imageUrl" : _imageUrl
                          };
                          try {
                            await SupabaseBase.supabaseClient
                                .from('users')
                                .update(updates)
                                .eq('userId', prefs.getString('id'))
                                .execute();
                            await provider.getData();
                          } catch (e) {
                            print(e);
                          }
                        }

                        updateUser();
                      },
                      child: Container(
                        padding: EdgeInsets.all(
                          15,
                        ),
                        child: Text('Hoàn tất',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 22)),
                      ),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.red,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)))),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
