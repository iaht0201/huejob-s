import 'package:app_tim_kiem_viec_lam/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';

class TextFieldWidget extends StatefulWidget {
  final int maxLines;
  final String label;
  final String text;
  final bool enbled;
  final ValueChanged<String> onChanged;
  final num? width;
  const TextFieldWidget(
      {Key? key,
      this.maxLines = 1,
      required this.label,
      required this.text,
      required this.enbled,
      required this.onChanged,
      this.width = 1})
      : super(key: key);

  @override
  _TextFieldWidgetState createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
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
        // margin: EdgeInsets.symmetric(horizontal: 10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            TextFormField(
              enabled: widget.enbled,
              onChanged: widget.onChanged,
              controller: controller,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.home,
                  color: HexColor("#AFB0B6"),
                ),
                focusColor: Colors.black,
                hintText: widget.label,
                hintStyle: textTheme.medium14(color: "AFB0B6"),
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
