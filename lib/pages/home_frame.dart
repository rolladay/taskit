import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:taskit/pages/studio_tools.dart';
import '../components/my_bnb_list.dart';
import 'daily_schdule.dart';
import 'monthly_calendar.dart';

// 마이홈에는 바텀네비게이션바만 있으면 됨.
class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  MyHomeState createState() => MyHomeState();
}


class MyHomeState extends State<MyHome> {
  int _selectedIndex = 0;
  DateTime? currentBackPressTime;

  // late CalendarController _calendarController;
  void _onBnbItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return const MonthlyCalendar();
      case 1:
        return const DayPlanner();
      case 2:
        return const MyProfile();
      default:
        return const MonthlyCalendar(); // 기본값
    }
  }

  Future<void> _onWillPop() async {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
              'Press back to close Taskit.'),
          duration: const Duration(seconds: 2),
          action: SnackBarAction(
            label: 'OK',
            onPressed: () {
              // 액션 버튼을 눌렀을 때의 동작
            },
          ),
          backgroundColor: Colors.black87,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    } else {
      _exitApp();
    }
  }

  void _exitApp() {
    if (Platform.isAndroid) {
      SystemNavigator.pop();
    } else if (Platform.isIOS) {
      // 이 부분에 ios앱들은 어떻게 앱을 끄는지 확인해서 안내 메시지 넣게 해줘야함. exit(0)은 심사거절 사유
    }
  }


  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        }
        _onWillPop();
      },
      child: Scaffold(
        // 빌드바디에 의해 새로운 위젯들이 그려지는 경우, 기존 위젯은 dispose 되는 개념
        body: _buildBody(),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              color: Colors.black,
              height: 1,
              width: double.infinity,
            ),
            BottomNavigationBar(
              selectedFontSize: 12,
              selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
              showSelectedLabels: true,
              showUnselectedLabels: true,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
              items: myBnbList,
              currentIndex: _selectedIndex,
              onTap: _onBnbItemTapped,
            ),
          ],
        ),
      ),
    );
  }
}