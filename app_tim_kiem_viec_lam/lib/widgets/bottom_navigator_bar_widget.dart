import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../core/providers/user_provider.dart';

class BottomNavigatorBarWidget extends StatefulWidget {
  const BottomNavigatorBarWidget({Key? key}) : super(key: key);

  @override
  _BottomNavigatorBarWidgetState createState() =>
      _BottomNavigatorBarWidgetState();
}

class _BottomNavigatorBarWidgetState extends State<BottomNavigatorBarWidget> {
  late UserProvider userProvider;
  int _currentTab = 0;
  void initState() {
    userProvider = Provider.of<UserProvider>(context, listen: false);

    super.initState();
  }

  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      notchMargin: 10,
      child: Container(
        height: 60.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              flex: 6,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  MaterialButton(
                    minWidth: 30.w,
                    onPressed: () {
                      setState(() {
                        userProvider.setCurrentTab = 1;
                        setState(() {
                          _currentTab = userProvider.currentTab;
                          print(_currentTab);
                        });
                      });

                      // widget.setCurrentTab(0);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.home_filled,
                          size: 20,
                          // color: widget.currentTab == 0
                          //     ? HexColor("#BB2649")
                          //     : Colors.grey,
                        ),
                        Text(
                          'Trang chủ',
                          style: TextStyle(
                            fontSize: 10.sp,
                            // color: widget.currentTab == 0
                            //     ? HexColor("#BB2649")
                            //     : Colors.grey,
                          ),
                        )
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 30.w,
                    onPressed: () {
                      userProvider.setCurrentTab = 1;
                      setState(() {
                        _currentTab = userProvider.currentTab;
                        print(_currentTab);
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.change_circle_outlined,
                          size: 20,
                          // color: widget.currentTab == 1
                          //     ? HexColor("#BB2649")
                          //     : Colors.grey,
                        ),
                        Text(
                          'Tương tác',
                          style: TextStyle(
                            fontSize: 10.sp,
                            // color: widget.currentTab == 1
                            //     ? HexColor("#BB2649")
                            //     : Colors.grey,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(),
              flex: 1,
            ),
            Expanded(
              flex: 6,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  MaterialButton(
                    minWidth: 30.w,
                    onPressed: () {
                      userProvider.setCurrentTab = 2;
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.message_outlined,
                          size: 20,
                          // color: widget.currentTab == 2
                          //     ? HexColor("#BB2649")
                          //     : Colors.grey,
                        ),
                        Text(
                          'Nhắn tin',
                          style: TextStyle(
                            fontSize: 10.sp,
                            // color: widget.currentTab == 2
                            //     ? HexColor("#BB2649")
                            //     : Colors.grey,
                          ),
                        )
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 30.w,
                    onPressed: () {
                      _globalKey.currentState?.openEndDrawer();
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.menu,
                          size: 20,
                          // color: widget.currentTab == 3
                          //     ? HexColor("#BB2649")
                          //     : Colors.grey,
                        ),
                        Text(
                          'Lựa chọn',
                          style: TextStyle(
                            fontSize: 10.sp,
                            // color: widget.currentTab == 3
                            //     ? HexColor("#BB2649")
                            //     : Colors.grey,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
