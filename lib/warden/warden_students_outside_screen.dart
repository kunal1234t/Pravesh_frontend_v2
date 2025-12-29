import 'package:flutter/material.dart';
import 'package:pravesh_screen/widgets/color.dart';
import 'package:pravesh_screen/app_colors_provider.dart';

class StudentsOutsideScreen extends StatefulWidget {
  const StudentsOutsideScreen({super.key});

  @override
  State<StudentsOutsideScreen> createState() => _StudentsOutsideScreenState();
}

class _StudentsOutsideScreenState extends State<StudentsOutsideScreen> {
  bool _isLoading = true;
  bool _hasError = false;
  List<Map<String, String>> students = [];

  @override
  void initState() {
    super.initState();
    _fetchStudentsOutside();
  }

  Future<void> _fetchStudentsOutside() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      // TODO: Replace with actual Strapi API call
      // Example:
      // final response = await http.get(
      //   Uri.parse('${strapiBaseUrl}/api/student-entries?filters[status][$eq]=outside&filters[hostel][$eq]=${wardenHostelId}&populate=student'),
      //   headers: {'Authorization': 'Bearer $token'},
      // );
      //
      // if (response.statusCode == 200) {
      //   final jsonData = json.decode(response.body);
      //   final List<dynamic> data = jsonData['data'];
      //
      //   final fetchedStudents = data.map((item) {
      //     final attributes = item['attributes'];
      //     final studentData = attributes['student']['data']['attributes'];
      //
      //     return {
      //       'name': studentData['name'] ?? '',
      //       'room': studentData['room'] ?? '',
      //       'leftAt': attributes['leftAt'] ?? '',
      //       'lastSeen': attributes['lastSeenLocation'] ?? '',
      //       'id': studentData['studentId'] ?? '',
      //       'phone': studentData['phone'] ?? '',
      //     };
      //   }).toList();
      //
      //   setState(() {
      //     students = fetchedStudents.cast<Map<String, String>>();
      //     _isLoading = false;
      //   });
      // } else {
      //   throw Exception('Failed to load students outside');
      // }

      // Simulated delay for demonstration
      await Future.delayed(const Duration(seconds: 1));

      setState(() {
        students = [];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
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
          'Students Outside Campus',
          style: TextStyle(
            color: colors.white,
            fontWeight: FontWeight.bold,
            fontSize: screenWidth * 0.05,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _isLoading
                  ? 'Loading...'
                  : 'Currently ${students.length} students are outside',
              style: TextStyle(
                  color: colors.hintText, fontSize: screenWidth * 0.035),
            ),
            SizedBox(height: screenWidth * 0.03),
            Expanded(
              child: _buildBody(context, colors, screenWidth),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(
      BuildContext context, AppColors colors, double screenWidth) {
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
            Icon(
              Icons.error_outline,
              color: colors.hintText,
              size: screenWidth * 0.12,
            ),
            SizedBox(height: screenWidth * 0.04),
            Text(
              'Failed to load students',
              style: TextStyle(
                color: colors.hintText,
                fontSize: screenWidth * 0.04,
              ),
            ),
            SizedBox(height: screenWidth * 0.04),
            ElevatedButton(
              onPressed: _fetchStudentsOutside,
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (students.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              color: colors.green,
              size: screenWidth * 0.15,
            ),
            SizedBox(height: screenWidth * 0.04),
            Text(
              'No students are currently outside',
              style: TextStyle(
                color: colors.hintText,
                fontSize: screenWidth * 0.04,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: students.length,
      itemBuilder: (context, index) {
        final student = students[index];
        return _buildStudentCard(context, student, colors);
      },
    );
  }

  Widget _buildStudentCard(
      BuildContext context, Map<String, String> student, AppColors colors) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.only(bottom: screenWidth * 0.03),
      padding: EdgeInsets.all(screenWidth * 0.03),
      decoration: BoxDecoration(
        color: colors.box,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.grey),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: screenWidth * 0.06,
            backgroundColor: Colors.grey,
            child: Icon(Icons.person,
                color: Colors.white, size: screenWidth * 0.06),
          ),
          SizedBox(width: screenWidth * 0.03),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      student["name"] ?? '',
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.bold,
                        color: colors.white,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.02,
                          vertical: screenWidth * 0.01),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: colors.green,
                      ),
                      child: Text(
                        'Outside',
                        style: TextStyle(
                            color: Colors.white, fontSize: screenWidth * 0.03),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenWidth * 0.015),
                _buildInfoRow(screenWidth, Icons.meeting_room,
                    student["room"] ?? '', colors),
                SizedBox(height: screenWidth * 0.01),
                _buildInfoRow(screenWidth, Icons.access_time,
                    'Left at: ${student["leftAt"]}', colors),
                SizedBox(height: screenWidth * 0.01),
                _buildInfoRow(screenWidth, Icons.location_on,
                    'Last seen: ${student["lastSeen"]}', colors),
                SizedBox(height: screenWidth * 0.01),
                Row(
                  children: [
                    Text('ID: ${student["id"]}',
                        style: TextStyle(
                            color: colors.hintText,
                            fontSize: screenWidth * 0.035)),
                    const Spacer(),
                    Text(student["phone"] ?? '',
                        style: TextStyle(
                            color: colors.hintText,
                            fontSize: screenWidth * 0.035)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
      double screenWidth, IconData icon, String text, AppColors colors) {
    return Row(
      children: [
        Icon(icon, size: screenWidth * 0.035, color: colors.hintText),
        SizedBox(width: screenWidth * 0.01),
        Text(text,
            style: TextStyle(
                color: colors.hintText, fontSize: screenWidth * 0.035)),
      ],
    );
  }
}
