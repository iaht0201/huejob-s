import 'package:app_tim_kiem_viec_lam/screens/profile/widgets/profile_detail_user_infor.dart';
import 'package:app_tim_kiem_viec_lam/utils/constant.dart';
import 'package:app_tim_kiem_viec_lam/widgets/avatar_widget.dart';
import 'package:app_tim_kiem_viec_lam/widgets/frame_item_show_horizontal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../core/models/user_model.dart';
import '../../see_more_screen/see_all_scree.dart';
import 'education_widget.dart';
import 'experience_widget.dart';

class ProfileDetailInformation extends StatefulWidget {
  ProfileDetailInformation({super.key, this.user, this.isClient = false});
  final UserModel? user;
  final bool isClient;
  @override
  State<ProfileDetailInformation> createState() =>
      __ProfileDetailInformationState();
}

class __ProfileDetailInformationState extends State<ProfileDetailInformation> {
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 8),
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.user?.experience?.length == 0 ||
                  widget.user?.experience == null
              ? Container()
              : ExperienceWidget(
                  experience: widget.user?.experience,
                  isClient: widget.isClient),
          SizedBox(
            height: 12.h,
          ),
          widget.user?.education == null
              ? Container()
              : EducationWidget(
                  education: widget.user?.education,
                ),
          // InforUser(
          //   text: widget.user!.address,
          //   icon: widget.user!.address == 1 ? Icons.man : Icons.girl,
          // ),
          InforUser(
            text: widget.user!.getGender,
            icon: widget.user!.gender == 1 ? Icons.man : Icons.girl,
          ),
          InforUser(
            text: widget.user!.birthday.toString(),
            icon: Icons.cake,
          ),
          InforUser(
            text: widget.user!.phone_number.toString(),
            icon: Icons.phone,
          ),
          InforUser(
            text: widget.user!.status,
            icon: Icons.note_alt_outlined,
          ),
        ],
      ),
    );
  }
}
