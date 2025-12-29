import 'package:flutter/material.dart';
import 'package:pravesh_screen/app_colors_provider.dart';
import 'package:pravesh_screen/auth_gate.dart';
import 'package:pravesh_screen/widgets/color.dart';
import 'package:pravesh_screen/widgets/navbar.dart';
import 'package:qr_flutter/qr_flutter.dart';

class Thirdpage extends StatefulWidget {
  const Thirdpage({super.key});

  @override
  State<Thirdpage> createState() => _ThirdpageState();
}

class _ThirdpageState extends State<Thirdpage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final colors = appColors(context);

    return Scaffold(
      backgroundColor: IntroBackground,
      body: Stack(
        children: [
          // Background decoration
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    IntroBackground.withOpacity(0.8),
                    IntroBackground.withOpacity(0.9),
                    IntroBackground,
                  ],
                  stops: const [0.1, 0.5, 1.0],
                ),
              ),
            ),
          ),

          // Animated circles decoration
          Positioned(
            top: -screenHeight * 0.2,
            right: -screenWidth * 0.2,
            child: Container(
              width: screenHeight * 0.5,
              height: screenHeight * 0.5,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.green.withOpacity(0.1),
              ),
            ),
          ),

          Positioned(
            bottom: -screenHeight * 0.3,
            left: -screenWidth * 0.2,
            child: Container(
              width: screenHeight * 0.6,
              height: screenHeight * 0.6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.green.withOpacity(0.05),
              ),
            ),
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: screenHeight * 0.1),

              // QR Code with animated container
              ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  padding: EdgeInsets.all(screenWidth * 0.05),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: colors.green.withOpacity(0.3),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: colors.green.withOpacity(0.2),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: QrImageView(
                    data: 'https://example.com',
                    version: QrVersions.auto,
                    size: screenHeight * 0.3,
                    eyeStyle: QrEyeStyle(
                      eyeShape: QrEyeShape.square,
                      color: colors.green,
                    ),
                    dataModuleStyle: QrDataModuleStyle(
                      dataModuleShape: QrDataModuleShape.square,
                      color: colors.green,
                    ),
                    backgroundColor: Colors.transparent,
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.05),

              // Title with fade animation
              FadeTransition(
                opacity: _fadeAnimation,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                  child: Column(
                    children: [
                      Text(
                        'Seamless Access',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: introWhite,
                          fontSize: screenHeight * 0.04,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto',
                          height: 1.3,
                        ),
                      ),
                      Text(
                        'Total Control',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: colors.green,
                          fontSize: screenHeight * 0.04,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto',
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.03),

              // Description with fade animation
              FadeTransition(
                opacity: _fadeAnimation,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                  child: Text(
                    'Enjoy seamless access to your digital world with complete control over your data and privacy.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: introWhite.withOpacity(0.8),
                      fontSize: screenHeight * 0.02,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Roboto',
                      height: 1.5,
                    ),
                  ),
                ),
              ),

              const Spacer(),

              // Animated button
              ScaleTransition(
                scale: _scaleAnimation,
                child: Padding(
                  padding: EdgeInsets.all(screenWidth * 0.06),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => const AuthGate(),
                        ),
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.green,
                      padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.025,
                        horizontal: screenWidth * 0.1,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 8,
                      shadowColor: colors.green.withOpacity(0.5),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'NEXT',
                          style: TextStyle(
                            fontSize: screenWidth * 0.04,
                            color: colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.02),
                        Icon(
                          Icons.arrow_forward,
                          size: screenWidth * 0.05,
                          color: colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
