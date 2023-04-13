import 'dart:io';
import 'dart:math';

import 'package:app_tim_kiem_viec_lam/core/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/providers/authenciation_provider.dart';
import '../../core/providers/user_provider.dart';
import '../../core/supabase/supabase.dart';

import 'package:provider/provider.dart' as p;

class ImageScreen extends StatefulWidget {
  final XFile imageFile;

  const ImageScreen({Key? key, required this.imageFile}) : super(key: key);

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  late UserProvider userProvider;
  // late UserModel user;
  void initState() {
    super.initState();
    userProvider = p.Provider.of<UserProvider>(context, listen: false);
    // userProvider.fetchUser();
    // user = userProvider.user;
  }

  Future<void> updateUser(dynamic imageFile, UserModel user) async {
    final prefs = await SharedPreferences.getInstance();

    if (imageFile == null) {
      return;
    }

    try {
      Random random = new Random();
      int randomNumber = random.nextInt(100);
      final bytes = await imageFile.readAsBytes();
      final fileExt = imageFile.name.split('.').last;
      final fileName =
          '${prefs.getString('id')}/${randomNumber}_${imageFile.name}';
      final filePath = fileName;
      await SupabaseBase.supabaseClient.storage.from('avatars').uploadBinary(
            filePath,
            bytes,
            fileOptions: FileOptions(contentType: imageFile.mimeType),
          );
      final imageUrlResponse = await SupabaseBase.supabaseClient.storage
          .from('avatars')
          .createSignedUrl(filePath, 60 * 60 * 24 * 365 * 10);
      if (imageUrlResponse != null) {
        //
        final newUser = UserModel(
            userId: user.userId,
            name: user.name,
            address: user.address,
            birthday: user.birthday,
            email: user.email,
            experience: user.experience,
            fullname: user.fullname,
            gender: user.gender,
            phone_number: user.phone_number,
            status: user.status,
            imageUrl: imageUrlResponse,
            usertype:
                user.usertype // usertypeGiữ nguyên giá trị của trường imageUrl
            );
        userProvider.updateImage(context, newUser);

//
        // final updates = {
        //   'userId': prefs.getString('id'),
        //   "imageUrl": "${imageUrlResponse}"
        // };
        // try {
        //   final response = await SupabaseBase.supabaseClient
        //       .from('users')
        //       .update(updates)
        //       .eq('userId', prefs.getString('id'))
        //       .execute();
        //   if (response != null) {
        //     Fluttertoast.showToast(
        //       msg: 'Cập nhật thông tin thành công!',
        //       gravity: ToastGravity.BOTTOM,
        //       backgroundColor: Colors.green,
        //       textColor: Colors.white,
        //     );
        //     Navigator.of(context).pop();
        //   }
        // } catch (e) {
        //   Fluttertoast.showToast(
        //     msg: 'Đang gặp sự cố!',
        //     gravity: ToastGravity.BOTTOM,
        //     backgroundColor: Colors.red,
        //     textColor: Colors.white,
        //   );
        // }
      }

      // widget.onImageUrlChanged(imageUrlResponse);
    } on StorageException catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    //  final provider = Provider.of<AuthenciationNotifier>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Lựa chọn hình ảnh'),
        actions: [
          p.Consumer<UserProvider>(
            builder: (context, userPorvider, child) {
              return GestureDetector(
                  onTap: () {
                    updateUser(widget.imageFile, userPorvider.user);
                  },
                  child: Text("Lưu"));
            },
          )
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width * 1,
        child: Center(
          child:
              //  Image.network("${File(widget.imageFile.path)}")
              Image.file(
            File(widget.imageFile.path),
            width: MediaQuery.of(context).size.width * 1,
          ),
        ),
      ),
    );
  }

  // Hiển thị Dialog
  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Thông báo'),
          content: Text('Bạn đã lưu ảnh thành công !'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Đóng'),
            ),
          ],
        );
      },
    );
  }
}
