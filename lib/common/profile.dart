import 'package:flutter/material.dart';
import 'package:pravesh_screen/app_colors_provider.dart';
import 'package:pravesh_screen/services/auth_service.dart';
import 'package:pravesh_screen/widgets/color.dart';

// Assuming AuthService is imported from your project
import 'package:pravesh_screen/services/auth_service.dart';

class StrapiUserResponse {
  final int id;
  final String username;
  final String email;
  final StrapiRole role;
  final Map<String, dynamic>? attributes;

  StrapiUserResponse({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
    this.attributes,
  });

  factory StrapiUserResponse.fromJson(Map<String, dynamic> json) {
    return StrapiUserResponse(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      role: StrapiRole.fromJson(json['role'] ?? {}),
      attributes: json,
    );
  }
}

class StrapiRole {
  final int id;
  final String name;
  final String description;
  final String type;

  StrapiRole({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
  });

  factory StrapiRole.fromJson(Map<String, dynamic> json) {
    return StrapiRole(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      type: json['type'] ?? '',
    );
  }
}

class ViewProfileScreen extends StatefulWidget {
  // Optional: You can pass an existing user if needed (for caching)
  final StrapiUserResponse? initialUser;

  const ViewProfileScreen({
    super.key,
    this.initialUser,
  });

  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {
  late Future<StrapiUserResponse> _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = _fetchUserProfile();
  }

  Future<StrapiUserResponse> _fetchUserProfile() async {
    try {
      // Call the existing AuthService.me() method
      final response = await AuthService.me();
      return StrapiUserResponse.fromJson(response);
    } catch (e) {
      throw Exception('Failed to load user profile');
    }
  }

  String _getProfileTitle(StrapiUserResponse? user) {
    if (user == null) return 'Profile';

    final roleName = user.role.name.toLowerCase();
    if (roleName.contains('student')) return 'Student Profile';
    if (roleName.contains('teacher')) return 'Teacher Profile';
    if (roleName.contains('warden')) return 'Warden Profile';
    if (roleName.contains('guard')) return 'Guard Profile';

    return '${user.role.name} Profile';
  }

  void _handleRetry() {
    setState(() {
      _userFuture = _fetchUserProfile();
    });
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
        elevation: 0,
        automaticallyImplyLeading: false,
        title: FutureBuilder<StrapiUserResponse>(
          future: _userFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text(
                'Profile',
                style: TextStyle(
                  color: colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth * 0.055,
                ),
              );
            } else if (snapshot.hasError) {
              return Text(
                'Profile',
                style: TextStyle(
                  color: colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth * 0.055,
                ),
              );
            } else if (snapshot.hasData) {
              return Text(
                _getProfileTitle(snapshot.data),
                style: TextStyle(
                  color: colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth * 0.055,
                ),
              );
            }
            return Text(
              'Profile',
              style: TextStyle(
                color: colors.white,
                fontWeight: FontWeight.bold,
                fontSize: screenWidth * 0.055,
              ),
            );
          },
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: FutureBuilder<StrapiUserResponse>(
          future: _userFuture,
          builder: (context, snapshot) {
            // Loading State
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(colors.green),
                ),
              );
            }

            // Error State
            if (snapshot.hasError) {
              return _buildErrorState(
                  context, colors, screenWidth, screenHeight);
            }

            // Data Loaded State
            if (snapshot.hasData) {
              final user = snapshot.data!;
              return _buildProfileContent(
                  context, user, colors, screenWidth, screenHeight);
            }

            // Empty State (should not happen with proper API)
            return _buildErrorState(context, colors, screenWidth, screenHeight);
          },
        ),
      ),
    );
  }

  Widget _buildProfileContent(
    BuildContext context,
    StrapiUserResponse user,
    AppColors colors,
    double screenWidth,
    double screenHeight,
  ) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.05,
        vertical: screenHeight * 0.02,
      ),
      child: Column(
        children: [
          // Profile Picture
          Center(
            child: Container(
              width: screenWidth * 0.3,
              height: screenWidth * 0.3,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: colors.green,
                  width: screenWidth * 0.01,
                ),
                image: const DecorationImage(
                  image: AssetImage('assets/default_profile.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.04),

          // Full Name
          _buildDetailCard(
            context: context,
            icon: Icons.person_outline,
            title: "Full Name",
            value: user.username.isNotEmpty ? user.username : 'Not available',
            screenWidth: screenWidth,
          ),
          SizedBox(height: screenHeight * 0.025),

          // Email Address
          _buildDetailCard(
            context: context,
            icon: Icons.email_outlined,
            title: "Email Address",
            value: user.email.isNotEmpty ? user.email : 'Not available',
            screenWidth: screenWidth,
          ),
          SizedBox(height: screenHeight * 0.025),

          // Role
          _buildDetailCard(
            context: context,
            icon: Icons.work_outline,
            title: "Role",
            value: user.role.name.isNotEmpty ? user.role.name : 'Not available',
            screenWidth: screenWidth,
          ),
          SizedBox(height: screenHeight * 0.025),

          // User ID
          _buildDetailCard(
            context: context,
            icon: Icons.badge_outlined,
            title: "User ID",
            value: user.id != 0 ? user.id.toString() : 'Not available',
            screenWidth: screenWidth,
          ),

          // Optional Additional Fields
          if (user.attributes != null &&
              user.attributes!.containsKey('mobileNo'))
            Column(
              children: [
                SizedBox(height: screenHeight * 0.025),
                _buildDetailCard(
                  context: context,
                  icon: Icons.phone_android_outlined,
                  title: "Mobile Number",
                  value: user.attributes!['mobileNo']?.toString() ??
                      'Not available',
                  screenWidth: screenWidth,
                ),
              ],
            ),

          if (user.attributes != null && user.attributes!.containsKey('roomNo'))
            Column(
              children: [
                SizedBox(height: screenHeight * 0.025),
                _buildDetailCard(
                  context: context,
                  icon: Icons.meeting_room_outlined,
                  title: "Room Number",
                  value:
                      user.attributes!['roomNo']?.toString() ?? 'Not available',
                  screenWidth: screenWidth,
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildErrorState(
    BuildContext context,
    AppColors colors,
    double screenWidth,
    double screenHeight,
  ) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: colors.red,
              size: screenWidth * 0.15,
            ),
            SizedBox(height: screenHeight * 0.02),
            Text(
              'Failed to load profile',
              style: TextStyle(
                color: colors.white,
                fontSize: screenWidth * 0.045,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: screenHeight * 0.01),
            Text(
              'Please check your connection and try again',
              style: TextStyle(
                color: colors.white.withOpacity(0.7),
                fontSize: screenWidth * 0.035,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: screenHeight * 0.03),
            ElevatedButton(
              onPressed: _handleRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(screenWidth * 0.025),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.06,
                  vertical: screenHeight * 0.015,
                ),
              ),
              child: Text(
                'Retry',
                style: TextStyle(
                  color: colors.white,
                  fontSize: screenWidth * 0.04,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String value,
    required double screenWidth,
  }) {
    final colors = appColors(context);
    return Container(
      padding: EdgeInsets.all(screenWidth * 0.045),
      decoration: BoxDecoration(
        color: colors.box,
        borderRadius: BorderRadius.circular(screenWidth * 0.035),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: colors.green,
            size: screenWidth * 0.065,
          ),
          SizedBox(width: screenWidth * 0.045),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: colors.white.withOpacity(0.6),
                    fontSize: screenWidth * 0.038,
                  ),
                ),
                SizedBox(height: screenWidth * 0.015),
                Text(
                  value,
                  style: TextStyle(
                    color: colors.white,
                    fontSize: screenWidth * 0.043,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
