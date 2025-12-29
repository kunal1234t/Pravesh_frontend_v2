import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pravesh_screen/student/QRGenerator.dart';
import 'package:pravesh_screen/app_colors_provider.dart';
import 'package:pravesh_screen/services/exit_service.dart';

class ExitFormHomePage extends StatefulWidget {
  const ExitFormHomePage({super.key});

  @override
  State<ExitFormHomePage> createState() => _ExitFormHomePageState();
}

class _ExitFormHomePageState extends State<ExitFormHomePage> {
  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();
  final double targetLatitude = 28.4476255;
  final double targetLongitude = 77.3027103;
  final double allowedRadius = 100000;

  String? _selectedReasonType;
  bool _showOtherReasonField = false;
  bool _isLoading = false;

  final List<String> _reasonOptions = ['Nagpur', 'Butibori', 'Walk', 'Others'];

  Future<bool> _isWithinRadius() async {
    // Bypass geofencing for web during development
    if (kIsWeb) {
      return true;
    }

    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        _showErrorDialog('Location services are disabled.');
        return false;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showErrorDialog('Location permission denied.');
          return false;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        _showErrorDialog(
            'Location permission is permanently denied. Please enable it in settings.');
        return false;
      }

      final position = await Geolocator.getCurrentPosition(
        timeLimit: const Duration(seconds: 10),
      );

      final distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        targetLatitude,
        targetLongitude,
      );

      return distance <= allowedRadius;
    } on TimeoutException {
      _showErrorDialog('Location request timed out. Please try again.');
      return false;
    } catch (e) {
      _showErrorDialog('Unable to determine your location. Please try again.');
      return false;
    }
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = appColors(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: colors.white,
            size: screenWidth * 0.075,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
        title: Text(
          "EXIT FORM",
          style: TextStyle(
            color: colors.white,
            fontSize: screenWidth * 0.055,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.04,
                    vertical: screenHeight * 0.02),
                decoration: BoxDecoration(
                  color: colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(screenWidth * 0.03),
                  border: Border.all(color: colors.green, width: 1),
                ),
                child: Center(
                  child: Text(
                    'Fill the details to Exit',
                    style: TextStyle(
                      color: colors.green,
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.06),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Reason Type',
                    style: TextStyle(
                      color: colors.white,
                      fontSize: screenWidth * 0.04,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.015),
                  Container(
                    decoration: BoxDecoration(
                      color: colors.box,
                      borderRadius: BorderRadius.circular(screenWidth * 0.03),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.03,
                    ),
                    child: DropdownButtonFormField<String>(
                      value: _selectedReasonType,
                      dropdownColor: colors.box,
                      icon: Icon(Icons.arrow_drop_down, color: colors.green),
                      iconSize: screenWidth * 0.06,
                      style: TextStyle(
                        color: colors.white,
                        fontSize: screenWidth * 0.04,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.list_alt_outlined,
                          color: colors.green,
                          size: screenWidth * 0.06,
                        ),
                      ),
                      hint: Text(
                        'Select Reason Type',
                        style: TextStyle(
                          color: colors.hintText,
                          fontSize: screenWidth * 0.04,
                        ),
                      ),
                      items: _reasonOptions.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedReasonType = newValue;
                          _showOtherReasonField = newValue == 'Others';
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.04),
              if (_showOtherReasonField)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Specify Reason',
                      style: TextStyle(
                        color: colors.white,
                        fontSize: screenWidth * 0.04,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.015),
                    TextFormField(
                      controller: _reasonController,
                      style: TextStyle(color: colors.white),
                      maxLines: 1,
                      decoration: InputDecoration(
                        hintText: 'Enter your reason...',
                        hintStyle: TextStyle(color: colors.hintText),
                        prefixIcon: Icon(
                          Icons.edit_outlined,
                          color: colors.green,
                          size: screenWidth * 0.06,
                        ),
                        filled: true,
                        fillColor: colors.box,
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(screenWidth * 0.03),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.all(screenWidth * 0.04),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.04),
                  ],
                ),
              SizedBox(height: screenHeight * 0.06),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.box,
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.06,
                        vertical: screenHeight * 0.02,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(screenWidth * 0.03),
                        side: BorderSide(color: colors.green),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.close,
                            size: screenWidth * 0.06, color: colors.green),
                        SizedBox(width: screenHeight * 0.01),
                        Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: screenWidth * 0.045,
                            color: colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _isLoading
                      ? CircularProgressIndicator(color: colors.green)
                      : ElevatedButton(
                          onPressed: _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colors.green,
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.06,
                              vertical: screenHeight * 0.02,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(screenWidth * 0.03),
                            ),
                            elevation: 5,
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.check,
                                  size: screenWidth * 0.06,
                                  color: colors.white),
                              SizedBox(width: screenHeight * 0.01),
                              Text(
                                'Submit',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.045,
                                  color: colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                ],
              ),
              SizedBox(height: screenHeight * 0.04),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Text(
                  'Note: QR code will only generate if you are within campus boundaries.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: colors.hintText,
                    fontSize: screenWidth * 0.035,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedReasonType == null) {
      _showErrorDialog('Please select a reason type.');
      return;
    }

    if (_showOtherReasonField && _reasonController.text.trim().isEmpty) {
      _showErrorDialog('Please specify your reason.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final withinRadius = await _isWithinRadius();
      if (!withinRadius) {
        setState(() => _isLoading = false);
        return;
      }

      String reasonType = _selectedReasonType!;
      String reasonDetails = _reasonController.text.trim();

      if (_showOtherReasonField) {
        reasonType = reasonDetails;
      }

      // Call backend to create exit request
      final Map<String, dynamic> exitData = {
        'reason': reasonType,
      };

      // This calls POST /api/exit-requests
      final response = await ExitService.submitExitRequest(exitData);

      // Backend returns: { "exitRequestId": number, "qr": { "t": string, "e": number } }
      final Map<String, dynamic> qr = response['qr'] as Map<String, dynamic>;

      final String qrData = '${qr['t']}|${qr['e']}';

      // Navigate to QR screen with plain text data
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QRCodeGenerator(qrData: qrData),
        ),
      );
    } catch (e) {
      _showErrorDialog(e.toString());
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showErrorDialog(String message) {
    final colors = appColors(context);
    final screenWidth = MediaQuery.of(context).size.width;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colors.box,
        title: Text(
          'Error',
          style: TextStyle(
            color: colors.white,
            fontSize: screenWidth * 0.045,
          ),
        ),
        content: Text(
          message,
          style: TextStyle(
            color: colors.hintText,
            fontSize: screenWidth * 0.04,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'OK',
              style: TextStyle(
                color: colors.green,
                fontSize: screenWidth * 0.04,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
