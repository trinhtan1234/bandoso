import 'package:bandoso/taikhoan/dangnhaptaikhoan.dart';
import 'package:flutter/material.dart';

import 'bandoso/bandoso.dart';

class MenuKhungApp extends StatefulWidget {
  const MenuKhungApp({super.key});

  @override
  State<MenuKhungApp> createState() => _MenuKhungAppState();
}

class _MenuKhungAppState extends State<MenuKhungApp> {
  int _selectedIndex = 0;

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();

    _pages = [
      const BanDoSo(),
      const Text('Đóng góp'),
      const LoginScreen(),
    ];
  }

  List<Widget> _pages = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _navigateBottomBar,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.pin_drop), label: 'Khám phá'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Đóng góp'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Tài khoản'),
        ],
      ),
    );
  }
}
