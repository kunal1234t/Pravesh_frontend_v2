import 'package:flutter/material.dart';
import 'package:pravesh_screen/app_colors_provider.dart';
import 'package:pravesh_screen/services/auth_service.dart';
import 'package:pravesh_screen/widgets/color.dart';

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

    return Container(
      color: colors.background,
      child: SafeArea(
        child: FutureBuilder<StrapiUserResponse>(
          future: _userFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(colors.green),
                ),
              );
            }

            if (snapshot.hasError) {
              return _buildErrorState(
                context,
                colors,
                screenWidth,
                screenHeight,
              );
            }

            if (snapshot.hasData) {
              return _buildProfileContent(
                context,
                snapshot.data!,
                colors,
                screenWidth,
                screenHeight,
              );
            }

            return _buildErrorState(
              context,
              colors,
              screenWidth,
              screenHeight,
            );
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
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05,
            vertical: screenHeight * 0.02,
          ),
          child: Row(
            children: [
              Icon(
                Icons.person,
                color: colors.white,
                size: screenWidth * 0.06,
              ),
              SizedBox(width: screenWidth * 0.03),
              Text(
                _getProfileTitle(user),
                style: TextStyle(
                  color: colors.white,
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05,
              vertical: screenHeight * 0.01,
            ),
            child: Column(
              children: [
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
                _buildDetailCard(
                  context: context,
                  icon: Icons.person_outline,
                  title: "Full Name",
                  value: user.username.isNotEmpty
                      ? user.username
                      : 'Not available',
                  screenWidth: screenWidth,
                ),
                SizedBox(height: screenHeight * 0.025),
                _buildDetailCard(
                  context: context,
                  icon: Icons.email_outlined,
                  title: "Email Address",
                  value: user.email.isNotEmpty ? user.email : 'Not available',
                  screenWidth: screenWidth,
                ),
                SizedBox(height: screenHeight * 0.025),
                _buildDetailCard(
                  context: context,
                  icon: Icons.work_outline,
                  title: "Role",
                  value: user.role.name.isNotEmpty
                      ? user.role.name
                      : 'Not available',
                  screenWidth: screenWidth,
                ),
                SizedBox(height: screenHeight * 0.025),
                _buildDetailCard(
                  context: context,
                  icon: Icons.badge_outlined,
                  title: "User ID",
                  value: user.id != 0 ? user.id.toString() : 'Not available',
                  screenWidth: screenWidth,
                ),
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
                if (user.attributes != null &&
                    user.attributes!.containsKey('roomNo'))
                  Column(
                    children: [
                      SizedBox(height: screenHeight * 0.025),
                      _buildDetailCard(
                        context: context,
                        icon: Icons.meeting_room_outlined,
                        title: "Room Number",
                        value: user.attributes!['roomNo']?.toString() ??
                            'Not available',
                        screenWidth: screenWidth,
                      ),
                    ],
                  ),
                SizedBox(height: screenHeight * 0.05),
              ],
            ),
          ),
        ),
      ],
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
