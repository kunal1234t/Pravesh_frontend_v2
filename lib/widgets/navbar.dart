// navbar.dart
import 'package:flutter/material.dart';
import 'package:pravesh_screen/app_colors_provider.dart';
import 'package:pravesh_screen/guard/new_visitor_managment.dart';
import 'package:pravesh_screen/student/home_screen.dart';
import 'package:pravesh_screen/student/notifications.dart';
import 'package:pravesh_screen/student/FAQscreen.dart';
import 'package:pravesh_screen/common/profile.dart';
import 'package:pravesh_screen/teacher/TEC_1.dart';
import 'package:pravesh_screen/warden/warden_home_screen.dart';

enum UserRole {
  student,
  teacher,
  warden,
  guard,
}

class Navbar extends StatefulWidget {
  final int initialIndex;
  final UserRole userRole;

  const Navbar({
    super.key,
    this.initialIndex = 0,
    required this.userRole,
  });

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  late int _selectedIndex;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _pages = _buildPages();
  }

  List<Widget> _buildPages() {
    return [
      _getHomePage(),
      _getNotificationsPage(),
      ViewProfileScreen(),
      _getHelpPage(),
    ];
  }

  Widget _getHomePage() {
    switch (widget.userRole) {
      case UserRole.student:
        return HomePage();
      case UserRole.teacher:
        return TeacherDashboardScreen();
      case UserRole.warden:
        return WardenHomeScreen();
      case UserRole.guard:
        return GuardDashboardScreen();
    }
  }

  Widget _getNotificationsPage() {
    switch (widget.userRole) {
      case UserRole.student:
        return Notifications();
      case UserRole.teacher:
        return Notifications();
      case UserRole.warden:
        return Notifications();
      case UserRole.guard:
        return Notifications();
    }
  }

  Widget _getHelpPage() {
    switch (widget.userRole) {
      case UserRole.student:
        return HelpCenterScreen();
      case UserRole.teacher:
        return HelpCenterScreen();
      case UserRole.warden:
        return HelpCenterScreen();
      case UserRole.guard:
        return HelpCenterScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = appColors(context);

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: colors.box,
        unselectedItemColor: colors.white,
        selectedItemColor: const Color(0xff0ACF83),
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: "Notifications",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.help),
            label: "Help",
          ),
        ],
      ),
    );
  }
}
