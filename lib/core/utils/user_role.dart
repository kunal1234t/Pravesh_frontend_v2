import 'package:flutter/material.dart';
import 'package:pravesh_screen/login.dart';
import 'package:pravesh_screen/widgets/navbar.dart';
import 'package:pravesh_screen/services/auth_service.dart';

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
        return UserRole.student; // safe fallback
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: AuthService.me(),
      builder: (context, snapshot) {
        // 1️⃣ Loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // 2️⃣ Not logged in / invalid session
        if (snapshot.hasError || !snapshot.hasData) {
          return const LoginPage();
        }

        final user = snapshot.data!;
        final roleName = user['role']?['name'];

        // 3️⃣ Invalid role → force logout
        if (roleName == null || roleName is! String) {
          return const LoginPage();
        }

        final userRole = _mapRoleToEnum(roleName);

        // 4️⃣ ✅ ALL roles go through Navbar (single entry point)
        return Navbar(
          userRole: userRole,
        );
      },
    );
  }
}
