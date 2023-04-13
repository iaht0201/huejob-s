import 'dart:io';

import 'package:app_tim_kiem_viec_lam/core/providers/user_provider.dart';
import 'package:app_tim_kiem_viec_lam/screens/chat/chatscreen.dart';
import 'package:app_tim_kiem_viec_lam/utils/constant.dart';
import 'package:app_tim_kiem_viec_lam/widgets/avatar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/models/user_model.dart';

import '../../../core/providers/post_provider.dart';
import '../../../core/supabase/supabase.dart';
import '../../chat/chatMessages.dart';
import '../../chat/listChatScreen.dart';
import '../profile_edit.dart';
import '../profile_setting.dart';
import '../image_screen.dart';

class ProfileInformation extends StatefulWidget {
  ProfileInformation(
      {super.key, required this.user, this.onImageUrlChanged, this.clientID});
  final String? clientID;
  final ValueChanged<String>? onImageUrlChanged;
  final UserModel user;

  @override
  State<ProfileInformation> createState() => _ProfileInformationState();
}

class _ProfileInformationState extends State<ProfileInformation> {
  final PostProvider _imageProvider = PostProvider();

  bool _isLoading = false;
  String _id = "";
  File? _image;
  late UserProvider userProvider;
  bool isFollowed = false;
  void initState() {
    super.initState();
    userProvider = p.Provider.of<UserProvider>(context, listen: false);
    if (widget.clientID != null) {
      userProvider
          .getFollow(widget.user.userId.toString(), widget.clientID.toString())
          .whenComplete(() => setState(() {
                _isLoading = true;
              }));
    }
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
    return Container(
        height: 360.h,
        child: Transform.translate(
          offset: Offset(0.0, 0.0), // dịch chuyển widget con lên 20 pixel

          child: Column(
            children: [
              p.Consumer<UserProvider>(
                builder: (context, userProvider, _) {
                  final user = widget.clientID == null
                      ? userProvider.user
                      : userProvider.userByID;
                  return Stack(children: [
                    Container(
                      width: double.infinity,
                      height: 360.h,
                    ),
                    Positioned(
                      child: Container(
                        width: double.infinity,
                        height: 200.h,
                        decoration: BoxDecoration(
                          // color: Colors.red,
                          image: DecorationImage(
                              fit: BoxFit.fitWidth,
                              image: AssetImage("assets/images/test.png")),
                        ),
                      ),
                    ),
                    Positioned(
                      child: Container(
                          width: 1.sw,
                          height: 200.h,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color.fromARGB(255, 75, 7, 7).withOpacity(0.6),
                                Colors.transparent,
                              ],
                            ),
                          )),
                    ),
                    Positioned(
                        right: 10.w,
                        top: 10.h,
                        child: Container(
                            child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                widget.clientID == null
                                    ? Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                EditProfile(user: user)))
                                    : Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ChatPage(
                                                userTo: widget.clientID,
                                                userFrom:
                                                    userProvider.user.userId)));
                              },
                              child: widget.clientID == null
                                  ? Icon(
                                      Icons.edit_outlined,
                                      color: Colors.white,
                                    )
                                  : Icon(
                                      Icons.chat_bubble_outline,
                                      color: Colors.white,
                                    ),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Icon(
                              Icons.more_horiz,
                              color: Colors.white,
                            ),
                          ],
                        ))),
                    Positioned(
                        top: 150.h,
                        right: 18.w,
                        child: CircleAvatar(
                          radius: 65.r,
                          backgroundColor: HexColor("#FFFFFF"),
                          child: user.imageUrl == null
                              ? (CircleAvatar(
                                  foregroundImage: _image != null
                                      ? FileImage(_image!)
                                      : null,
                                  radius: 60.r,
                                  backgroundColor: HexColor("#BB2649"),
                                  child: Text(
                                      "${user.name.toString().substring(0, 1).toUpperCase()}",
                                      style: TextStyle(fontSize: 40.sp))))
                              : CircleAvatar(
                                  radius: 60.r,
                                  backgroundColor: HexColor("#BB2649"),
                                  backgroundImage:
                                      NetworkImage("${user.imageUrl}"),
                                ),
                        )),
                    Positioned(
                        top: 240.h,
                        right: 20.w,
                        child: widget.clientID == null || _isLoading == false
                            ? Container()
                            : Container(
                                width: 30.w,
                                height: 30.h,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: userProvider.isFollow == false
                                      ? HexColor("#BB2649")
                                      : Colors.green,
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    userProvider.isFollow == false
                                        ? userProvider.addFollow(
                                            userProvider.user.userId.toString(),
                                            widget.clientID.toString())
                                        : userProvider.deleteFollow(
                                            userProvider.user.userId.toString(),
                                            widget.clientID.toString());
                                  },
                                  child: Icon(
                                    userProvider.isFollow == false
                                        ? Icons.add
                                        : Icons.check,
                                    color: Colors.white,
                                  ),
                                ),
                              )),
                    Positioned(
                        top: 200.h,
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 18.w),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 20.h,
                              ),
                              Text(
                                "${user.fullname ?? user.name}",
                                style: textTheme.semibold20(),
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Row(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "9868",
                                        style: textTheme.headline17(
                                            color: "000000"),
                                      ),
                                      SizedBox(
                                        width: 5.w,
                                      ),
                                      Text(
                                        "Followers",
                                        style:
                                            textTheme.medium12(color: "95969D"),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "9868",
                                        style: textTheme.headline17(
                                            color: "000000"),
                                      ),
                                      SizedBox(
                                        width: 5.w,
                                      ),
                                      Text(
                                        "Followers",
                                        style:
                                            textTheme.medium12(color: "95969D"),
                                      )
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 8.h,
                              ),
                              Container(
                                width: 0.85.sw,
                                child: Text(
                                  "Không có áp lực, không thành công. Mọi thứ tiêu cực – áp lực, thử thách – đều là cơ hội để bạn rèn luyện cũng như vươn lên đạt thành công.",
                                  style: textTheme.medium14(color: "95969D"),
                                ),
                              )
                            ],
                          ),
                        ))
                  ]);
                },
              ),
              // Container(
              //   padding: EdgeInsets.only(bottom: 25),
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       p.Consumer<UserProvider>(
              //         builder: (context, userProvider, _) {
              //           final user = widget.clientID == null
              //               ? userProvider.user
              //               : userProvider.userByID;
              //           return Stack(
              //             children: [
              //               GestureDetector(
              //                 onTap: () {
              //                   _bottomSheetChangeAvatar(context);
              //                 },
              //                 child: user.imageUrl == null
              //                     ? (CircleAvatar(
              //                         foregroundImage:
              //                             _image != null ? FileImage(_image!) : null,
              //                         radius: 50.r,
              //                         backgroundColor: HexColor("#BB2649"),
              //                         child: Text(
              //                             "${user.name.toString().substring(0, 1).toUpperCase()}",
              //                             style: TextStyle(fontSize: 40.sp))))
              //                     : CircleAvatar(
              //                         radius: 50,
              //                         backgroundColor: HexColor("#BB2649"),
              //                         backgroundImage:
              //                             NetworkImage("${user.imageUrl}"),
              //                       ),
              //               ),
              //               Positioned(
              //                   bottom: 0,
              //                   right: 0,
              //                   child: widget.clientID == null || _isLoading == false
              //                       ? Container()
              //                       : Container(
              //                           width: 30.w,
              //                           height: 30.h,
              //                           decoration: BoxDecoration(
              //                             shape: BoxShape.circle,
              //                             color: userProvider.isFollow == false
              //                                 ? HexColor("#BB2649")
              //                                 : Colors.green,
              //                           ),
              //                           child: GestureDetector(
              //                             onTap: () {
              //                               userProvider.isFollow == false
              //                                   ? userProvider.addFollow(
              //                                       userProvider.user.userId
              //                                           .toString(),
              //                                       widget.clientID.toString())
              //                                   : userProvider.deleteFollow(
              //                                       userProvider.user.userId
              //                                           .toString(),
              //                                       widget.clientID.toString());
              //                             },
              //                             child: Icon(
              //                               userProvider.isFollow == false
              //                                   ? Icons.add
              //                                   : Icons.check,
              //                               color: Colors.white,
              //                             ),
              //                           ),
              //                         ))
              //             ],
              //           );
              //         },
              //       ),
              //       SizedBox(
              //         height: 10.h,
              //       ),
              //       Text(
              //         "${widget.user.usertype}",
              //         style: textTheme.regular13(color: "95969D"),
              //       ),
              //       SizedBox(
              //         height: 20.h,
              //       ),
              //       Padding(
              //         padding: EdgeInsets.symmetric(horizontal: 50.w),
              //         child: Row(
              //           children: [
              //             _buildUserInfor(context, "Đang Follow", "100"),
              //             _buildUserInfor(context, "Follow", "100"),
              //             _buildUserInfor(context, "Thích", "100")
              //           ],
              //         ),
              //       ),
              //       SizedBox(
              //         height: 20.h,
              //       ),
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         children: [
              //           ElevatedButton(
              //             onPressed: () {
              //               widget.clientID == null
              //                   ? Navigator.push(
              //                       context,
              //                       MaterialPageRoute(
              //                           builder: (context) =>
              //                               EditProfile(user: widget.user)))
              //                   : Navigator.push(
              //                       context,
              //                       MaterialPageRoute(
              //                           builder: (context) => ChatPage(
              //                               userTo: widget.clientID,
              //                               userFrom: userProvider.user.userId)));
              //             },
              //             child: widget.clientID == null
              //                 ? Row(
              //                     children: [
              //                       Icon(Icons.mode_edit_outlined),
              //                       Text("Chỉnh sửa thông tin")
              //                     ],
              //                   )
              //                 : Text("Nhắn tin"),
              //             style: ElevatedButton.styleFrom(
              //                 primary: HexColor("#BB2649"), fixedSize: Size(200, 50)),
              //           ),
              //           SizedBox(
              //             width: 10,
              //           ),
              //           ElevatedButton(
              //             onPressed: () {
              //               Navigator.push(
              //                   context,
              //                   MaterialPageRoute(
              //                       builder: (context) => ProfileSettingScreen()));
              //             },
              //             child: Icon(
              //               Icons.more_horiz_outlined,
              //               color: Colors.black,
              //             ),
              //             style: ElevatedButton.styleFrom(
              //                 primary: HexColor("#FFFFFF"), fixedSize: Size(50, 50)),
              //           ),
              //         ],
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ));
  }

  _bottomSheetChangeAvatar(BuildContext context) {
    double containerHeight = 200.0.h;
    return showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.r),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            if (constraints.maxWidth > constraints.maxHeight) {
              containerHeight = 300.0.h;
            } else {
              containerHeight = 240.0.h;
            }
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.r),
                    topRight: Radius.circular(20.r)),
                color: HexColor("#BB2649"),
              ),
              height: containerHeight,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 10.h, bottom: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            height: 5.h, width: 35.w, color: Colors.white),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.0.h),
                  GestureDetector(
                    onTap: () {},
                    child: Row(
                      children: [
                        Icon(
                          Icons.person_sharp,
                          size: 33,
                          color: Colors.white,
                        ),
                        SizedBox(width: 13.0.h),
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
                  SizedBox(height: 16.0.h),
                  GestureDetector(
                    onTap: () async {
                      final picker = ImagePicker();
                      final imageFile = await picker.pickImage(
                        source: ImageSource.gallery,
                        maxWidth: 1200.w,
                        maxHeight: 1200.h,
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
                        SizedBox(width: 13.0.w),
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
                  SizedBox(height: 16.0.h),
                  GestureDetector(
                    onTap: () {},
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete,
                          size: 33,
                          color: Colors.white,
                        ),
                        SizedBox(width: 13.0.h),
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
        SizedBox(
          height: 5.h,
        ),
        Text(
          type,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: Colors.grey.shade600, letterSpacing: 1.1, fontSize: 12.sp),
        )
      ],
    ),
  );
}
