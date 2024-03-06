import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../cores/configs/config_colors.dart';
import 'HomePage.dart';

class MainLayout extends StatefulWidget {
  @override
  _MainLayoutState createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedBottomNavIndex = 0;
  final _bottomNavPages = [
    HomePage(),
    // ProfilePage(),
    // SettingPage(),
  ];
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        extendBody: true,
        body: PageView(
          controller: _pageController,
          allowImplicitScrolling: false,
          pageSnapping: true,
          physics: const NeverScrollableScrollPhysics(),
          children: _bottomNavPages,
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(15.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(45.0),
            child: BottomNavigationBar(
              iconSize: 20.0,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.home),
                  label: 'Beranda',
                ),
                BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.userAlt),
                  label: 'Profil',
                ),
                BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.wrench),
                  label: 'Pengaturan',
                ),
              ],
              type: BottomNavigationBarType.fixed,
              currentIndex: _selectedBottomNavIndex,
              onTap: (index) {
                setState(() {
                  _selectedBottomNavIndex = index;
                  _pageController.animateToPage(index,
                      curve: Curves.easeInOut,
                      duration: const Duration(milliseconds: 200));
                });
              },
              elevation: 5.0,
              backgroundColor: ConfigColor.primaryColor,
              fixedColor: Colors.white,
              // selectedFontSize: 14.0,
              // selectedIconTheme: IconThemeData(size: 28.0),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    return await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            title: const Text(
              'Konfirmasi',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            content: const Text('Anda yakin akan keluar aplikasi ?'),
            actions: <Widget>[
              ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  )),
                  backgroundColor: MaterialStateProperty.all(Colors.grey[500]),
                ),
                child: const Text(
                  'Tidak',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () => Navigator.of(dialogContext).pop(false),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  )),
                  backgroundColor: MaterialStateProperty.all(Colors.green[500]),
                ),
                child: const Text(
                  'Ya',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () => Navigator.of(dialogContext).pop(true),
              ),
            ],
          ),
        ) ??
        false;
  }
}
