import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stroll_test/chat_page.dart';
import 'package:stroll_test/hot_page.dart';
import 'package:stroll_test/profile_page.dart';

import 'home_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    HotPage(),
    ChatPage(),
    ProfilePage(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 1,
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Colors.black87,
            icon: SvgPicture.asset('assets/Card.svg'),
              label: ''
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/Vector.svg'),
              label: ''
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/Icons.svg'),
            label: ''
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/User.svg'),
              label: ''
          ),
        ],
      ),
    );
  }
}