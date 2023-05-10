import 'package:app_tim_kiem_viec_lam/utils/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';

class PickerDateTime extends StatefulWidget {
  const PickerDateTime(
      {super.key, this.onSelectedItemChanged, this.initDateTime});
  final DateTime? initDateTime;
  final ValueChanged<DateTime>? onSelectedItemChanged;
  @override
  State<PickerDateTime> createState() => _PickerDateTimeState();
}

class _PickerDateTimeState extends State<PickerDateTime> {
  DateTime? date;
  int _selectedValue = 0;
  void initState() {
    super.initState();
    date = widget.initDateTime;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
      margin: EdgeInsets.symmetric(vertical: 18.h),
      width: 1.sw,
      child: DefaultTextStyle(
        style: TextStyle(
          color: Colors.black,
          backgroundColor: Colors.white,
          fontSize: 22.0,
        ),
        child: CupertinoButton(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
          onPressed: () {
            showCupertinoModalPopup<void>(
                context: context,
                builder: (BuildContext context) => Container(
                      height: 216,
                      padding: const EdgeInsets.only(top: 6.0),
                      margin: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      color:
                          CupertinoColors.systemBackground.resolveFrom(context),
                      child: CupertinoDatePicker(
                        initialDateTime: date,
                        minimumYear: date!.year,
                        maximumYear: int.parse(date!.year.toString()) + 30,
                        mode: CupertinoDatePickerMode.date,
                        use24hFormat: true,
                        onDateTimeChanged: (DateTime newDate) {
                          setState(() => date = newDate);
                          widget.onSelectedItemChanged?.call(date!);
                        },
                      ),
                    ));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Ngày hết hạn: ',
                style: textTheme.regular13(color: "000000"),
              ),
              Spacer(),
              Text(
                '${date!.month}-${date!.day}-${date!.year}',
                style: textTheme.regular13(color: "000000"),
              ),
              SizedBox(
                width: 8.w,
              ),
              Icon(
                Icons.calendar_month_outlined,
                color: HexColor("#BB2649"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
