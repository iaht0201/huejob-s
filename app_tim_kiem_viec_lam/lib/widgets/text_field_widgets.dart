import 'package:app_tim_kiem_viec_lam/core/models/job_category_model.dart';
import 'package:app_tim_kiem_viec_lam/core/providers/jobs_provider.dart';
import 'package:app_tim_kiem_viec_lam/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../core/providers/post_provider.dart';

class TextFieldWid extends StatefulWidget {
  final int maxLines;
  final String label;
  final String text;
  final bool enbled;
  final ValueChanged<String> onChanged;
  final num? width;
  final String? Function(String?)? validator;
  final String type;

  IconData? icon;
  TextFieldWid(
      {Key? key,
      this.maxLines = 1,
      required this.label,
      this.validator,
      required this.text,
      required this.enbled,
      required this.onChanged,
      this.icon,
      this.type = "normal",
      this.width = 1})
      : super(key: key);

  @override
  _TextFieldWidState createState() => _TextFieldWidState();
}

class _TextFieldWidState extends State<TextFieldWid> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.text);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Container(
        width: widget.width?.sw,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            TextFormField(
              keyboardType: widget.type == "normal"
                  ? TextInputType.name
                  : TextInputType.number,
              validator: widget.validator,
              enabled: widget.enbled,
              onChanged: widget.onChanged,
              controller: controller,
              style: textTheme.medium14(color: "000000"),
              decoration: InputDecoration(
                floatingLabelAlignment: FloatingLabelAlignment.start,
                prefixIcon: widget.icon != null
                    ? Icon(
                        widget.icon,
                        color: HexColor("#000000"),
                      )
                    : null,
                focusColor: Colors.black,
                labelText: widget.label,
                labelStyle: textTheme.medium14(color: "AFB0B6"),
                filled: true,
                fillColor:
                    widget.enbled ? Colors.white : Colors.grey.withOpacity(0.2),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              maxLines: widget.maxLines,
            ),
          ],
        ),
      );
}
