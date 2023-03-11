import 'package:flutter/cupertino.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageHelper {
  ImageHelper(
    this._imagePicker, {
    ImagePicker? imagePicker,
  });
  final ImagePicker _imagePicker;

  pickImage(
      {ImageSource source = ImageSource.gallery,
      int imageQuality = 100,
      bool multiple = false}) async {
    if (multiple) {
      return await _imagePicker.pickMultiImage(imageQuality: imageQuality);
    }
    final file = await _imagePicker.pickImage(
        source: source, imageQuality: imageQuality);
    if (file != null) return [file];
  }
}
