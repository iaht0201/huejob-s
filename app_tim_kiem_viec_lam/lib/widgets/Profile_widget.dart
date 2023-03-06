import 'dart:io' as io;

import 'package:app_tim_kiem_viec_lam/core/supabase/supabase.dart';
import 'package:app_tim_kiem_viec_lam/widgets/image_helper.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/providers/job_provider.dart';

class ProfileWidget extends StatefulWidget {
  final String initials;
  final ValueChanged<String> onImageUrlChanged;
  const ProfileWidget({
    Key? key,
    required this.initials,
    required this.onImageUrlChanged,
  }) : super(key: key);

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

final imageHelper = ImageHelper();

class _ProfileWidgetState extends State<ProfileWidget> {
  final JobProvider _imageProvider = JobProvider();

  bool _isLoading = false;
  String _id = "";
  io.File? _image;

  Future<void> _upload(dynamic imageFile) async {
    final prefs = await SharedPreferences.getInstance();

    if (imageFile == null) {
      return;
    }
    setState(() {
      _isLoading = true;
      _id = prefs.getString('id')!;
      _image = io.File(imageFile.path);
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

      widget.onImageUrlChanged(imageUrlResponse);
    } on StorageException catch (error) {
      print(error);
    }

    setState(() => _isLoading = false);
  }

  void iniState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return Column(
      children: [
        Center(
          child: FittedBox(
            fit: BoxFit.contain,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 8,
                ),
              ),
              child: CircleAvatar(
                backgroundColor: Colors.grey[300],
                radius: 64,
                foregroundImage: _image != null ? FileImage(_image!) : null,
                child: Text(
                  widget.initials,
                  style: TextStyle(fontSize: 48),
                ),
              ),
            ),
          ),
        ),
        TextButton(
            onPressed: () async {
              final picker = ImagePicker();
              final imageFile = await picker.pickImage(
                source: ImageSource.gallery,
                maxWidth: 300,
                maxHeight: 300,
              );
              _upload(imageFile);
            },
            child: Text("Select Photo"))
      ],
    );
  }
}
