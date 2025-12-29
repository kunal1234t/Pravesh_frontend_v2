import 'package:flutter/material.dart';
import 'package:pravesh_screen/widgets/color.dart';
import 'package:pravesh_screen/app_colors_provider.dart';

class LateEntryRequestsScreen extends StatefulWidget {
  const LateEntryRequestsScreen({super.key});

  @override
  State<LateEntryRequestsScreen> createState() =>
      _LateEntryRequestsScreenState();
}

class _LateEntryRequestsScreenState extends State<LateEntryRequestsScreen> {
  bool _isLoading = true;
  bool _hasError = false;
  List<Map<String, String>> lateEntries = [];

  @override
  void initState() {
    super.initState();
    _fetchLateEntryRequests();
  }

  Future<void> _fetchLateEntryRequests() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      // TODO: Strapi API call - Fetch pending late-entry requests
      // final response = await StrapiAPI.get('/late-entry-requests', params: {
      //   'filters[status][$eq]': 'pending',
      //   'sort': 'createdAt:desc'
      // });
      // final List<Map<String, String>> entries = response.data.map((item) => {
      //   'id': item['id'].toString(),
      //   'name': item['attributes']['student_name'],
      //   'room': item['attributes']['room_number'],
      //   'requestedAt': item['attributes']['requested_time'],
      //   'expectedReturn': item['attributes']['expected_return'],
      //   'reason': item['attributes']['reason'],
      //   'phone': item['attributes']['phone_number'],
      // }).toList();

      // For now, set empty list as we're backend-ready
      lateEntries = [];

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

  Future<void> _handleApprove(String requestId) async {
    try {
      // TODO: Strapi API call - Approve late entry request
      // await StrapiAPI.put('/late-entry-requests/$requestId', data: {
      //   'data': {'status': 'approved'}
      // });

      // Remove request from local list after successful API call
      setState(() {
        lateEntries.removeWhere((entry) => entry['id'] == requestId);
      });
    } catch (error) {
      // TODO: Handle API error (show snackbar or dialog)
    }
  }

  Future<void> _handleDeny(String requestId) async {
    try {
      // TODO: Strapi API call - Deny late entry request
      // await StrapiAPI.put('/late-entry-requests/$requestId', data: {
      //   'data': {'status': 'denied'}
      // });

      // Remove request from local list after successful API call
      setState(() {
        lateEntries.removeWhere((entry) => entry['id'] == requestId);
      });
    } catch (error) {
      // TODO: Handle API error (show snackbar or dialog)
    }
  }

  Widget _buildContent(BuildContext context, AppColors colors) {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(color: colors.white),
      );
    }

    if (_hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: colors.white, size: 48),
            SizedBox(height: 16),
            Text(
              'Failed to load late entry requests',
              style: TextStyle(color: colors.white),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchLateEntryRequests,
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.green,
              ),
              child: Text('Retry', style: TextStyle(color: colors.white)),
            ),
          ],
        ),
      );
    }

    if (lateEntries.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.nightlife_outlined, color: colors.white, size: 48),
            SizedBox(height: 16),
            Text(
              'No pending late entry requests',
              style: TextStyle(color: colors.white),
            ),
          ],
        ),
      );
    }

    final screenWidth = MediaQuery.of(context).size.width;

    return ListView.builder(
      itemCount: lateEntries.length,
      itemBuilder: (context, index) {
        final entry = lateEntries[index];
        return _buildRequestCard(context, entry, colors);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = appColors(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        leading: BackButton(color: colors.white),
        title: Text(
          'Late Entry Requests',
          style: TextStyle(
            color: colors.white,
            fontSize: screenWidth * 0.05,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Students requesting entry after 8:00 PM',
              style: TextStyle(
                color: colors.hintText,
                fontSize: screenWidth * 0.035,
              ),
            ),
            SizedBox(height: screenWidth * 0.03),
            Expanded(
              child: _buildContent(context, colors),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestCard(
      BuildContext context, Map<String, String> entry, AppColors colors) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.only(bottom: screenWidth * 0.04),
      padding: EdgeInsets.all(screenWidth * 0.035),
      decoration: BoxDecoration(
        color: colors.box,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(color: colors.red, width: screenWidth * 0.007),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: screenWidth * 0.055,
                backgroundColor: Colors.grey,
                child: Icon(Icons.person,
                    color: Colors.white, size: screenWidth * 0.06),
              ),
              SizedBox(width: screenWidth * 0.025),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry["name"] ?? '',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth * 0.04,
                        color: colors.white,
                      ),
                    ),
                    SizedBox(height: screenWidth * 0.01),
                    Row(
                      children: [
                        Icon(Icons.meeting_room,
                            size: screenWidth * 0.035, color: Colors.grey),
                        SizedBox(width: screenWidth * 0.01),
                        Text(entry["room"] ?? '',
                            style: TextStyle(
                                color: colors.hintText,
                                fontSize: screenWidth * 0.035)),
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                '⚠ URGENT',
                style: TextStyle(
                  color: colors.red,
                  fontSize: screenWidth * 0.03,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
          SizedBox(height: screenWidth * 0.03),
          Row(
            children: [
              Icon(Icons.schedule,
                  size: screenWidth * 0.035, color: Colors.grey),
              SizedBox(width: screenWidth * 0.01),
              Text('Requested at: ${entry["requestedAt"]}',
                  style: TextStyle(
                      color: colors.hintText, fontSize: screenWidth * 0.035)),
            ],
          ),
          SizedBox(height: screenWidth * 0.01),
          Row(
            children: [
              Icon(Icons.timer_outlined,
                  size: screenWidth * 0.035, color: Colors.grey),
              SizedBox(width: screenWidth * 0.01),
              Text('Expected return: ${entry["expectedReturn"]}',
                  style: TextStyle(
                      color: colors.hintText, fontSize: screenWidth * 0.035)),
            ],
          ),
          SizedBox(height: screenWidth * 0.025),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(screenWidth * 0.03),
            decoration: BoxDecoration(
              color: Colors.grey.shade800,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Reason for delay:\n${entry["reason"] ?? ''}',
              style:
                  TextStyle(color: Colors.white, fontSize: screenWidth * 0.035),
            ),
          ),
          SizedBox(height: screenWidth * 0.025),
          Row(
            children: [
              Text('ID: ${entry["id"]}',
                  style: TextStyle(
                      color: colors.hintText, fontSize: screenWidth * 0.035)),
              const Spacer(),
              Text(entry["phone"] ?? '',
                  style: TextStyle(
                      color: colors.hintText, fontSize: screenWidth * 0.035)),
            ],
          ),
          SizedBox(height: screenWidth * 0.03),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.green,
                    padding:
                        EdgeInsets.symmetric(vertical: screenWidth * 0.025),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () => _handleApprove(entry["id"] ?? ''),
                  icon: Icon(Icons.check, size: screenWidth * 0.04),
                  label: Text("Approve Entry",
                      style: TextStyle(fontSize: screenWidth * 0.03)),
                ),
              ),
              SizedBox(width: screenWidth * 0.025),
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colors.red,
                    side: BorderSide(color: colors.red, width: 1.5),
                    padding:
                        EdgeInsets.symmetric(vertical: screenWidth * 0.025),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () => _handleDeny(entry["id"] ?? ''),
                  icon: Icon(Icons.close, size: screenWidth * 0.04),
                  label: Text("Deny",
                      style: TextStyle(fontSize: screenWidth * 0.03)),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
