import 'package:flutter/material.dart';
import 'package:pravesh_screen/widgets/navbar.dart';
import 'services/auth_service.dart';
import 'login.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  UserRole _mapRoleToEnum(String role) {
    switch (role.toLowerCase()) {
      case 'student':
        return UserRole.student;
      case 'teacher':
        return UserRole.teacher;
      case 'warden':
        return UserRole.warden;
      case 'guard':
        return UserRole.guard;
      default:
        throw Exception('Unknown role: $role');
    }
  }

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

        if (!snapshot.hasData || snapshot.hasError) {
          return const LoginPage();
        }

        final user = snapshot.data!;
        final roleName = user['role']?['name'];

        if (roleName == null) {
          return const LoginPage();
        }

        final userRole = _mapRoleToEnum(roleName);

        return Navbar(
          userRole: userRole,
        );
      },
    );
  }
}
