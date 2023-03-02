import 'package:app_tim_kiem_viec_lam/screens/profile/widgets/profile_detail_user_infor.dart';
import 'package:flutter/material.dart';

import '../../../core/models/user_model.dart';

class ProfileDetailInformation extends StatefulWidget {
  ProfileDetailInformation({super.key, this.user});
  final UserModel? user;
  @override
  State<ProfileDetailInformation> createState() =>
      __ProfileDetailInformationState();
}

class __ProfileDetailInformationState extends State<ProfileDetailInformation> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 8),
        margin: EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Chi tiết",
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
            SizedBox(
              height: 10,
            ),
            InforUser(
              text: widget.user!.email,
              icon: Icons.email_outlined,
            ),
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
              text: widget.user!.experience,
              icon: Icons.star,
            ),
            InforUser(
              text: widget.user!.status,
              icon: Icons.note_alt_outlined,
            ),
          ],
        ),
      ),
    );
  }
}
