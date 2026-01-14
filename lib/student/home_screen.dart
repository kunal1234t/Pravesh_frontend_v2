import 'package:flutter/material.dart';
import 'package:pravesh_screen/student/QRGenerator.dart';
import 'package:pravesh_screen/app_colors_provider.dart';
import 'package:pravesh_screen/student/exitForm.dart';
import 'package:pravesh_screen/student/leaveForm.dart';
import 'package:pravesh_screen/themeNotifier.dart';
import 'package:pravesh_screen/widgets/color.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = appColors(context);

    return Container(
      color: colors.background,
      child: SafeArea(
        child: Column(
          children: [
            const _HomeAppBar(),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.06,
                    vertical: MediaQuery.of(context).size.height * 0.02,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03),
                      const _HeaderSection(),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.08),
                      const _ActionCardsSection(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeAppBar extends StatelessWidget {
  const _HomeAppBar();

  @override
  Widget build(BuildContext context) {
    final colors = appColors(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: true);

    return AppBar(
      toolbarHeight: screenHeight * 0.12,
      backgroundColor: colors.background,
      title: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            _ProfileAvatar(screenWidth: screenWidth, colors: colors),
            SizedBox(width: screenWidth * 0.04),
            const _UserGreeting(),
            const Spacer(),
            IconButton(
              onPressed: () => themeNotifier.toggleTheme(),
              icon: Icon(
                themeNotifier.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                color: colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  final double screenWidth;
  final AppColors colors;

  const _ProfileAvatar({
    required this.screenWidth,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // CORRECT: Already using route-based navigation
        Navigator.of(context).pushNamed('/profile');
      },
      child: Container(
        padding: EdgeInsets.all(screenWidth * 0.03),
        decoration: BoxDecoration(
          color: colors.green.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.person,
          color: colors.green,
          size: screenWidth * 0.055,
        ),
      ),
    );
  }
}

class _UserGreeting extends StatelessWidget {
  const _UserGreeting();

  String _getTimeBasedGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning!';
    if (hour < 17) return 'Good Afternoon!';
    return 'Good Evening!';
  }

  @override
  Widget build(BuildContext context) {
    final colors = appColors(context);
    final screenWidth = MediaQuery.of(context).size.width;

    // TODO: Fetch user name from auth service when backend is ready
    final userName = 'Rishabh'; // Placeholder

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hello $userName',
          style: TextStyle(
            color: colors.white,
            fontSize: screenWidth * 0.042,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          _getTimeBasedGreeting(),
          style: TextStyle(
            color: colors.green,
            fontSize: screenWidth * 0.032,
          ),
        ),
      ],
    );
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  @override
  Widget build(BuildContext context) {
    final colors = appColors(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Center(
      child: Column(
        children: [
          Text(
            'Scan-Go-Grow',
            style: TextStyle(
              color: colors.white,
              fontSize: screenWidth * 0.06,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
            ),
          ),
          SizedBox(height: screenHeight * 0.005),
          Text(
            'Campus Exit',
            style: TextStyle(
              color: colors.green,
              fontSize: screenWidth * 0.042,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionCardsSection extends StatelessWidget {
  const _ActionCardsSection();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final colors = appColors(context);

    return Column(
      children: [
        _CompactActionCard(
          icon: Icons.exit_to_app,
          title: 'Exit',
          onTap: () => _navigateToExit(context),
          colors: colors,
        ),
        SizedBox(height: screenHeight * 0.02),
        _CompactActionCard(
          icon: Icons.login,
          title: 'Enter',
          onTap: () => _navigateToEnter(context),
          colors: colors,
        ),
        SizedBox(height: screenHeight * 0.02),
        _CompactActionCard(
          icon: Icons.nightlight_round,
          title: 'Night Pass',
          onTap: () => _navigateToNightPass(context),
          colors: colors,
        ),
      ],
    );
  }

  void _navigateToExit(BuildContext context) {
    // Route-based navigation for consistency
    Navigator.pushNamed(context, '/exit-form');
  }

  void _navigateToEnter(BuildContext context) {
    // Route-based navigation for consistency
    Navigator.pushNamed(context, '/qr-generator');
  }

  void _navigateToNightPass(BuildContext context) {
    // Route-based navigation for consistency
    Navigator.pushNamed(context, '/leave-form');
  }
}

class _CompactActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final AppColors colors;

  const _CompactActionCard({
    required this.icon,
    required this.title,
    required this.onTap,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
          vertical: screenWidth * 0.04,
        ),
        decoration: BoxDecoration(
          color: colors.box,
          borderRadius: BorderRadius.circular(screenWidth * 0.035),
          boxShadow: [
            BoxShadow(
              color: colors.green.withOpacity(0.1),
              blurRadius: 8,
              spreadRadius: 1,
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(screenWidth * 0.03),
              decoration: BoxDecoration(
                color: colors.green.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: colors.green,
                size: screenWidth * 0.055,
              ),
            ),
            SizedBox(width: screenWidth * 0.035),
            Text(
              title,
              style: TextStyle(
                color: colors.white,
                fontSize: screenWidth * 0.042,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Icon(Icons.chevron_right,
                color: colors.green, size: screenWidth * 0.05),
          ],
        ),
      ),
    );
  }
}
