import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pravesh_screen/app_colors_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:uuid/uuid.dart';

class QRCodeGenerator extends StatefulWidget {
  final String qrData;

  const QRCodeGenerator({super.key, required this.qrData});

  @override
  State<QRCodeGenerator> createState() => _QRCodeGeneratorState();
}

class _QRCodeGeneratorState extends State<QRCodeGenerator>
    with WidgetsBindingObserver {
  late final String _qrId;
  late final DateTime _expiresAt;
  int _remainingTime = 0;
  Timer? _timer;
  bool _isActive = true;
  bool _isConsumed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _qrId = const Uuid().v4();
    _expiresAt = DateTime.now().add(const Duration(minutes: 5));
    _updateRemainingTime();
    _startSecureSession();
    _startTimer();
  }

  void _startSecureSession() {
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    }
  }

  void _updateRemainingTime() {
    final now = DateTime.now();
    final difference = _expiresAt.difference(now);
    _remainingTime = difference.inSeconds > 0 ? difference.inSeconds : 0;
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted || !_isActive) return;

      final previousTime = _remainingTime;
      _updateRemainingTime();

      if (_remainingTime != previousTime && mounted) {
        setState(() {});
      }

      if (_remainingTime <= 0) {
        _timer?.cancel();
        _isConsumed = true;
        if (mounted) {
          _showTimeLimitExceededDialog();
        }
      }
    });
  }

  void _pauseTimer() {
    _isActive = false;
    _timer?.cancel();
  }

  void _resumeTimer() {
    if (_isActive || _remainingTime <= 0) return;

    if (DateTime.now().isAfter(_expiresAt)) {
      _isConsumed = true;
      if (mounted) {
        _showTimeLimitExceededDialog();
      }
      return;
    }

    _isActive = true;
    _updateRemainingTime();

    if (_remainingTime > 0) {
      _startTimer();
    } else {
      _isConsumed = true;
      if (mounted) {
        _showTimeLimitExceededDialog();
      }
    }
  }

  String _getQRPayload() {
    if (_isConsumed || _remainingTime <= 0) {
      return 'EXPIRED';
    }
    return '${widget.qrData}|$_qrId|${_expiresAt.toIso8601String()}';
  }

  void _showTimeLimitExceededDialog() {
    final colors = appColors(context);
    final screenWidth = MediaQuery.of(context).size.width;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: colors.box,
          title: Text(
            'QR Expired',
            style: TextStyle(
              color: colors.white,
              fontSize: screenWidth * 0.05,
            ),
          ),
          content: Text(
            'This QR code is no longer valid. Please generate a new one if needed.',
            style: TextStyle(
              color: colors.hintText,
              fontSize: screenWidth * 0.04,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                }
              },
              child: Text(
                'OK',
                style: TextStyle(
                  color: colors.green,
                  fontSize: screenWidth * 0.04,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        _pauseTimer();
        break;
      case AppLifecycleState.resumed:
        _resumeTimer();
        break;
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        break;
    }
  }

  @override
  void dispose() {
    _isConsumed = true;
    _pauseTimer();
    _timer = null;
    WidgetsBinding.instance.removeObserver(this);

    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.edgeToEdge,
        overlays: SystemUiOverlay.values,
      );
      SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    }

    super.dispose();
  }

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$remainingSeconds';
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final colors = appColors(context);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        automaticallyImplyLeading: false,
        title: Text(
          'SCAN QR CODE',
          style: TextStyle(
            fontSize: screenWidth * 0.055,
            fontWeight: FontWeight.bold,
            color: colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05,
            vertical: screenHeight * 0.03,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text(
                    'Show this QR code at the gate while exiting',
                    style: TextStyle(
                      color: colors.hintText,
                      fontSize: screenWidth * 0.04,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.03),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.06,
                  vertical: screenHeight * 0.02,
                ),
                decoration: BoxDecoration(
                  color: colors.box,
                  borderRadius: BorderRadius.circular(screenWidth * 0.03),
                  boxShadow: [
                    BoxShadow(
                      color: colors.green.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'TIME REMAINING',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: screenWidth * 0.04,
                      ),
                    ),
                    SizedBox(width: screenHeight * 0.01),
                    Text(
                      _formatTime(_remainingTime),
                      style: TextStyle(
                        color: colors.green,
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.04),
              Container(
                width: screenWidth * 0.65,
                height: screenWidth * 0.65,
                padding: EdgeInsets.all(screenWidth * 0.05),
                decoration: BoxDecoration(
                  color: colors.white,
                  borderRadius: BorderRadius.circular(screenWidth * 0.06),
                  boxShadow: [
                    BoxShadow(
                      color: colors.green.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: QrImageView(
                  data: _getQRPayload(),
                  version: QrVersions.auto,
                  size: screenWidth * 0.7,
                  foregroundColor: colors.background,
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Text(
                'Scan before the timer expires',
                style: TextStyle(
                  color: colors.green,
                  fontSize: screenWidth * 0.045,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.green,
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.06,
                        vertical: screenWidth * 0.02,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(screenWidth * 0.03),
                      ),
                      elevation: 5,
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.home,
                            size: screenWidth * 0.06, color: colors.white),
                        SizedBox(width: screenHeight * 0.01),
                        Text(
                          'Home',
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
            ],
          ),
        ),
      ),
    );
  }
}
