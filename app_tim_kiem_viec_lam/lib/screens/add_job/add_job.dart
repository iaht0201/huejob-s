import 'package:app_tim_kiem_viec_lam/core/models/jobs_model.dart';
import 'package:app_tim_kiem_viec_lam/screens/addPost/map.dart';
import 'package:app_tim_kiem_viec_lam/screens/profile/widgets/button_arrow.dart';
import 'package:app_tim_kiem_viec_lam/utils/constant.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';
import 'package:provider/provider.dart';

import '../../core/models/job_category_model.dart';
import '../../core/models/user_model.dart';
import '../../core/providers/jobs_rovider.dart';
import '../../widgets/textfiled_widget.dart';
import '../../widgets/show_frame_profile.dart';
import '../../widgets/text_field_widgets.dart';

class AddJobScreen extends StatefulWidget {
  AddJobScreen({super.key, required this.user});
  final UserModel user;
  @override
  State<AddJobScreen> createState() => _AddJobScreenState();
}

class _AddJobScreenState extends State<AddJobScreen> {
  late JobsProvider jobProvider;
  final TextEditingController textEditingController = TextEditingController();
  String? _title;
  String? _description;
  String? _requirement;
  String? _time;
  String? _role;
  String? _wage;
  List<JobCategoryModel> roleJob = [];
  List<JobCategoryModel> _itemList = [];
  JobCategoryModel? selectedObj;
  String? selectedValue;
  PickedData? _pickedData;
  @override
  void initState() {
    super.initState();
    jobProvider = Provider.of<JobsProvider>(context, listen: false);
    jobProvider.fetchPopularRoles();
  }

  Future<List<JobCategoryModel>> getData() async {
    _itemList = await jobProvider.fetchPopularRoles();
    return _itemList;
  }

  final TextEditingController _locationController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: HexColor("#FFFFFF"),
        elevation: 0,
        leading: buttonArrow(context),
        title: Text(
          "Đăng bài tuyển dụng",
          style: textTheme.semibold16(color: "#000000"),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll<Color>(HexColor("#BB2649")),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        JobModel newJob = JobModel(
                          wage: _wage,
                          description: _description,
                          userId: widget.user.userId,
                          role: _role,
                          jobName: _title,
                          location: _pickedData?.address,
                          categoryJob: selectedValue,
                          requirement: _requirement,
                          wokringTime: _time,
                          longitude: _pickedData?.latLong.longitude,
                          latitude: _pickedData?.latLong.latitude,
                        );
                        jobProvider.insertJob(context, newJob);
                      }
                    },
                    child: Text("Đăng",
                        style: textTheme.semibold16(color: "#FFFFFF"))
                    // Container(
                    //     padding: EdgeInsets.symmetric(
                    //         horizontal: 20.w, vertical: 10.h),
                    //     decoration: BoxDecoration(color: HexColor("#BB2649")),
                    //     child:),
                    ),
              ],
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: 24.w, right: 24.w, top: 20.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShowProfile(user: widget.user),
              _InformationJob(context),
            ],
          ),
        ),
      ),
    );
  }

  _InformationJob(BuildContext context) {
    return Container(
        width: 1.sw,
        margin: EdgeInsets.only(top: 20.h, bottom: 15.h),
        child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Information",
                  style: textTheme.semibold16(color: "000000"),
                ),
                TextFieldWid(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Tên công việc không được để trống';
                    }
                    return null;
                  },
                  icon: Icons.work,
                  enbled: true,
                  label: 'Tên công việc',
                  text: '',
                  onChanged: (title) {
                    _title = title;
                    print(
                      'title: ${_title}',
                    );
                  },
                ),
                SizedBox(
                  height: 15.h,
                ),
                _locationFormWidget(context),
                SizedBox(
                  height: 15.h,
                ),
                _dropdownCareer(context),
                SizedBox(
                  height: 15.h,
                ),
                TextFieldWid(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng không để trống level bạn muốn tuyển dụng';
                    }
                    return null;
                  },
                  maxLines: 1,
                  icon: Icons.person_pin_circle_outlined,
                  enbled: true,
                  label: 'Level tuyển dụng',
                  text: '',
                  onChanged: (role) {
                    _role = role;
                    print(
                      '_time: ${_time}',
                    );
                  },
                ),
                SizedBox(
                  height: 15.h,
                ),
                TextFieldWid(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng không để trống mức lương';
                    }
                    return null;
                  },
                  maxLines: 1,
                  icon: Icons.money,
                  enbled: true,
                  label: 'Mức Lương',
                  text: '',
                  onChanged: (wage) {
                    _wage = wage;
                    print(
                      '_time: ${_wage}',
                    );
                  },
                ),
                SizedBox(
                  height: 15.h,
                ),
                TextFieldWid(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Thời gian làm việc không được bỏ trống';
                    }
                    return null;
                  },
                  maxLines: 1,
                  icon: Icons.timelapse,
                  enbled: true,
                  label: 'Thời gian làm việc',
                  text: '',
                  onChanged: (time) {
                    _time = time;
                    print(
                      '_time: ${_time}',
                    );
                  },
                ),
                SizedBox(
                  height: 15.h,
                ),
                TextFieldWid(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng không được để trống mô tả công việc tuyển dụng';
                    }
                    return null;
                  },
                  maxLines: 6,
                  // icon: Icons.note_alt_outlined,
                  enbled: true,
                  label: '✍️ Mô tả công việc...',
                  text: '',
                  onChanged: (title) {
                    _description = title;
                    print(
                      'title: ${_description}',
                    );
                  },
                ),
                SizedBox(
                  height: 15.h,
                ),
                TextFieldWid(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng không để trống mô tả yêu cầu công việc';
                    }
                    return null;
                  },
                  maxLines: 4,
                  // icon: Icons.note_alt_outlined,
                  enbled: true,
                  label: '✍️ Yêu cầu công việc',
                  text: '',
                  onChanged: (requirement) {
                    _requirement = requirement;
                    print(
                      'title: ${_requirement}',
                    );
                  },
                ),
              ],
            )));
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
              _pickedData = pickedData;
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

  _dropdownCareer(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 12.h),
        child: Consumer<JobsProvider>(
          builder: (context, jobProvider, child) {
            return DropdownButtonFormField2(
              validator: (value) {
                if (value == null) {
                  return 'Vui lòng chọn ngành nghề bạn muốn tuyển dụng';
                }
                return null;
              },
              decoration: InputDecoration(
                filled: true,
                hintText: "Ngành bạn muốn tuyển dụng?",
                hintStyle: textTheme.medium14(color: "AFB0B6"),
                prefixIcon: Icon(
                  Icons.category_outlined,
                  color: Colors.black,
                ),
                fillColor: Colors.white,
                isDense: true,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15.h, horizontal: 5.w),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              isExpanded: true,
              value: selectedObj == null ? selectedObj : null,
              onChanged: (value) {
                selectedValue = value?.jobName;
              },
              items: jobProvider.getRoleJob.map((JobCategoryModel e) {
                return DropdownMenuItem<JobCategoryModel>(
                  child: Text(
                    "${e.jobName}",
                    style: textTheme.medium14(),
                  ),
                  value: e,
                  onTap: () {
                    selectedObj = e;
                  },
                );
              }).toList(),
              buttonDecoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(8.r)),
              searchController: textEditingController,
              searchInnerWidgetHeight: 50,
              searchInnerWidget: Container(
                height: 50,
                padding: const EdgeInsets.only(
                  top: 8,
                  bottom: 4,
                  right: 8,
                  left: 8,
                ),
                child: TextFormField(
                  controller: textEditingController,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    hintText: 'Ngành bạn muốn tuyển dụng?',
                    hintStyle: const TextStyle(fontSize: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              searchMatchFn: (item, searchValue) {
                return (item.value.jobName.contains(searchValue));
              },
              onMenuStateChange: (isOpen) {
                if (!isOpen) {
                  textEditingController.clear();
                }
              },
            );
          },
        ));
  }
}
