import 'package:app_tim_kiem_viec_lam/utils/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PickerYear extends StatefulWidget {
  const PickerYear(
      {super.key,
      required this.title,
      required this.listData,
      this.width = 1,
      this.height = 135,
      this.onSelectedItemChanged});
  final String? title;
  final List<String> listData;
  final num? width;
  final num? height;
  final ValueChanged<String>? onSelectedItemChanged;
  @override
  State<PickerYear> createState() => _PickerYearState();
}

class _PickerYearState extends State<PickerYear> {
  int _selectedValue = 0;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width!.toDouble().sw,
      child: DefaultTextStyle(
          style: TextStyle(
            // color: CupertinoColors.label.resolveFrom(context),
            backgroundColor: Colors.white,
            fontSize: 22.0,
          ),
          child: CupertinoButton(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
            color: Colors.white,
            disabledColor: Colors.black,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${widget.title}",
                    style: textTheme.medium14(color: "000000", opacity: 0.3)),
                Text(
                  "${widget.listData[_selectedValue]}",
                  style: textTheme.medium14(color: "000000", opacity: 0.3),
                ),
              ],
            ),
            onPressed: () {
              showCupertinoModalPopup(
                context: context,
                builder: (_) {
                  return Container(
                    color:
                        CupertinoColors.systemBackground.resolveFrom(context),
                    width: double.infinity,
                    height: 180.h,
                    child: CupertinoPicker(
                        magnification: 1.22,
                        squeeze: 1.2,
                        useMagnifier: true,
                        scrollController:
                            FixedExtentScrollController(initialItem: 1),
                        itemExtent: 30,
                        onSelectedItemChanged: (value) {
                          setState(() {
                            _selectedValue = value;
                          });
                          widget.onSelectedItemChanged
                              ?.call(widget.listData[_selectedValue]);
                        },
                        children: [
                          ...widget.listData.map((e) {
                            return Text("$e");
                          }),
                        ]),
                  );
                },
              );
            },
          )),
    );
  }
}

class $ {}
