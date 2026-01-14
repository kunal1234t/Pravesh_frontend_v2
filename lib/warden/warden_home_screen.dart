import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pravesh_screen/app_colors_provider.dart';
import 'package:pravesh_screen/warden/warden_students_outside_screen.dart';
import 'package:pravesh_screen/warden/LateEntryRequestsScreen.dart';
import 'package:pravesh_screen/warden/MyGate.dart';

class WardenHomeScreen extends StatefulWidget {
  const WardenHomeScreen({super.key});

  @override
  State<WardenHomeScreen> createState() => _WardenHomeScreenState();
}

class _WardenHomeScreenState extends State<WardenHomeScreen> {
  bool _isLoading = true;
  bool _hasError = false;
  String wardenName = '';
  String location = '';
  int studentsOutsideCount = 0;
  int lateRequestsCount = 0;
  int gatePendingCount = 0;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      // TODO: Replace with actual Strapi API calls
      // Example: Fetch warden profile
      // final profileResponse = await http.get(
      //   Uri.parse('${strapiBaseUrl}/api/users/me?populate=*'),
      //   headers: {'Authorization': 'Bearer $token'},
      // );
      //
      // if (profileResponse.statusCode == 200) {
      //   final profileData = json.decode(profileResponse.body);
      //   wardenName = profileData['name'] ?? '';
      //   location = profileData['location'] ?? '';
      // }

      // TODO: Fetch students outside count
      // final studentsOutsideResponse = await http.get(
      //   Uri.parse('${strapiBaseUrl}/api/student-entries?filters[status][$eq]=outside&filters[hostel][$eq]=${wardenHostelId}'),
      //   headers: {'Authorization': 'Bearer $token'},
      // );
      //
      // if (studentsOutsideResponse.statusCode == 200) {
      //   final studentsData = json.decode(studentsOutsideResponse.body);
      //   studentsOutsideCount = studentsData['meta']['pagination']['total'] ?? 0;
      // }

      // TODO: Fetch late entry requests count
      // final lateRequestsResponse = await http.get(
      //   Uri.parse('${strapiBaseUrl}/api/late-entry-requests?filters[status][$eq]=pending&filters[hostel][$eq]=${wardenHostelId}'),
      //   headers: {'Authorization': 'Bearer $token'},
      // );
      //
      // if (lateRequestsResponse.statusCode == 200) {
      //   final lateRequestsData = json.decode(lateRequestsResponse.body);
      //   lateRequestsCount = lateRequestsData['meta']['pagination']['total'] ?? 0;
      // }

      // TODO: Fetch gate pending visitors count
      // final gatePendingResponse = await http.get(
      //   Uri.parse('${strapiBaseUrl}/api/gate-visitors?filters[status][$eq]=pending&filters[hostel][$eq]=${wardenHostelId}'),
      //   headers: {'Authorization': 'Bearer $token'},
      // );
      //
      // if (gatePendingResponse.statusCode == 200) {
      //   final gateData = json.decode(gatePendingResponse.body);
      //   gatePendingCount = gateData['meta']['pagination']['total'] ?? 0;
      // }

      // Simulated delay for demonstration
      await Future.delayed(const Duration(seconds: 1));

      setState(() {
        wardenName = 'Mr. Harsh Goud';
        location = 'Nagpur, Maharashtra';
        studentsOutsideCount = 3;
        lateRequestsCount = 2;
        gatePendingCount = 2;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  // Dynamic greeting based on time
  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning!';
    if (hour < 17) return 'Good Afternoon!';
    return 'Good Evening!';
  }

  // Current time formatted
  String get _currentTime {
    return DateFormat('hh:mm a').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    final colors = appColors(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05,
            vertical: screenHeight * 0.035,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header (same style as Teacher)
              Row(
                children: [
                  // Greeting
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isLoading ? "Hello..." : "Hello $wardenName",
                        style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          color: colors.white.withOpacity(0.7),
                        ),
                      ),
                      Text(
                        _greeting,
                        style: TextStyle(
                          fontSize: screenWidth * 0.055,
                          fontWeight: FontWeight.bold,
                          color: colors.white,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Time + Location
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        _currentTime,
                        style: TextStyle(
                          fontSize: screenWidth * 0.055,
                          fontWeight: FontWeight.bold,
                          color: colors.white,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.005),
                      Text(
                        _isLoading ? "..." : location,
                        style: TextStyle(
                          fontSize: screenWidth * 0.03,
                          color: colors.white.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: screenHeight * 0.03),

              // Counters
              Row(
                children: [
                  _infoCard(
                    context,
                    "Students Outside",
                    _isLoading ? "-" : "$studentsOutsideCount",
                    Icons.groups,
                  ),
                  SizedBox(width: screenWidth * 0.04),
                  _infoCard(
                    context,
                    "Late Requests",
                    _isLoading ? "-" : "$lateRequestsCount",
                    Icons.warning_amber,
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.025),

              // Urgent Alert (only show when lateRequestsCount > 0)
              if (!_isLoading && lateRequestsCount > 0)
                Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(screenWidth * 0.045),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.red),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.error_outline,
                                  color: Colors.red, size: screenWidth * 0.06),
                              SizedBox(width: screenWidth * 0.02),
                              Text(
                                "Urgent: Late Entry Requests",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: screenWidth * 0.045,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          Text(
                            "$lateRequestsCount student(s) requesting late entry permission",
                            style: TextStyle(
                                color: colors.white,
                                fontSize: screenWidth * 0.035),
                          ),
                          SizedBox(height: screenHeight * 0.015),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              minimumSize:
                                  Size(double.infinity, screenHeight * 0.06),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, '/late-entry-requests');
                            },
                            child: Text("Review Requests",
                                style: TextStyle(fontSize: screenWidth * 0.04)),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.025),
                  ],
                ),

              // Buttons
              _wideButton(
                context,
                label: _isLoading
                    ? "Students Outside (-)"
                    : "Students Outside ($studentsOutsideCount)",
                icon: Icons.groups,
                color: Colors.blue,
                onTap: () {
                  Navigator.pushNamed(context, '/students-outside');
                },
              ),
              SizedBox(height: screenHeight * 0.015),
              _wideButton(
                context,
                label: _isLoading
                    ? "My Gate (- Pending)"
                    : "My Gate ($gatePendingCount Pending)",
                icon: Icons.shield,
                color: colors.green,
                onTap: () {
                  Navigator.pushNamed(context, '/my-gate');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoCard(
      BuildContext context, String label, String count, IconData icon) {
    final colors = appColors(context);
    final screenWidth = MediaQuery.of(context).size.width;
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(screenWidth * 0.04),
        decoration: BoxDecoration(
          color: colors.box,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: colors.white, size: screenWidth * 0.06),
            SizedBox(height: screenWidth * 0.015),
            Text(
              count,
              style: TextStyle(
                color: colors.green,
                fontSize: screenWidth * 0.05,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colors.white.withOpacity(0.8),
                fontSize: screenWidth * 0.03,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _wideButton(BuildContext context,
      {required String label,
      required IconData icon,
      required Color color,
      required VoidCallback onTap}) {
    final screenWidth = MediaQuery.of(context).size.width;
    return ElevatedButton.icon(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        minimumSize: Size(double.infinity, screenWidth * 0.14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      icon: Icon(icon, color: Colors.white, size: screenWidth * 0.06),
      label: Text(
        label,
        style: TextStyle(fontSize: screenWidth * 0.04),
      ),
    );
  }
}
