import 'package:flutter/material.dart';
import 'package:futurefinder_flutter/view/bottom_nav_bar.dart';
import 'package:go_router/go_router.dart';

class ShellScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const ShellScreen({super.key, required this.navigationShell});

  static const _appBarTitles = <String>[
    'Future Finder',
    '금융',
    '청약',
    '일자리',
    '설정',
  ];

  @override
  Widget build(BuildContext context) {
    final bool isHomeScreen = navigationShell.currentIndex == 0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: navigationShell.currentIndex == 2
            ? const Color(0xFFF8F9FA)
            : Colors.white,
        elevation: 0,
        title: Text(
          _appBarTitles[navigationShell.currentIndex],
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: isHomeScreen ? 22 : 24, // 홈 화면만 22, 나머지는 24로 설정
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: navigationShell,
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
      ),
    );
  }
}
