import 'package:app_tim_kiem_viec_lam/core/providers/user_provider.dart';
import 'package:app_tim_kiem_viec_lam/screens/profile/widgets/profile_detail_user_infor.dart';
import 'package:app_tim_kiem_viec_lam/utils/constant.dart';
import 'package:app_tim_kiem_viec_lam/widgets/avatar_widget.dart';
import 'package:app_tim_kiem_viec_lam/widgets/frame_item_show_horizontal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../../../core/models/user_model.dart';
import '../../see_more_screen/see_all_scree.dart';
import 'care_about.dart';
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
    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
        UserModel user;
        if (widget.isClient == false) {
          user = userProvider.user;
        } else
          user = widget.user!;
        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 8),
          margin: EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              user.experience?.length == 0 || user.experience == null
                  ? Container()
                  : ExperienceWidget(
                      experience: user.experience, isClient: widget.isClient),
              SizedBox(
                height: 12.h,
              ),
              user.education == null
                  ? Container()
                  : EducationWidget(
                      education: user.education,
                    ),

              // InforUser(
              //   text: widget.user!.address,
              //   icon: widget.user!.address == 1 ? Icons.man : Icons.girl,
              // ),
              SizedBox(
                height: 20.h,
              ),
              Text(
                "Các thông tin khác",
                style: textTheme.sub16(),
              ),
              _itemInforUser(
                context,
                text: user.email,
                image: "assets/icons/gmail.png",
              ),
              _itemInforUser(
                context,
                text: user.getGender,
                image:
                    "assets/icons/${user.gender == 0 ? 'man' : user.gender == 1 ? 'woman' : 'lgbt'}.png",
              ),
              _itemInforUser(
                context,
                text: user.birthday,
                image: "assets/icons/birthday-cake.png",
              ),
              _itemInforUser(
                context,
                text: user.phone_number.toString(),
                image: "assets/icons/phone.png",
              ),
              user.careAbout == null  ||  user.careAbout?.length == 0 
                  ? Container()
                  : CareAboutWidget(
                      careAbout: user.careAbout,
                    ),
            ],
          ),
        );
      },
    );
  }

  _itemInforUser(BuildContext context, {String? image, String? text}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            '$image',
            width: 25.w,
          ),
          SizedBox(
            width: 10.w,
          ),
          Container(
              padding: EdgeInsets.symmetric(vertical: 2),
              width: MediaQuery.of(context).size.width * 0.8,
              child: Text(
                "$text",
                style: textTheme.regular13(),
                textAlign: TextAlign.justify,
              ))
        ],
      ),
    );
  }
}
