import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../login.dart';

class ProtectedRoute extends StatelessWidget {
  final Widget child;
  final List<String> allowedRoles;

  const ProtectedRoute({
    super.key,
    required this.child,
    required this.allowedRoles,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.me(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError || snapshot.data == null) {
          return const LoginPage();
        }

        final roleData = snapshot.data!['role'];
        if (roleData is! Map<String, dynamic> ||
            !roleData.containsKey('name')) {
          return const LoginPage();
        }

        final role = roleData['name'] as String;
        if (!allowedRoles.contains(role)) {
          return const Scaffold(
            body: Center(child: Text('Access Denied')),
          );
        }

        return child;
      },
    );
  }
}
