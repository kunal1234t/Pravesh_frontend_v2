import 'package:flutter/material.dart';
import 'package:pravesh_screen/guard/request.dart';
import 'package:pravesh_screen/widgets/protected_route.dart';

class VisitorInformationScreen extends StatefulWidget {
  const VisitorInformationScreen({super.key});

  @override
  State<VisitorInformationScreen> createState() =>
      _VisitorInformationScreenState();
}

class _VisitorInformationScreenState extends State<VisitorInformationScreen> {
  final TextEditingController _visitorNameController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  String? _selectedTeacher;
  bool _isSubmitting = false;
  final List<String> _teachers = ['Prof. Johnson', 'Prof. Brown', 'Dr. Smith'];

  void _handleSendRequest() async {
    if (_visitorNameController.text.isEmpty ||
        _reasonController.text.isEmpty ||
        _selectedTeacher == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final requestData = {
      'visitorName': _visitorNameController.text,
      'meetingWith': _selectedTeacher!,
      'reason': _reasonController.text,
    };

    // TODO: send requestData to backend and receive requestId

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProtectedRoute(
          allowedRoles: const ['Guard'],
          child: const RequestStatusScreen(requestId: 'TEMP_REQUEST_ID'),
        ),
      ),
    );

    setState(() {
      _isSubmitting = false;
    });
  }

  @override
  void dispose() {
    _visitorNameController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const secondaryTextColor = Color(0xFF9E9E9E);
    const accentGreen = Color(0xFF34D17B);
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
          'Visitor Information',
          style: TextStyle(
              fontSize: screenWidth * 0.05, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05, vertical: screenWidth * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: screenWidth * 0.01, bottom: screenWidth * 0.06),
                  child: Text(
                    'Fill in visitor details and select teacher',
                    style: TextStyle(
                        color: secondaryTextColor,
                        fontSize: screenWidth * 0.035),
                  ),
                ),
                _buildPhotoCapturedCard(screenWidth),
                SizedBox(height: screenWidth * 0.06),
                _buildLabel(screenWidth, 'Visitor Name'),
                SizedBox(height: screenWidth * 0.03),
                TextFormField(
                  controller: _visitorNameController,
                  style: TextStyle(
                      color: Colors.white, fontSize: screenWidth * 0.04),
                  decoration: _buildInputDecoration(
                      screenWidth, "Enter visitor's full name"),
                ),
                SizedBox(height: screenWidth * 0.05),
                _buildLabel(screenWidth, 'Reason for Visit'),
                SizedBox(height: screenWidth * 0.03),
                TextFormField(
                  controller: _reasonController,
                  maxLines: 4,
                  style: TextStyle(
                      color: Colors.white, fontSize: screenWidth * 0.04),
                  decoration: _buildInputDecoration(
                      screenWidth, "Enter the purpose of visit"),
                ),
                SizedBox(height: screenWidth * 0.05),
                _buildLabel(screenWidth, 'Select Teacher to Meet'),
                SizedBox(height: screenWidth * 0.03),
                DropdownButtonFormField<String>(
                  value: _selectedTeacher,
                  items: _teachers.map((String teacher) {
                    return DropdownMenuItem<String>(
                      value: teacher,
                      child: Text(teacher,
                          style: TextStyle(fontSize: screenWidth * 0.04)),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedTeacher = newValue;
                    });
                  },
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.04,
                      fontFamily: 'Inter'),
                  icon: Icon(Icons.keyboard_arrow_down_rounded,
                      color: Colors.white70, size: screenWidth * 0.07),
                  decoration:
                      _buildInputDecoration(screenWidth, "Choose a teacher"),
                  dropdownColor: const Color(0xFF273348),
                ),
                SizedBox(height: screenWidth * 0.1),
                _buildSendRequestButton(screenWidth, accentGreen),
                SizedBox(height: screenWidth * 0.06),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLabel(double screenWidth, String label) {
    return RichText(
      text: TextSpan(
        text: label,
        style: TextStyle(
          color: Colors.white,
          fontSize: screenWidth * 0.035,
          fontWeight: FontWeight.w600,
          fontFamily: 'Inter',
        ),
        children: [
          TextSpan(
            text: ' *',
            style: TextStyle(
              color: const Color(0xFFF44336),
              fontSize: screenWidth * 0.035,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoCapturedCard(double screenWidth) {
    return Container(
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: const Color(0xFF273348),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: screenWidth * 0.135,
            height: screenWidth * 0.135,
            decoration: BoxDecoration(
              color: const Color(0xFFE0E0E0),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Container(
                width: screenWidth * 0.03,
                height: screenWidth * 0.03,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.3),
                ),
              ),
            ),
          ),
          SizedBox(width: screenWidth * 0.04),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Photo Captured',
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: screenWidth * 0.01),
              Text(
                'Visitor identification photo',
                style: TextStyle(
                  fontSize: screenWidth * 0.035,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSendRequestButton(double screenWidth, Color accentGreen) {
    return ElevatedButton.icon(
      icon: Icon(Icons.send_rounded, size: screenWidth * 0.05),
      label: Text('Send Request to Teacher',
          style: TextStyle(fontSize: screenWidth * 0.04)),
      onPressed: _isSubmitting ? null : _handleSendRequest,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: accentGreen,
        minimumSize: Size(double.infinity, screenWidth * 0.13),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontFamily: 'Inter',
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(double screenWidth, String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Colors.white54),
      filled: true,
      fillColor: const Color(0xFF273348),
      contentPadding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05, vertical: screenWidth * 0.04),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: Colors.white.withOpacity(0.15),
          width: 1,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: Colors.white.withOpacity(0.15),
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Color(0xFF34D17B),
          width: 1.5,
        ),
      ),
    );
  }
}
