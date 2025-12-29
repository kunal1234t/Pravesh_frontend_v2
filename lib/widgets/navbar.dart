import 'package:flutter/material.dart';
import 'package:pravesh_screen/app_colors_provider.dart';

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
  static const int _profileTabIndex = 2;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> _getPages() {
    return [
      _getHomePage(),
      _getNotificationsPage(),
      SizedBox.shrink(), // Profile placeholder
      _getHelpPage(),
    ];
  }

  Widget _getHomePage() {
    switch (widget.userRole) {
      case UserRole.student:
        return const HomePage();
      case UserRole.teacher:
        return const TeacherHomePage();
      case UserRole.warden:
        return const WardenHomePage();
      case UserRole.guard:
        return const GuardHomePage();
    }
  }

  Widget _getNotificationsPage() {
    switch (widget.userRole) {
      case UserRole.student:
        return const Notifications();
      case UserRole.teacher:
        return const TeacherNotifications();
      case UserRole.warden:
        return const WardenNotifications();
      case UserRole.guard:
        return const GuardNotifications();
    }
  }

  Widget _getHelpPage() {
    switch (widget.userRole) {
      case UserRole.student:
        return const HelpCenterScreen();
      case UserRole.teacher:
        return const TeacherHelpScreen();
      case UserRole.warden:
        return const WardenHelpScreen();
      case UserRole.guard:
        return const GuardHelpScreen();
    }
  }

  void _handleTabTap(int index) {
    if (index == _profileTabIndex) {
      Navigator.of(context).pushNamed('/profile');
    } else {
      _onItemTapped(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = appColors(context);
    final pages = _getPages();

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: colors.box,
        unselectedItemColor: colors.white,
        selectedItemColor: const Color(0xff0ACF83),
        currentIndex: _selectedIndex,
        onTap: _handleTabTap,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: "Notifications"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          BottomNavigationBarItem(icon: Icon(Icons.help), label: "Help"),
        ],
      ),
    );
  }
}

// Placeholder imports - replace with actual role-specific screens
// import 'package:pravesh_screen/student/home_screen.dart';
// import 'package:pravesh_screen/student/notifications.dart';
// import 'package:pravesh_screen/student/FAQscreen.dart';
// import 'package:pravesh_screen/teacher/home_screen.dart';
// import 'package:pravesh_screen/teacher/notifications.dart';
// import 'package:pravesh_screen/teacher/help_screen.dart';
// import 'package:pravesh_screen/warden/home_screen.dart';
// import 'package:pravesh_screen/warden/notifications.dart';
// import 'package:pravesh_screen/warden/help_screen.dart';
// import 'package:pravesh_screen/guard/home_screen.dart';
// import 'package:pravesh_screen/guard/notifications.dart';
// import 'package:pravesh_screen/guard/help_screen.dart';

// Placeholder classes - replace with actual implementations
class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) => const Placeholder();
}

class TeacherHomePage extends StatelessWidget {
  const TeacherHomePage({super.key});
  @override
  Widget build(BuildContext context) => const Placeholder();
}

class WardenHomePage extends StatelessWidget {
  const WardenHomePage({super.key});
  @override
  Widget build(BuildContext context) => const Placeholder();
}

class GuardHomePage extends StatelessWidget {
  const GuardHomePage({super.key});
  @override
  Widget build(BuildContext context) => const Placeholder();
}

class Notifications extends StatelessWidget {
  const Notifications({super.key});
  @override
  Widget build(BuildContext context) => const Placeholder();
}

class TeacherNotifications extends StatelessWidget {
  const TeacherNotifications({super.key});
  @override
  Widget build(BuildContext context) => const Placeholder();
}

class WardenNotifications extends StatelessWidget {
  const WardenNotifications({super.key});
  @override
  Widget build(BuildContext context) => const Placeholder();
}

class GuardNotifications extends StatelessWidget {
  const GuardNotifications({super.key});
  @override
  Widget build(BuildContext context) => const Placeholder();
}

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});
  @override
  Widget build(BuildContext context) => const Placeholder();
}

class TeacherHelpScreen extends StatelessWidget {
  const TeacherHelpScreen({super.key});
  @override
  Widget build(BuildContext context) => const Placeholder();
}

class WardenHelpScreen extends StatelessWidget {
  const WardenHelpScreen({super.key});
  @override
  Widget build(BuildContext context) => const Placeholder();
}

class GuardHelpScreen extends StatelessWidget {
  const GuardHelpScreen({super.key});
  @override
  Widget build(BuildContext context) => const Placeholder();
}
