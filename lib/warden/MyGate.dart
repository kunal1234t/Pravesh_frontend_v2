import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class HostelVisitor {
  const HostelVisitor({
    required this.id,
    required this.name,
    required this.visitType,
    required this.location,
    required this.time,
    required this.tag,
  });

  final String id;
  final String name;
  final String visitType;
  final String location;
  final String time;
  final String tag;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Gate - Visitors',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF1A1F2A),
        fontFamily: 'Inter',
      ),
      home: const MyGateVisitorsScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyGateVisitorsScreen extends StatefulWidget {
  const MyGateVisitorsScreen({super.key});

  @override
  State<MyGateVisitorsScreen> createState() => _MyGateVisitorsScreenState();
}

class _MyGateVisitorsScreenState extends State<MyGateVisitorsScreen> {
  bool _isLoading = true;
  bool _hasError = false;
  List<HostelVisitor> visitors = [];

  @override
  void initState() {
    super.initState();
    _fetchGateVisitors();
  }

  Future<void> _fetchGateVisitors() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      // TODO: Replace with actual Strapi API call
      // Example:
      // final response = await http.get(
      //   Uri.parse('${strapiBaseUrl}/api/gate-visitors?filters[status][$eq]=pending&populate=*'),
      //   headers: {'Authorization': 'Bearer $token'},
      // );
      //
      // if (response.statusCode == 200) {
      //   final jsonData = json.decode(response.body);
      //   final List<dynamic> data = jsonData['data'];
      //
      //   final fetchedVisitors = data.map((item) {
      //     final attributes = item['attributes'];
      //     return HostelVisitor(
      //       id: item['id'].toString(),
      //       name: attributes['name'] ?? '',
      //       visitType: attributes['visitType'] ?? '',
      //       location: attributes['location'] ?? '',
      //       time: attributes['time'] ?? '',
      //       tag: attributes['tag'] ?? '',
      //     );
      //   }).toList();
      //
      //   setState(() {
      //     visitors = fetchedVisitors;
      //     _isLoading = false;
      //   });
      // } else {
      //   throw Exception('Failed to load visitors');
      // }

      // Simulated delay for demonstration
      await Future.delayed(const Duration(seconds: 1));

      setState(() {
        visitors = [];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  Future<void> _approveVisitor(String visitorId) async {
    try {
      // TODO: Replace with actual Strapi API call to approve visitor
      // Example:
      // final response = await http.put(
      //   Uri.parse('${strapiBaseUrl}/api/gate-visitors/$visitorId'),
      //   headers: {
      //     'Authorization': 'Bearer $token',
      //     'Content-Type': 'application/json',
      //   },
      //   body: json.encode({
      //     'data': {
      //       'status': 'approved',
      //       'approvedAt': DateTime.now().toIso8601String(),
      //     }
      //   }),
      // );
      //
      // if (response.statusCode == 200) {
      //   // Success
      // } else {
      //   throw Exception('Failed to approve visitor');
      // }

      // Remove visitor from local list after approval
      setState(() {
        visitors.removeWhere((visitor) => visitor.id == visitorId);
      });

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Visitor approved successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to approve visitor')),
        );
      }
    }
  }

  Future<void> _rejectVisitor(String visitorId) async {
    try {
      // TODO: Replace with actual Strapi API call to reject visitor
      // Example:
      // final response = await http.put(
      //   Uri.parse('${strapiBaseUrl}/api/gate-visitors/$visitorId'),
      //   headers: {
      //     'Authorization': 'Bearer $token',
      //     'Content-Type': 'application/json',
      //   },
      //   body: json.encode({
      //     'data': {
      //       'status': 'rejected',
      //       'rejectedAt': DateTime.now().toIso8601String(),
      //     }
      //   }),
      // );
      //
      // if (response.statusCode == 200) {
      //   // Success
      // } else {
      //   throw Exception('Failed to reject visitor');
      // }

      // Remove visitor from local list after rejection
      setState(() {
        visitors.removeWhere((visitor) => visitor.id == visitorId);
      });

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Visitor rejected successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to reject visitor')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'My Gate - Visitors',
          style: TextStyle(
              fontSize: screenWidth * 0.05, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
                screenWidth * 0.05, 0, screenWidth * 0.05, screenWidth * 0.05),
            child: Text(
              'Manage hostel visitor requests',
              style: TextStyle(
                  color: const Color(0xFF9E9E9E),
                  fontSize: screenWidth * 0.035),
            ),
          ),
          Expanded(
            child: _buildBody(screenWidth),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(double screenWidth) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      );
    }

    if (_hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Color(0xFF9E9E9E),
              size: 48,
            ),
            SizedBox(height: screenWidth * 0.04),
            Text(
              'Failed to load visitors',
              style: TextStyle(
                color: const Color(0xFF9E9E9E),
                fontSize: screenWidth * 0.04,
              ),
            ),
            SizedBox(height: screenWidth * 0.04),
            ElevatedButton(
              onPressed: _fetchGateVisitors,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF34D17B),
                foregroundColor: Colors.white,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (visitors.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              color: const Color(0xFF9E9E9E),
              size: screenWidth * 0.15,
            ),
            SizedBox(height: screenWidth * 0.04),
            Text(
              'No pending visitors',
              style: TextStyle(
                color: const Color(0xFF9E9E9E),
                fontSize: screenWidth * 0.04,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      itemCount: visitors.length,
      padding: EdgeInsets.fromLTRB(
          screenWidth * 0.04, 0, screenWidth * 0.04, screenWidth * 0.04),
      separatorBuilder: (context, index) =>
          SizedBox(height: screenWidth * 0.04),
      itemBuilder: (context, index) {
        return _VisitorCard(
          visitor: visitors[index],
          onApprove: () => _approveVisitor(visitors[index].id),
          onReject: () => _rejectVisitor(visitors[index].id),
        );
      },
    );
  }
}

class _VisitorCard extends StatelessWidget {
  const _VisitorCard({
    required this.visitor,
    required this.onApprove,
    required this.onReject,
  });

  final HostelVisitor visitor;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  @override
  Widget build(BuildContext context) {
    const cardColor = Color(0xFF273348);
    const acceptColor = Color(0xFF34D17B);
    const rejectColor = Color(0xFFF44336);
    const secondaryTextColor = Color(0xFF9E9E9E);
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Section
          Row(
            children: [
              CircleAvatar(
                  radius: screenWidth * 0.06,
                  backgroundColor: const Color(0xFFE0E0E0)),
              SizedBox(width: screenWidth * 0.03),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          visitor.name,
                          style: TextStyle(
                            fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const Spacer(),
                        _buildTag(screenWidth, visitor.tag),
                      ],
                    ),
                    SizedBox(height: screenWidth * 0.01),
                    Text(
                      visitor.visitType,
                      style: TextStyle(
                        fontSize: screenWidth * 0.035,
                        color: secondaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: screenWidth * 0.03),
          // Middle Section
          Row(
            children: [
              _buildDetailItem(screenWidth, Icons.location_on_outlined,
                  visitor.location, secondaryTextColor),
              SizedBox(width: screenWidth * 0.06),
              _buildDetailItem(screenWidth, Icons.access_time, visitor.time,
                  secondaryTextColor),
            ],
          ),
          SizedBox(height: screenWidth * 0.04),
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: Icon(Icons.check_circle, size: screenWidth * 0.045),
                  label: Text('Accept',
                      style: TextStyle(fontSize: screenWidth * 0.035)),
                  onPressed: onApprove,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: acceptColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.symmetric(vertical: screenWidth * 0.03),
                    textStyle: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              SizedBox(width: screenWidth * 0.03),
              Expanded(
                child: OutlinedButton.icon(
                  icon: Icon(Icons.cancel, size: screenWidth * 0.045),
                  label: Text('Reject',
                      style: TextStyle(fontSize: screenWidth * 0.035)),
                  onPressed: onReject,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: rejectColor,
                    side: const BorderSide(color: rejectColor, width: 1.5),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.symmetric(vertical: screenWidth * 0.03),
                    textStyle: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTag(double screenWidth, String tag) {
    final Map<String, Color> tagColors = {
      'parent': const Color(0xFF2196F3),
      'official': const Color(0xFF9C27B0),
    };

    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.025, vertical: screenWidth * 0.01),
      decoration: BoxDecoration(
        color: tagColors[tag] ?? Colors.grey,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        tag,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: screenWidth * 0.027,
        ),
      ),
    );
  }

  Widget _buildDetailItem(
      double screenWidth, IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: screenWidth * 0.04),
        SizedBox(width: screenWidth * 0.015),
        Text(
          text,
          style: TextStyle(
              color: color,
              fontSize: screenWidth * 0.035,
              fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
