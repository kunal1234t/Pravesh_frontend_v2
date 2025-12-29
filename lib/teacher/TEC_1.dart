import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pravesh_screen/teacher/TEC_2.dart';

class TeacherDashboardScreen extends StatefulWidget {
  const TeacherDashboardScreen({super.key});

  @override
  State<TeacherDashboardScreen> createState() => _TeacherDashboardScreenState();
}

class _TeacherDashboardScreenState extends State<TeacherDashboardScreen> {
  bool _isLoading = true;

  // Dynamic data variables
  String teacherName = '';
  String currentLocation = '';
  int todaysClassesCount = 0;
  int pendingVisitorsCount = 0;

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning!';
    if (hour < 17) return 'Good Afternoon!';
    return 'Good Evening!';
  }

  String get _currentTime {
    return DateFormat('hh:mm a').format(DateTime.now());
  }

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: API call - Fetch teacher profile
      // final teacherProfile = await TeacherProfileAPI.fetch();
      // teacherName = teacherProfile.name;
      // currentLocation = teacherProfile.location;

      // TODO: API call - Fetch dashboard stats
      // final dashboardStats = await DashboardStatsAPI.fetch();
      // todaysClassesCount = dashboardStats.todaysClassesCount;

      // TODO: API call - Fetch pending visitor count
      // final pendingVisitors = await PendingVisitorsAPI.fetch();
      // pendingVisitorsCount = pendingVisitors.count;

      // Set empty defaults for backend readiness
      teacherName = '';
      currentLocation = '';
      todaysClassesCount = 0;
      pendingVisitorsCount = 0;

      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      // TODO: Show error banner / retry CTA when backend is connected
      setState(() {
        _isLoading = false;
        teacherName = 'Teacher';
        currentLocation = 'Location';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const cardColor = Color(0xFF273348);
    const accentGreen = Color(0xFF34D17B);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(screenWidth * 0.05),
          child: Column(
            children: [
              _buildHeader(screenWidth),
              SizedBox(height: screenWidth * 0.06),
              _buildStatsRow(context, cardColor),
              SizedBox(height: screenWidth * 0.08),
              _buildMyGateSection(context, accentGreen),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(double screenWidth) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello ${_isLoading ? 'Teacher' : (teacherName.isEmpty ? 'Teacher' : teacherName)}',
                style: TextStyle(
                    fontSize: screenWidth * 0.04, color: Colors.white70),
              ),
              Text(
                _greeting,
                style: TextStyle(
                  fontSize: screenWidth * 0.055,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              _currentTime,
              style: TextStyle(
                fontSize: screenWidth * 0.055,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: screenWidth * 0.005),
            Text(
              _isLoading
                  ? 'Loading...'
                  : (currentLocation.isEmpty ? 'Location' : currentLocation),
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
                label: "Today's Classes",
                value: _isLoading ? '-' : todaysClassesCount.toString(),
                iconColor: Colors.blue.shade300,
              ),
            ),
            SizedBox(width: constraints.maxWidth * 0.04),
            Expanded(
              child: _StatCard(
                color: cardColor,
                icon: Icons.shield_outlined,
                label: 'Pending Visitors',
                value: _isLoading ? '-' : pendingVisitorsCount.toString(),
                iconColor: Colors.orange.shade300,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMyGateSection(BuildContext context, Color accentGreen) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'My Gate',
              style: TextStyle(
                fontSize: screenWidth * 0.045,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            Chip(
              label: Text(
                _isLoading ? 'Pending' : '$pendingVisitorsCount Pending',
                style: TextStyle(fontSize: screenWidth * 0.03),
              ),
              labelStyle: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
              backgroundColor: accentGreen,
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
              labelPadding:
                  EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            )
          ],
        ),
        SizedBox(height: screenWidth * 0.04),
        ElevatedButton.icon(
          icon: Icon(Icons.shield_outlined, size: screenWidth * 0.055),
          label: Text('Manage Visitors',
              style: TextStyle(fontSize: screenWidth * 0.04)),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const VisitorRequestsScreen()),
            );
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: accentGreen,
            minimumSize: Size(double.infinity, screenWidth * 0.13),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            textStyle: const TextStyle(
                fontWeight: FontWeight.w600, fontFamily: 'Inter'),
          ),
        )
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.color,
    required this.icon,
    required this.label,
    required this.value,
    required this.iconColor,
  });

  final Color color;
  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: screenWidth * 0.07),
          SizedBox(height: screenWidth * 0.03),
          Text(
            label,
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
