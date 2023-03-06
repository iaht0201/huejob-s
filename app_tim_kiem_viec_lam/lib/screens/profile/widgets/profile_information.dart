import 'dart:io';

import 'package:app_tim_kiem_viec_lam/core/providers/userProvider.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/models/user_model.dart';

import '../../../core/providers/job_provider.dart';
import '../../../core/supabase/supabase.dart';
import '../profile_edit.dart';
import '../profile_setting.dart';
import '../image_screen.dart';

class ProfileInformation extends StatefulWidget {
  ProfileInformation(
      {super.key, this.user, this.initials, this.onImageUrlChanged});
  final String? initials;
  final ValueChanged<String>? onImageUrlChanged;
  final UserModel? user;

  @override
  State<ProfileInformation> createState() => _ProfileInformationState();
}

class _ProfileInformationState extends State<ProfileInformation> {
  final JobProvider _imageProvider = JobProvider();

  bool _isLoading = false;
  String _id = "";
  File? _image;
  late UserProvider userProvider;

  void initState() {
    super.initState();
    userProvider = p.Provider.of<UserProvider>(context, listen: false);
    // userProvider.fetchUser();
  }

  Future<void> _upload(dynamic imageFile) async {
    final prefs = await SharedPreferences.getInstance();

    if (imageFile == null) {
      return;
    }
    setState(() {
      _isLoading = true;
      _id = prefs.getString('id')!;
      _image = File(imageFile.path);
    });
    try {
      final bytes = await imageFile.readAsBytes();
      final fileExt = imageFile.name.split('.').last;
      final fileName = '${_id}/${imageFile.name}';
      final filePath = fileName;
      await SupabaseBase.supabaseClient.storage.from('avatars').uploadBinary(
            filePath,
            bytes,
            fileOptions: FileOptions(contentType: imageFile.mimeType),
          );
      final imageUrlResponse = await SupabaseBase.supabaseClient.storage
          .from('avatars')
          .createSignedUrl(filePath, 60 * 60 * 24 * 365 * 10);

      widget.onImageUrlChanged!(imageUrlResponse);
    } on StorageException catch (error) {
      print(error);
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          child: Container(
            padding: EdgeInsets.only(bottom: 25),
            child: Column(
              children: [
                p.Consumer<UserProvider>(
                  builder: (context, userProvider, _) {
                    return GestureDetector(
                        onTap: () {
                          _bottomSheetChangeAvatar(context);
                        },
                        child: userProvider.user!.imageUrl == null
                            ? (CircleAvatar(
                                foregroundImage:
                                    _image != null ? FileImage(_image!) : null,
                                radius: 50,
                                backgroundColor: HexColor("#BB2649"),
                                child: Text(
                                    "${userProvider.user?.name.toString().substring(0, 1).toUpperCase()}",
                                    style: TextStyle(fontSize: 40))))
                            : CircleAvatar(
                                radius: 50,
                                backgroundColor: HexColor("#BB2649"),
                                backgroundImage: NetworkImage(
                                    "${userProvider.user!.imageUrl}"),
                              ));
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: Row(
                    children: [
                      _buildUserInfor(context, "Đang Follow", "100"),
                      _buildUserInfor(context, "Follow", "100"),
                      _buildUserInfor(context, "Thích", "100")
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    EditProfile(user: widget.user)));
                      },
                      child: Row(
                        children: [
                          Icon(Icons.mode_edit_outlined),
                          Text("Chỉnh sửa thông tin")
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                          primary: HexColor("#BB2649"),
                          fixedSize: Size(200, 50)),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfileSettingScreen()));
                      },
                      child: Icon(
                        Icons.more_horiz_outlined,
                        color: Colors.black,
                      ),
                      style: ElevatedButton.styleFrom(
                          primary: HexColor("#FFFFFF"),
                          fixedSize: Size(50, 50)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  _bottomSheetChangeAvatar(BuildContext context) {
    double containerHeight = 200.0;
    return showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            if (constraints.maxWidth > constraints.maxHeight) {
              containerHeight = 300.0;
            } else {
              containerHeight = 240.0;
            }
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                color: HexColor("#BB2649"),
              ),
              height: containerHeight,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(height: 5, width: 35, color: Colors.white),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.0),
                  GestureDetector(
                    onTap: () {},
                    child: Row(
                      children: [
                        Icon(
                          Icons.person_sharp,
                          size: 33,
                          color: Colors.white,
                        ),
                        SizedBox(width: 13.0),
                        Text(
                          'Xem ảnh đại diện',
                          style: TextStyle(
                              fontSize: 19,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 16.0),
                  GestureDetector(
                    onTap: () async {
                      final picker = ImagePicker();
                      final imageFile = await picker.pickImage(
                        source: ImageSource.gallery,
                        maxWidth: 300,
                        maxHeight: 300,
                      );
                      if (imageFile != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ImageScreen(
                              imageFile: imageFile,
                            ),
                          ),
                        );
                      }

                      // _upload(imageFile);
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.image,
                          size: 33,
                          color: Colors.white,
                        ),
                        SizedBox(width: 13.0),
                        Text(
                          'Chọn ảnh đại diện',
                          style: TextStyle(
                              fontSize: 19,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 16.0),
                  GestureDetector(
                    onTap: () {},
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete,
                          size: 33,
                          color: Colors.white,
                        ),
                        SizedBox(width: 13.0),
                        Text(
                          'Xóa ảnh đại diện',
                          style: TextStyle(
                              fontSize: 19,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

Expanded _buildUserInfor(BuildContext context, String type, String value) {
  return Expanded(
    child: Column(
      children: [
        Text(
          value,
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          type,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: Colors.grey.shade600, letterSpacing: 1.1, fontSize: 12),
        )
      ],
    ),
  );
}
