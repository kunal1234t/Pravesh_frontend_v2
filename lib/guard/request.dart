import 'package:flutter/material.dart';
import 'package:pravesh_screen/guard/new_visitor_managment.dart';
import 'package:pravesh_screen/services/guard_request_service.dart';
import 'package:pravesh_screen/widgets/protected_route.dart';

class RequestStatusScreen extends StatefulWidget {
  final String requestId;

  const RequestStatusScreen({Key? key, required this.requestId})
      : super(key: key);

  @override
  State<RequestStatusScreen> createState() => _RequestStatusScreenState();
}

class _RequestStatusScreenState extends State<RequestStatusScreen> {
  late String visitorName;
  late String meetingWith;
  late String reason;
  late String requestTime;
  late String status;
  bool _isLoading = true;
  String? _error;

  Future<void> _loadRequest() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final data =
          await GuardRequestService.fetchRequestStatus(widget.requestId);

      setState(() {
        visitorName = data['visitorName'];
        meetingWith = data['meetingWith'];
        reason = data['reason'];
        requestTime = data['requestTime'];
        status = data['status'];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Unable to fetch request status';
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadRequest();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Center(
          child: Text(_error!),
        ),
      );
    }

    const accentGreen = Color(0xFF34D17B);
    final pendingColor = Theme.of(context).colorScheme.primary;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleSpacing: screenWidth * 0.04,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Request Status',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontSize: screenWidth * 0.045),
            ),
            SizedBox(height: screenWidth * 0.01),
            Text(
              'Waiting for teacher response',
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(fontSize: screenWidth * 0.035),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Column(
          children: [
            _buildStatusCard(context, accentGreen, pendingColor),
            SizedBox(height: screenWidth * 0.075),
            _buildRegisterButton(context, accentGreen),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(
      BuildContext context, Color accentGreen, Color pendingColor) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF273348),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: EdgeInsets.all(screenWidth * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(screenWidth),
          SizedBox(height: screenWidth * 0.06),
          _buildDetailRow(screenWidth, 'MEETING WITH', meetingWith),
          SizedBox(height: screenWidth * 0.04),
          _buildDetailRow(screenWidth, 'REASON', reason),
          SizedBox(height: screenWidth * 0.04),
          _buildDetailRow(screenWidth, 'REQUEST TIME', requestTime),
          SizedBox(height: screenWidth * 0.06),
          if (status == 'APPROVED')
            _buildApprovalStatus(screenWidth, accentGreen)
          else if (status == 'PENDING')
            _buildPendingStatus(screenWidth, pendingColor)
          else if (status == 'REJECTED')
            _buildRejectedStatus(screenWidth)
        ],
      ),
    );
  }

  Widget _buildHeader(double screenWidth) {
    return Row(
      children: [
        Container(
          width: screenWidth * 0.125,
          height: screenWidth * 0.125,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Icons.person,
              color: Colors.white70, size: screenWidth * 0.07),
        ),
        SizedBox(width: screenWidth * 0.04),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              visitorName,
              style: TextStyle(
                fontSize: screenWidth * 0.042,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: screenWidth * 0.01),
            Text(
              'Visitor Request',
              style: TextStyle(
                fontSize: screenWidth * 0.032,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailRow(double screenWidth, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: screenWidth * 0.03,
            color: Colors.white54,
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: screenWidth * 0.01),
        Text(
          value,
          style: TextStyle(
            fontSize: screenWidth * 0.038,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildApprovalStatus(double screenWidth, Color accentGreen) {
    return Center(
      child: Column(
        children: [
          Icon(Icons.check_circle,
              color: accentGreen, size: screenWidth * 0.16),
          SizedBox(height: screenWidth * 0.04),
          Chip(
            avatar: Icon(Icons.check,
                color: Colors.white, size: screenWidth * 0.04),
            label:
                Text(status, style: TextStyle(fontSize: screenWidth * 0.035)),
            labelStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            backgroundColor: accentGreen.withOpacity(0.2),
            shape: const StadiumBorder(),
            side: BorderSide(color: accentGreen, width: 1),
          ),
          SizedBox(height: screenWidth * 0.02),
          Text(
            'Request approved! Visitor can proceed.',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: screenWidth * 0.035,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPendingStatus(double screenWidth, Color pendingColor) {
    return Center(
      child: Column(
        children: [
          SizedBox(
            width: screenWidth * 0.15,
            height: screenWidth * 0.15,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(pendingColor),
              strokeWidth: 5.0,
            ),
          ),
          SizedBox(height: screenWidth * 0.04),
          ActionChip(
            avatar: Icon(Icons.access_time_filled,
                color: pendingColor, size: screenWidth * 0.04),
            label: Text('PENDING',
                style: TextStyle(fontSize: screenWidth * 0.035)),
            labelStyle:
                TextStyle(color: pendingColor, fontWeight: FontWeight.bold),
            backgroundColor: pendingColor.withOpacity(0.15),
            shape: const StadiumBorder(),
            side: BorderSide(color: pendingColor.withOpacity(0.5)),
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
            onPressed: () {},
          ),
          SizedBox(height: screenWidth * 0.02),
          Text('Waiting for $meetingWith to respond...',
              style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: screenWidth * 0.035)),
        ],
      ),
    );
  }

  Widget _buildRejectedStatus(double screenWidth) {
    return Center(
      child: Column(
        children: [
          Icon(Icons.cancel, color: Colors.red, size: screenWidth * 0.16),
          SizedBox(height: screenWidth * 0.04),
          Chip(
            avatar: Icon(Icons.close,
                color: Colors.white, size: screenWidth * 0.04),
            label:
                Text(status, style: TextStyle(fontSize: screenWidth * 0.035)),
            labelStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            backgroundColor: Colors.red.withOpacity(0.2),
            shape: const StadiumBorder(),
            side: BorderSide(color: Colors.red, width: 1),
          ),
          SizedBox(height: screenWidth * 0.02),
          Text(
            'Request rejected by teacher.',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: screenWidth * 0.035,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterButton(BuildContext context, Color accentGreen) {
    final screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => ProtectedRoute(
                  allowedRoles: const ['Guard'],
                  child: const GuardDashboardScreen(),
                ),
              ));
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: accentGreen,
          padding: EdgeInsets.symmetric(vertical: screenWidth * 0.04),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(
          'Register New Visitor',
          style: TextStyle(
            fontSize: screenWidth * 0.04,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1A1F2A),
          ),
        ),
      ),
    );
  }
}
