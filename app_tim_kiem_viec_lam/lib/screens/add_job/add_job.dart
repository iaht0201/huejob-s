import 'package:app_tim_kiem_viec_lam/core/models/jobs_model.dart';
import 'package:app_tim_kiem_viec_lam/screens/addPost/map.dart';
import 'package:app_tim_kiem_viec_lam/screens/detailJob/detail_job.dart';
import 'package:app_tim_kiem_viec_lam/screens/profile/widgets/button_arrow.dart';
import 'package:app_tim_kiem_viec_lam/utils/constant.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';
import 'package:provider/provider.dart';

import '../../core/models/job_category_model.dart';
import '../../core/models/user_model.dart';
import '../../core/providers/jobs_provider.dart';

import '../../core/providers/user_provider.dart';
import '../../widgets/picker_cupertino/picker_date.dart';
import '../../widgets/picker_cupertino/picker_year.dart';
import '../../widgets/show_frame_profile.dart';
import '../../widgets/text_field_widgets.dart';

class AddJobScreen extends StatefulWidget {
  AddJobScreen({super.key, this.user, this.title = "add_job", this.jobId = ""});
  final UserModel? user;
  final String title;
  final String? jobId;
  @override
  State<AddJobScreen> createState() => _AddJobScreenState();
}

class _AddJobScreenState extends State<AddJobScreen> {
  late JobsProvider jobProvider;
  late UserProvider userProvider;
  final TextEditingController textEditingController = TextEditingController();
  String? _title;
  String? _description;
  String? _requirement;
  String? _time;
  String? _role;
  String? _wage;
  DateTime? _expiration_date;
  bool? isLoad = false;
  List<JobCategoryModel> roleJob = [];
  List<JobCategoryModel> _itemList = [];
  JobCategoryModel? selectedObj;
  String? selectedValue;
  PickedData? _pickedData;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    jobProvider = Provider.of<JobsProvider>(context, listen: false);
    userProvider = Provider.of<UserProvider>(context, listen: false);
    jobProvider.fetchPopularRoles();
    if (widget.jobId!.isEmpty) {
      setState(() {
        isLoading = true;
        _expiration_date = DateTime.now();
      });
    } else {
      jobProvider.getJobById(widget.jobId.toString()).whenComplete(() {
        setState(() {
          _title = jobProvider.jobById.jobName ?? "";
          _expiration_date = jobProvider.jobById.expirationDate != null
              ? DateTime.parse(jobProvider.jobById.expirationDate.toString())
              : DateTime.now();
          _locationController.text = jobProvider.jobById.location!;
          selectedValue = jobProvider.jobById.categoryJob;
          _role = jobProvider.jobById.role ?? "";
          _wage = jobProvider.jobById.wage ?? "";
          _time = jobProvider.jobById.wokringTime ?? "";
          _requirement = jobProvider.jobById.requirement ?? "";
          _description = jobProvider.jobById.description ?? "";
          isLoading = true;
        });
        print(_title);
      });
    }
  }

  Future<List<JobCategoryModel>> getData() async {
    _itemList = await jobProvider.fetchPopularRoles();
    return _itemList;
  }

  final TextEditingController _locationController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return Scaffold(
          // backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: HexColor("#FFFFFF"),
            elevation: 0,
            leading: buttonArrow(context),
            title: Text(
              widget.title == "add_job"
                  ? "Đăng bài tuyển dụng"
                  : "${widget.title}",
              style: textTheme.semibold16(color: "000000"),
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
                          backgroundColor: MaterialStatePropertyAll<Color>(
                              HexColor("#BB2649")),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            JobModel newJob = jobProvider.jobById.copyWith(
                                wage: _wage,
                                userId: userProvider.user.userId,
                                description: _description,
                                role: _role,
                                jobName: _title,
                                location: _pickedData?.address,
                                categoryJob: selectedValue,
                                requirement: _requirement,
                                wokringTime: _time,
                                longitude: _pickedData?.latLong.longitude,
                                latitude: _pickedData?.latLong.latitude,
                                expirationDate: _expiration_date.toString());
                            // JobModel newJob = JobModel(
                            //     wage: _wage,
                            //     description: _description,
                            //     userId: "234343434",
                            //     // userId: widget.user?.userId,
                            //     role: _role,
                            //     jobName: _title,
                            //     location: _pickedData?.address,
                            //     categoryJob: selectedValue,
                            //     requirement: _requirement,
                            //     wokringTime: _time,
                            //     longitude: _pickedData?.latLong.longitude,
                            //     latitude: _pickedData?.latLong.latitude,
                            //     expirationDate: _expiration_date.toString());

                            jobProvider.insertJob(context, newJob).whenComplete(
                              () {
                                setState(() {
                                  isLoad = true;
                                });
                              },
                            );
                          }
                        },
                        child: isLoad == false
                            ? Text("Hoàn tất",
                                style: textTheme.semibold16(color: "#FFFFFF"))
                            : CircularProgressIndicator()
                        // Container(
                        //     padding: EdgeInsets.symmetric(
                        //         horizontal: 20.w, vertical: 10.h),
                        //     decoration: BoxDecoration(color: HexColor("#BB2649")),
                        //     child:),
                        )
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
                  // ShowProfile(user: widget.user!),
                  _InformationJob(context),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  _InformationJob(BuildContext context) {
    return isLoading
        ? Container(
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
                      text: _title ?? "",
                      onChanged: (value) {
                        _title = value;
                        print(
                          'title: ${_title}',
                        );
                      },
                    ),
                    PickerDateTime(
                      initDateTime: _expiration_date,
                      onSelectedItemChanged: (value) {
                        setState(() {
                          _expiration_date = value;
                        });
                      },
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
                      text: _role ?? "",
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
                      text: _wage ?? "",
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
                      text: _time ?? '',
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
                      text: _description ?? '',
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
                      text: _requirement ?? '',
                      onChanged: (requirement) {
                        _requirement = requirement;
                        print(
                          'title: ${_requirement}',
                        );
                      },
                    ),
                  ],
                )))
        : CircularProgressIndicator();
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
                if (value == null && selectedValue == null) {
                  return 'Vui lòng chọn ngành nghề bạn muốn tuyển dụng';
                }
                return null;
              },
              decoration: InputDecoration(
                filled: true,
                label: Text("${selectedValue ?? "Ngành bạn muốn tuyển dụng?"}"),
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
              value: selectedObj,
              onChanged: (value) {
                // selectedObj = value ;selectedValue
                selectedValue = value?.jobName ?? selectedValue;
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
