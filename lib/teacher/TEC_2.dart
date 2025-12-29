import 'package:flutter/material.dart';

// Data Model for a single visitor request
class VisitorRequest {
  const VisitorRequest({
    required this.name,
    required this.reason,
    required this.room,
    required this.id,
    required this.time,
  });

  final String name;
  final String reason;
  final String room;
  final String id;
  final String time;
}

class VisitorRequestsScreen extends StatefulWidget {
  const VisitorRequestsScreen({super.key});

  @override
  State<VisitorRequestsScreen> createState() => _VisitorRequestsScreenState();
}

class _VisitorRequestsScreenState extends State<VisitorRequestsScreen> {
  bool _isLoading = true;
  bool _hasError = false;
  List<VisitorRequest> _requests = [];

  @override
  void initState() {
    super.initState();
    _fetchVisitorRequests();
  }

  Future<void> _fetchVisitorRequests() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      // TODO: API call - Fetch visitor requests from backend
      // final response = await VisitorRequestsAPI.fetchAll();
      // final List<VisitorRequest> requests = response.map((data) => VisitorRequest(
      //   name: data['name'],
      //   reason: data['reason'],
      //   room: data['room'],
      //   id: data['id'],
      //   time: data['time'],
      // )).toList();

      // For now, set empty list as we're backend-ready
      _requests = [];

      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  Future<void> _acceptRequest(String requestId) async {
    try {
      // TODO: API call - Accept visitor request
      // await VisitorRequestsAPI.accept(requestId);

      // Remove request from local list after successful API call
      setState(() {
        _requests.removeWhere((request) => request.id == requestId);
      });
    } catch (error) {
      // TODO: Handle API error (show snackbar or dialog)
    }
  }

  Future<void> _rejectRequest(String requestId) async {
    try {
      // TODO: API call - Reject visitor request
      // await VisitorRequestsAPI.reject(requestId);

      // Remove request from local list after successful API call
      setState(() {
        _requests.removeWhere((request) => request.id == requestId);
      });
    } catch (error) {
      // TODO: Handle API error (show snackbar or dialog)
    }
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.white70, size: 48),
            const SizedBox(height: 16),
            const Text(
              'Failed to load visitor requests',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchVisitorRequests,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_requests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.people_outline, color: Colors.white70, size: 48),
            const SizedBox(height: 16),
            const Text(
              'No pending visitor requests',
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
      );
    }

    final screenWidth = MediaQuery.of(context).size.width;

    return ListView.separated(
      itemCount: _requests.length,
      padding: EdgeInsets.fromLTRB(
          screenWidth * 0.04, 0, screenWidth * 0.04, screenWidth * 0.04),
      separatorBuilder: (context, index) =>
          SizedBox(height: screenWidth * 0.04),
      itemBuilder: (context, index) {
        return _RequestCard(
          request: _requests[index],
          onAccept: () => _acceptRequest(_requests[index].id),
          onReject: () => _rejectRequest(_requests[index].id),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const secondaryTextColor = Color(0xFF9E9E9E);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1F2A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Visitor Requests',
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
              'Manage pending visitor requests',
              style: TextStyle(
                  color: secondaryTextColor, fontSize: screenWidth * 0.035),
            ),
          ),
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  const _RequestCard({
    required this.request,
    required this.onAccept,
    required this.onReject,
  });

  final VisitorRequest request;
  final VoidCallback onAccept;
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
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                  radius: screenWidth * 0.06,
                  backgroundColor: const Color(0xFFE0E0E0)),
              SizedBox(width: screenWidth * 0.03),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request.name,
                      style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    SizedBox(height: screenWidth * 0.01),
                    Text(
                      request.reason,
                      style: TextStyle(
                          fontSize: screenWidth * 0.035,
                          color: secondaryTextColor),
                    ),
                  ],
                ),
              ),
              SizedBox(width: screenWidth * 0.02),
              _buildDetailItem(Icons.access_time, request.time,
                  secondaryTextColor, screenWidth * 0.035),
            ],
          ),
          SizedBox(height: screenWidth * 0.04),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildDetailItem(Icons.location_on_outlined, request.room,
                  secondaryTextColor, screenWidth * 0.03),
              SizedBox(width: screenWidth * 0.1),
              _buildDetailItem(Icons.person_outline, request.id,
                  secondaryTextColor, screenWidth * 0.03),
            ],
          ),
          SizedBox(height: screenWidth * 0.04),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: Icon(Icons.check_circle, size: screenWidth * 0.045),
                  label: Text('Accept',
                      style: TextStyle(fontSize: screenWidth * 0.035)),
                  onPressed: onAccept,
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

  Widget _buildDetailItem(
      IconData icon, String text, Color color, double size) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: size + (size * 0.2)),
        SizedBox(width: size * 0.2),
        Text(
          text,
          style: TextStyle(
              color: color, fontSize: size, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
