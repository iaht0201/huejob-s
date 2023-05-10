import 'dart:convert';

import 'package:app_tim_kiem_viec_lam/core/providers/authenciation_provider.dart';
import 'package:app_tim_kiem_viec_lam/utils/constant.dart';
import 'package:app_tim_kiem_viec_lam/widgets/text_field_widgets.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';

import 'package:provider/provider.dart';

import '../../core/models/user_model.dart';
import '../../core/providers/post_provider.dart';
import '../../core/providers/user_provider.dart';

import '../../widgets/picker_cupertino/picker_year.dart';
import '../../widgets/textfiled_widget.dart';
import '../addPost/map.dart';

enum CheckGender { man, woman, other }

class EditProfile extends StatefulWidget {
  EditProfile({super.key, this.user, this.action = "edit_profile"});
  UserModel? user;
  String action;
  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _locationController = TextEditingController();
  // TextFeild khác
  final _formKey = GlobalKey<FormState>();
  final _formKeyExperience = GlobalKey<FormState>();
  final _formKeyEducation = GlobalKey<FormState>();
  String? _fullname;
  int? _gender;
  DateTime _birthday = DateTime.now();
  AddressModel? _address;
  String? _phoneNumber;
  String? _caption;
  String? _status;
  String? _imageUrl;
  String? _familyname;
  String? _firstName;
  List<ExperienceModel> _experiences = [];

  // Kinh nghiem
  String? _jobTitle;
  String? _startDateEx;
  String? _endDateEx;
  String? _companyName;
  String? _descriptionEx;

// Học vấn
  List<EducationModel> _educations = [];
  String? _schoolName;
  String? _degree;
  String? _fieldOfStudy;
  String? _startDateEdu;
  String? _endDateEdu;
  String? _descriptionEdu;
  CheckGender? _character = CheckGender.man;
  PickedData? _pickedData;
  String msgDateTime = "";
  final List<String> _listYear = [];

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  late UserProvider userProvider;

  void _addEducation() {
    setState(() {
      _educations.add(EducationModel(
          schoolName: _schoolName,
          degree: _degree,
          fieldOfStudy: _fieldOfStudy,
          startDate: _startDateEdu,
          endDate: _endDateEdu,
          description: _descriptionEdu));

      _schoolName = null;
      _degree = null;
      _fieldOfStudy = null;
      _startDateEdu = null;
      _endDateEdu = null;
      _descriptionEdu = null;
    });
  }

  void _removeEducation(int index) {
    setState(() {
      _educations.removeAt(index);
    });
  }

  void _addExperience() {
    setState(() {
      _experiences.add(
        ExperienceModel(
          jobTitle: _jobTitle,
          startDate: _startDateEx,
          endDate: _endDateEx,
          company_name: _companyName,
          description: _descriptionEx,
        ),
      );

      _jobTitle = null;
      _startDateEx = null;
      _endDateEx = null;
      _companyName = null;
      _descriptionEx = null;
    });
    print(_experiences);
  }

  void _removeExperience(int index) {
    setState(() {
      _experiences.removeAt(index);
    });
  }

  void yearPicker() {
    int initValueYear = DateTime.now().year;
    for (int i = initValueYear; i > initValueYear - 60; i--) {
      if (_listYear.length >= 60) {
        break;
      }
      setState(() {
        _listYear.add(i.toString());
      });
    }
  }

  @override
  void initState() {
    super.initState();
    yearPicker();
    userProvider = Provider.of<UserProvider>(context, listen: false);
    _experiences = List<ExperienceModel>.from(widget.user?.experience ?? []);
    _address = widget.user?.address;
    _educations = List<EducationModel>.from(widget.user?.education ?? []);
    _character = widget.user?.gender == 1
        ? CheckGender.man
        : (userProvider.user.gender == 0)
            ? CheckGender.woman
            : CheckGender.other;

    _phoneNumber = userProvider.user.phone_number.toString() != "null"
        ? userProvider.user.phone_number.toString()
        : "";

    // userProvider.userByID.phone_number.toString();
    _firstName = widget.user?.firstname ?? "";
    _familyname = widget.user?.familyname ?? "";
    _locationController.text = (widget.user?.address != null
        ? widget.user?.address!.addressName!
        : "")!;

    _caption = widget.user?.caption ?? "";
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

  bool isStartYearMoreThan(String startYear, String endYear) {
    if (startYear.isEmpty && endYear.isEmpty) {
      if (int.parse(startYear.toString()) > int.parse(endYear.toString())) {
        setState(() {
          msgDateTime = "Ngày bắt đầu không thể lớn hơn ngày kết thúc ";
        });
        return true;
      }
    }
    return false;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
                pinned: true,
                floating: false,
                delegate: _MyHeader(
                    child: Padding(
                  padding: EdgeInsets.only(top: 8.h),
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
                            "Cập nhập thông tin",
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
                  ),
                ))),
            SliverList(
                delegate: SliverChildListDelegate([
              Consumer<UserProvider>(
                builder: (context, userProvider, _) {
                  return Container(
                    width: 1.sw,
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                        // color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.r),
                            topRight: Radius.circular(20.r))),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 24.h),
                          TextFieldWid(
                            icon: Icons.person,
                            label: "${userProvider.user?.name}",
                            text: "",
                            enbled: false,
                            onChanged: (value) {},
                          ),
                          SizedBox(height: 12.h),
                          TextFieldWid(
                            icon: Icons.email,
                            label: "${userProvider.user.email}",
                            text: "",
                            enbled: false,
                            onChanged: (value) {},
                          ),
                          SizedBox(height: 12.h),
                          TextFieldWid(
                            icon: Icons.engineering_outlined,
                            label: "${userProvider.user.usertype}",
                            text: "",
                            enbled: false,
                            onChanged: (value) {},
                          ),
                          SizedBox(height: 12.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextFieldWid(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Họ không được để trống';
                                  }
                                  if (RegExp(r'\d').hasMatch(value)) {
                                    return 'Tên không được chứa số';
                                  }
                                  return null;
                                },
                                width: 0.42,
                                label: "Họ",
                                text: _familyname ?? "",
                                enbled: true,
                                onChanged: (value) {
                                  _familyname = value;
                                },
                              ),
                              TextFieldWid(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Tên không được để trống';
                                  }
                                  if (RegExp(r'\d').hasMatch(value)) {
                                    return 'Tên không được chứa số';
                                  }
                                  return null;
                                },
                                width: 0.42,
                                label: "Tên",
                                text: _firstName ?? "",
                                enbled: true,
                                onChanged: (value) {
                                  _firstName = value;
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),
                          _locationFormWidget(context),
                          SizedBox(height: 12.h),
                          Row(
                            children: [
                              Text(
                                "Giới tính: ",
                                style: textTheme.medium14(),
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Nam",
                                    style: textTheme.medium14(),
                                  ),
                                  SizedBox(
                                    width: 3.w,
                                  ),
                                  Radio<CheckGender>(
                                      focusColor: HexColor("#BB2649"),
                                      value: CheckGender.man,
                                      groupValue: _character,
                                      onChanged: (CheckGender? value) {
                                        setState(() {
                                          _character = value;
                                          // _gender = value ;
                                          if (_character == CheckGender.man) {
                                            _gender = 1;
                                          } else if (_character ==
                                              CheckGender.woman) {
                                            _gender = 0;
                                          } else
                                            _gender = 2;
                                        });
                                      }),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Nữ",
                                    style: textTheme.medium14(),
                                  ),
                                  SizedBox(
                                    width: 3.w,
                                  ),
                                  Radio<CheckGender>(
                                      value: CheckGender.woman,
                                      groupValue: _character,
                                      onChanged: (CheckGender? value) {
                                        setState(() {
                                          _character = value;
                                        });
                                      }),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Khác",
                                    style: textTheme.medium14(),
                                  ),
                                  SizedBox(
                                    width: 3.w,
                                  ),
                                  Radio<CheckGender>(
                                      value: CheckGender.other,
                                      groupValue: _character,
                                      onChanged: (CheckGender? value) {
                                        setState(() {
                                          _character = value;
                                        });
                                      }),
                                ],
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "Ngày sinh: ",
                                style: textTheme.medium14(),
                              ),
                              Text(
                                  '${_birthday.day}/${_birthday.month}/${_birthday.year}',
                                  style: textTheme.medium14()),
                              TextButton(
                                  onPressed: () => _selectDate(context),
                                  child: Icon(
                                    Icons.calendar_today_rounded,
                                    size: 15,
                                    color: HexColor("#BB2649"),
                                  )),
                            ],
                          ),
                          TextFieldWid(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Số điện thoại không được để trống';
                              }
                              if (!RegExp(r'^0\d{9}$').hasMatch(value)) {
                                return 'Số điện thoại không hợp lệ';
                              }
                              return null;
                            },
                            icon: Icons.phone_android,
                            type: "number",
                            label: "Số điện thoại",
                            text: _phoneNumber ?? "",
                            enbled: true,
                            onChanged: (value) {
                              _phoneNumber = value;
                            },
                          ),
                          SizedBox(height: 24.h),
                          TextFieldWid(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Tiểu sử không được để trống';
                              }
                              // if (!RegExp(r' ^(?:\w+\W*){1,52}$')
                              //     .hasMatch(value)) {
                              //   return 'Tiểu sử không quá 52 từ';
                              // }
                              return null;
                            },
                            maxLines: 3,
                            icon: Icons.note_alt_outlined,
                            label: "Tiểu sử",
                            text: _caption ?? "",
                            enbled: true,
                            onChanged: (value) {
                              _caption = value;
                            },
                          ),
                          _experienceForm(context),
                          _educationForm(context),
                        ],
                      ),
                    ),
                  );
                },
              )
            ])),
          ],
        ),
      ),
      bottomNavigationBar: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          return BottomAppBar(
              color: Colors.transparent,
              elevation: 0.0,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
                // color: Colors.transparent,
                height: 0.1.sh,
                child: ElevatedButton(
                    onPressed: () async {
                      if (_address == null) {
                        Fluttertoast.showToast(
                          msg: 'Vui lòng chọn địa chỉ',
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                        );
                      } else {
                        if (_formKey.currentState!.validate()) {
                          final newUser = UserModel(
                            careAbout: userProvider.user.careAbout,
                            userId: userProvider.user.userId,
                            name: userProvider.user.name,
                            address: _address,
                            familyname: _familyname,
                            firstname: _firstName,
                            birthday: _birthday.toIso8601String(),
                            email: userProvider.user.email,
                            experience: _experiences,
                            education: _educations,
                            fullname: _fullname ?? userProvider.user.fullname,
                            gender: _gender,
                            phone_number: int.parse(_phoneNumber.toString()),
                            status: _status ?? userProvider.user.status,
                            imageUrl: userProvider.user.imageUrl,
                            usertype: userProvider.user.usertype,
                            caption: _caption ?? userProvider.user.caption,
                            followers_count: userProvider.user.followers_count,
                            following_count: userProvider.user.following_count,
                          );

                          userProvider.updateUser(context, newUser,
                              action: "${widget.action}");
                        }
                      }

                      // if (file != null) {
                      //   Random random = new Random();
                      //   final fileBytes = await file?.readAsBytes();
                      //   int randomNumber = random.nextInt(100);

                      //   final fileName =
                      //       '${userProvider.user.userId}/${randomNumber}_${_file?.name}';
                      //   final storageResponse = await SupabaseBase
                      //       .supabaseClient.storage
                      //       .from('job')
                      //       .uploadBinary(fileName, fileBytes!);

                      //   final publicUrl = SupabaseBase.supabaseClient.storage
                      //       .from('job')
                      //       .getPublicUrl(fileName);
                      //   ApplyModel newApply = ApplyModel(
                      //       jobId: widget.job.jobId.toString(),
                      //       userId: widget.user.userId.toString(),
                      //       note: _note ?? "",
                      //       fileUrl: publicUrl);
                      //   print('Public URL: $publicUrl');
                      //   print(storageResponse);
                      //   jobProvider.inserApplyJob(context, newApply);
                      // }
                    },
                    child: Container(
                      child: Text('Hoàn thành',
                          style: textTheme.medium16(color: "FFFFFF")),
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: HexColor("#BB2649"),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r)))),
              ));
        },
      ),
    );
  }

  Row _locationFormWidget(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
            alignment: Alignment.center,
            height: 60.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
            ),
            padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
            width: 0.68.sw,
            child: Row(
              children: [
                Icon(Icons.location_city),
                SizedBox(
                  width: 8.w,
                ),
                Container(
                  width: 0.5.sw,
                  child: Text(
                    overflow: TextOverflow.ellipsis,
                    "${_locationController.text.isEmpty ? "Địa chỉ làm việc" : _locationController.text} ",
                    style: textTheme.medium14(
                        color:
                            "${!_locationController.text.isEmpty ? '000000' : 'AFB0B6'}"),
                  ),
                ),
              ],
            )),
        SizedBox(
          width: 10.w,
        ),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor:
                MaterialStatePropertyAll<Color>(HexColor("#FFFFFF")),
          ),
          onPressed: () async {
            PickedData pickedData = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => OpenStreetMap(
                          isSeen: false,
                        )));
            setState(() {
              _locationController.text = pickedData.address;
              // _pickedData = pickedData;
              _address = (AddressModel(
                  addressName: pickedData.address,
                  latitude: pickedData.latLong.latitude,
                  longitude: pickedData.latLong.longitude));
            });
          },
          child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15.h),
              child: Icon(
                Icons.location_on,
                color: HexColor("#BB2649"),
              )),
        ),
      ],
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

  _experienceForm(BuildContext context) {
    return SizedBox(
      width: 1.sw,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Kinh nghiệm",
            style: textTheme.medium14(),
          ),
          ..._experiences.asMap().entries.map(
            (entry) {
              final int index = entry.key;
              final ExperienceModel experience = entry.value;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  GestureDetector(
                    onTap: () {
                      _removeExperience(index);
                    },
                    child: Icon(
                      Icons.delete,
                      size: 17,
                      color: HexColor("#BB2649"),
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 16.h, horizontal: 15.w),
                    margin: EdgeInsets.only(top: 17.h),
                    width: 1.sw,
                    height: 115.h,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        opacity: 0.1,
                        image: AssetImage(
                          'assets/images/jobs/effectFeature.png',
                        ),
                      ),
                      color: HexColor("#26BB98"),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 0.13.sw,
                          child: Column(
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CircleAvatar(
                                  radius: 30.r,
                                  backgroundColor: HexColor("#BB2649"),
                                  child: Text("T",
                                      style: TextStyle(fontSize: 25.sp))),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 8.w,
                        ),
                        _inforExperience(context, experience),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          SizedBox(
            height: 10.h,
          ),
          ElevatedButton(
            style: ButtonStyle(
                backgroundColor:
                    MaterialStatePropertyAll<Color>(HexColor("#BB2649"))),
            onPressed: () {
              _showDialogExperience(context);
            },
            child: Text(
              'Thêm kinh nghiệm',
              style: textTheme.medium14(color: "FFFFFF"),
            ),
          ),
        ],
      ),
    );
  }

  _educationForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Học vấn",
          style: textTheme.medium14(),
        ),
        ..._educations.asMap().entries.map(
          (entry) {
            final int index = entry.key;
            final EducationModel education = entry.value;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  height: 10.h,
                ),
                GestureDetector(
                  onTap: () {
                    _removeEducation(index);
                  },
                  child: Icon(
                    Icons.delete,
                    size: 17.sp,
                    color: HexColor("#BB2649"),
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 16.h, horizontal: 15.w),
                  margin: EdgeInsets.only(top: 17.h),
                  width: 1.sw,
                  height: 115.h,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      opacity: 0.1,
                      image: AssetImage(
                        'assets/images/jobs/effectFeature.png',
                      ),
                    ),
                    color: HexColor("#26BB98"),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 0.13.sw,
                        child: Column(
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CircleAvatar(
                                radius: 30.r,
                                backgroundColor: HexColor("#BB2649"),
                                child: Text("T",
                                    style: TextStyle(fontSize: 25.sp))),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 8.w,
                      ),
                      _inforEducation(context, education),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
        ElevatedButton(
          style: ButtonStyle(
              backgroundColor:
                  MaterialStatePropertyAll<Color>(HexColor("#BB2649"))),
          onPressed: () {
            _showDialogEducation(context);
          },
          child: Text(
            'Thêm học vấn',
            style: textTheme.medium14(color: "FFFFFF"),
          ),
        ),
      ],
    );
  }

  void _showDialogExperience(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Form(
          key: _formKeyExperience,
          child: AlertDialog(
            elevation: 8,
            backgroundColor: HexColor("#FAFAFD"),
            title: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Kinh nghiệm",
                  style: textTheme.headline20(color: "000000"),
                ),
                TextFieldWid(
                  // icon: Icons.abc_outlined,
                  label: "Tên công việc bạn đã làm",
                  text: "",
                  enbled: true,
                  onChanged: (value) {
                    _jobTitle = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Tên công việc không được để trống';
                    }

                    return null;
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10.h),
                      child: PickerYear(
                        width: 0.33,
                        title: "Ngày bắt đầu",
                        listData: _listYear,
                        onSelectedItemChanged: (value) {
                          setState(() {
                            _startDateEx = _listYear[_listYear.indexOf(value)];
                          });
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10.h),
                      child: PickerYear(
                        width: 0.33,
                        title: "Ngày kết thúc",
                        listData: _listYear,
                        onSelectedItemChanged: (value) {
                          setState(() {
                            _endDateEx = _listYear[_listYear.indexOf(value)];
                          });
                        },
                      ),
                    ),
                  ],
                ),
                // Check xem ngày bắt đầu có lớn không
                // isStartYearMoreThan(
                //         _startDateEx.toString(), _endDateEdu.toString())
                //     ? Text("$msgDateTime")
                //     : Container(),
                TextFieldWid(
                  label: "Tên nơi làm việc của bạn",
                  text: "",
                  enbled: true,
                  onChanged: (value) {
                    _companyName = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Tên nơi làm việc không được để trống';
                    }

                    return null;
                  },
                ),
                TextFieldWid(
                  label: "Mô tả",
                  text: "",
                  enbled: true,
                  onChanged: (value) {
                    _descriptionEx = value;
                  },
                ),
                SizedBox(height: 16.h),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'Thoát',
                  style: textTheme.semibold16(color: "000000"),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text(
                  'OK',
                  style: textTheme.semibold16(color: "000000"),
                ),
                onPressed: () {
                  if (_formKeyExperience.currentState!.validate()) {
                    _addExperience();
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDialogEducation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Form(
          key: _formKeyEducation,
          child: AlertDialog(
            elevation: 8,
            backgroundColor: HexColor("#FAFAFD"),
            title: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Học vấn",
                  style: textTheme.headline20(color: "000000"),
                ),
                TextFieldWid(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Trường đã học không được để trống';
                    }

                    return null;
                  },
                  label: "Trường đã học",
                  text: "",
                  enbled: true,
                  onChanged: (value) {
                    _schoolName = value;
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10.h),
                      child: PickerYear(
                        width: 0.33,
                        title: "Ngày bắt đầu",
                        listData: _listYear,
                        onSelectedItemChanged: (value) {
                          setState(() {
                            _startDateEdu = _listYear[_listYear.indexOf(value)];
                          });
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10.h),
                      child: PickerYear(
                        width: 0.33,
                        title: "Ngày kết thúc",
                        listData: _listYear,
                        onSelectedItemChanged: (value) {
                          setState(() {
                            _endDateEdu = _listYear[_listYear.indexOf(value)];
                          });
                        },
                      ),
                    ),
                  ],
                ),
                TextFieldWid(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Chuyên ngành không được để trống';
                    }

                    return null;
                  },
                  label: "Chuyên ngành",
                  text: "",
                  enbled: true,
                  onChanged: (value) {
                    _fieldOfStudy = value;
                  },
                ),
                TextFieldWid(
                  label: "Bằng cấp",
                  text: "",
                  enbled: true,
                  onChanged: (value) {
                    _degree = value;
                  },
                ),
                TextFieldWid(
                  label: "Mô tả",
                  text: "",
                  enbled: true,
                  onChanged: (value) {
                    _descriptionEdu = value;
                  },
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'Thoát',
                  style: textTheme.semibold16(color: "000000"),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text(
                  'Hoàn tất',
                  style: textTheme.semibold16(color: "000000"),
                ),
                onPressed: () {
                  if (_formKeyEducation.currentState!.validate()) {
                    _addEducation();
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Container _inforExperience(BuildContext context, ExperienceModel experience) {
    return Container(
      width: 0.63.sw,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 0.35.sw,
                child: Text(
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  "${experience.jobTitle}",
                  style: textTheme.semibold14(),
                ),
              ),
              Text(
                "${experience.startDate} - ${experience.endDate}",
                style: textTheme.medium12(color: "0D0D26", opacity: 0.5),
              )
            ],
          ),
          Text(
            "🏠 ${experience.company_name}",
            style: textTheme.medium12(color: "FFFFFF"),
          ),
          SizedBox(
            height: 6.h,
          ),
          Container(
              width: 1.sw,
              child: Text(
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                "${experience.description}",
                style: textTheme.medium12(color: "FFFFFF", opacity: 0.5),
              ))
        ],
      ),
    );
  }

  _inforEducation(BuildContext context, EducationModel education) {
    return Container(
      width: 0.62.sw,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 0.33.sw,
                child: Text(
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  "${education.degree}",
                  style: textTheme.semibold14(),
                ),
              ),
              Text(
                "${education.startDate} - ${education.endDate}",
                style: textTheme.medium12(color: "0D0D26", opacity: 0.5),
              )
            ],
          ),
          Text(
            "${education.fieldOfStudy} -🏫 ${education.schoolName}",
            style: textTheme.medium12(color: "FFFFFF"),
          ),
          SizedBox(
            height: 6.h,
          ),
          Container(
              width: 1.sw,
              child: Text(
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                "${education.description}",
                style: textTheme.medium12(color: "FFFFFF", opacity: 0.5),
              ))
        ],
      ),
    );
  }
}

class _MyHeader extends SliverPersistentHeaderDelegate {
  _MyHeader({required this.child});

  final Widget child;

  @override
  double get minExtent => 80.0.h;

  @override
  double get maxExtent => 80.0.h;

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
