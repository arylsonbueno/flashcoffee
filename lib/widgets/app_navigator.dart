import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../pages/home.dart';
import '../services/authentication.dart';

import '../services/basket_controller.dart';
import '../utils/event_controller.dart';

class AppNavigator extends StatefulWidget {
  AppNavigator({Key? key, this.auth, this.logoutCallback}) : super(key: key);

  final BaseAuth? auth;
  final VoidCallback? logoutCallback;

  @override
  _AppNavigatorState createState() => _AppNavigatorState();
}

class _AppNavigatorState extends State<AppNavigator> {
  int _currentIndex = 0;
  User? userSession;
  final List<Widget> _pages = [];
  PageController _pageController = PageController();
  int _offlineRecords = 0;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
        future: _load(),
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          if (userSession != null) {
            return Scaffold(
                body: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  children: _pages,
                ),
                bottomNavigationBar: _bottomNavBar());
          }
          return CircularProgressIndicator();
        });
  }

  Widget _bottomNavBar() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      child: BottomNavigationBar(
          currentIndex: _currentIndex,
          enableFeedback: true,
          onTap: onTabTapped,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          selectedItemColor: Theme.of(context).colorScheme.outline,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
          selectedIconTheme:
              IconThemeData(color: Theme.of(context).colorScheme.tertiary),
          unselectedIconTheme:
              IconThemeData(color: Theme.of(context).colorScheme.outline),
          items: [
            BottomNavigationBarItem(
                icon: _inactiveIcon(Icons.home_outlined),
                activeIcon: _activeIcon(Icons.home),
                label: "Home"),
            BottomNavigationBarItem(
                icon: _inactiveIcon(Icons.shopping_basket, withBadge: true),
                activeIcon: _activeIcon(Icons.shopping_basket_outlined, withBadge: true),
                label: "Cesta"),
            BottomNavigationBarItem(
                icon: _inactiveIcon(Icons.menu),
                activeIcon: _activeIcon(Icons.menu_outlined),
                label: "Perfil")
          ]),
    );
  }

  Widget _activeIcon(IconData icon, {bool withBadge = false}) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 17, vertical: 2),
        margin: EdgeInsets.only(bottom: 4),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.horizontal(
            left: Radius.circular(18),
            right: Radius.circular(18),
          ),
        ),
        child: _getIcon(withBadge, icon));
  }

  Widget _inactiveIcon(IconData icon, {bool withBadge = false}) {
    return Container(
        margin: EdgeInsets.only(bottom: 4), child: _getIcon(withBadge, icon));
  }

  Widget _getIcon(bool withBadge, IconData icon) {
    return withBadge
        ? Badge(
            backgroundColor: Theme.of(context).colorScheme.error,
            isLabelVisible: _offlineRecords > 0,
            label: Text(_offlineRecords.toString()),
            child: Icon(icon),
          )
        : Icon(icon);
  }

  void onTabTapped(int index) {
    _pageController.jumpToPage(index);
  }

  _loadUserSession() async {
    userSession = await widget.auth!.getCurrentUser();
  }

  _load() async {
    await _loadUserSession();
    if (_pages.isEmpty)
      await _initPages();
  }

  _initPages() async {
    _pages.add(HomePage(userSession!));
  }

}
