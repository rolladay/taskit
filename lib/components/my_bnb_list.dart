import 'package:flutter/material.dart';

double bnbItemSize = 34;

// MyBnbList를 MyHome(Frame) 위젯, Scaffold, BottomNavigationBar위젯 속성에서 List를 불러와서 구현
final myBnbList = [
  BottomNavigationBarItem(
    icon: Image.asset('assets/images/bnbt_month_inactive.png', width: bnbItemSize,),
    activeIcon: Image.asset('assets/images/bnbt_month_active.png', width: bnbItemSize,),
    label: 'Calendar',
  ),
  BottomNavigationBarItem(
    icon: Image.asset('assets/images/bnbt_day_inactive.png', width: bnbItemSize,),
    activeIcon: Image.asset('assets/images/bnbt_day_active.png', width: bnbItemSize,),
    label: 'Time',
  ),
  BottomNavigationBarItem(
    icon: Image.asset('assets/images/bnbt_tool_inactive.png', width: bnbItemSize,),
    activeIcon: Image.asset('assets/images/bnbt_tool_active.png', width: bnbItemSize,),
    label: 'Tools',
  ),
];