import 'package:flutter/material.dart';
import 'package:policethanya_app/alert_page.dart';
import 'package:policethanya_app/doworks_page.dart';
import 'package:policethanya_app/loc_page.dart';
import 'package:policethanya_app/menu_page.dart';
import 'package:policethanya_app/model/location_model.dart';
import 'package:policethanya_app/qr_page.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  initState() {
    super.initState();
  }

  PageController _pageController = PageController();
  List<Widget> _screens = [
    DoworksPage(),
    LocPage(),
    QrPage(),
    AlertPage(),
    MenuPage()
  ];

  int _selectedIndex = 0;
  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onItemTapped(int selectedIndex) {
    _pageController.jumpToPage(selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<LocationModel>(context);

    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: _screens,
        onPageChanged: _onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.red[900],
        //selectedFontSize: 16,
        //selectedItemColor: Colors.white,
        unselectedFontSize: 15,
        unselectedItemColor: Colors.white54,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.work,
              color: _selectedIndex == 0 ? Colors.white : null,
            ),
            label: 'เข้า/ออกเวร',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.gps_fixed,
              color: _selectedIndex == 1 ? Colors.white : null,
            ),
            label: 'ตำเเหน่ง',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.qr_code_scanner,
              color: _selectedIndex == 2 ? Colors.white : null,
            ),
            label: 'คิวอาร์โค้ด',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.notifications,
              color: _selectedIndex == 3 ? Colors.white : null,
            ),
            label: 'เเจ้งเตือน',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.menu,
              color: _selectedIndex == 4 ? Colors.white : null,
            ),
            label: 'เมนู',
          ),
        ],
      ),
    );
  }
}
