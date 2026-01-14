import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pravesh_screen/core/utils/responsive_helper.dart';
import 'package:pravesh_screen/guard/visitor_photo.dart';
import 'dart:async';

class GuardDashboardScreen extends StatefulWidget {
  const GuardDashboardScreen({super.key});

  @override
  State<GuardDashboardScreen> createState() => _GuardDashboardScreenState();
}

class _GuardDashboardScreenState extends State<GuardDashboardScreen> {
  late Timer _timer;
  late DateTime _now;
  String get _currentTime {
    return DateFormat('hh:mm a').format(_now);
  }

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning!';
    if (hour < 17) return 'Good Afternoon!';
    return 'Good Evening!';
  }

  @override
  Widget build(BuildContext context) {
    const cardColor = Color(0xFF273348);
    const accentGreen = Color(0xFF34D17B);
    final screenWidth = ResponsiveHelper.getScreenWidth(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05, vertical: 20.0),
          child: Column(
            children: [
              _buildHeader(screenWidth),
              SizedBox(height: screenWidth * 0.06),
              _buildStatsRow(context, cardColor),
              SizedBox(height: screenWidth * 0.08),
              _buildSectionTitle('Visitor Management', screenWidth),
              SizedBox(height: screenWidth * 0.04),
              _buildRegisterButton(context, accentGreen),
              SizedBox(height: screenWidth * 0.08),
              _buildSectionTitle('Recent Requests', screenWidth),
              SizedBox(height: screenWidth * 0.04),
              _buildRecentRequestItem(context, cardColor, accentGreen),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(double screenWidth) {
    return Row(
      children: [
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _greeting,
                style: TextStyle(
                    fontSize: screenWidth * 0.055,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ],
          ),
        ),
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              _currentTime,
              style: TextStyle(
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            SizedBox(height: screenWidth * 0.005),
            Text(
              'Nagpur, Maharashtra',
              style: TextStyle(
                  fontSize: screenWidth * 0.03, color: Colors.white60),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsRow(BuildContext context, Color cardColor) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          children: [
            Expanded(
              child: _StatCard(
                color: cardColor,
                icon: Icons.people_alt_outlined,
                iconColor: Colors.blue.shade300,
                title: "Today's Visitors",
                value: '12',
              ),
            ),
            SizedBox(width: constraints.maxWidth * 0.05),
            Expanded(
              child: _StatCard(
                color: cardColor,
                icon: Icons.shield_outlined,
                iconColor: Colors.green.shade400,
                title: 'Active Requests',
                value: '0',
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSectionTitle(String title, double screenWidth) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(
            fontSize: screenWidth * 0.045,
            fontWeight: FontWeight.w600,
            color: Colors.white),
      ),
    );
  }

  Widget _buildRegisterButton(BuildContext context, Color accentGreen) {
    final screenWidth = ResponsiveHelper.getScreenWidth(context);

    return ElevatedButton.icon(
      icon: Icon(Icons.person_add_alt_1_outlined, size: screenWidth * 0.055),
      label: Text('Register New Visitor',
          style: TextStyle(fontSize: screenWidth * 0.04)),
      onPressed: () {
        Navigator.pushNamed(context, '/visitor-photo');
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: accentGreen,
        minimumSize: Size(double.infinity, screenWidth * 0.13),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle:
            const TextStyle(fontWeight: FontWeight.w600, fontFamily: 'Inter'),
      ),
    );
  }

  Widget _buildRecentRequestItem(
      BuildContext context, Color cardColor, Color accentGreen) {
    final screenWidth = ResponsiveHelper.getScreenWidth(context);
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04, vertical: screenWidth * 0.035),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('user',
                  style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      fontWeight: FontWeight.w600,
                      color: Colors.white)),
              SizedBox(height: screenWidth * 0.01),
              Text('To: Prof. Brown',
                  style: TextStyle(
                      fontSize: screenWidth * 0.035, color: Colors.white70)),
            ],
          ),
          Chip(
            label: Text('approved',
                style: TextStyle(
                    fontSize: screenWidth * 0.03,
                    color: accentGreen,
                    fontWeight: FontWeight.w600)),
            backgroundColor: accentGreen.withOpacity(0.15),
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.02, vertical: 0),
            side: BorderSide.none,
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.color,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
  });

  final Color color;
  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final screenWidth = ResponsiveHelper.getScreenWidth(context);
    return Container(
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(screenWidth * 0.02),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: iconColor.withOpacity(0.15),
            ),
            child: Icon(icon, color: iconColor, size: screenWidth * 0.06),
          ),
          SizedBox(height: screenWidth * 0.04),
          Text(
            title,
            style:
                TextStyle(fontSize: screenWidth * 0.035, color: Colors.white70),
          ),
          SizedBox(height: screenWidth * 0.005),
          Text(
            value,
            style: TextStyle(
                fontSize: screenWidth * 0.08,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
        ],
      ),
    );
  }
}
