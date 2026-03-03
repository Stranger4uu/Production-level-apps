import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/notification_service.dart';
import 'login_screen.dart';
import 'admin_screen.dart';
import 'sub_admin_screen.dart';
import 'student_screen.dart';
import '../services/role_service.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {

  bool _notificationInitialized = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData) {
          return const LoginScreen();
        }

        // ✅ Initialize notifications once after login
        if (!_notificationInitialized) {
          NotificationService().init(context);
          _notificationInitialized = true;
        }

        return FutureBuilder<String>(
          future: RoleService.getUserRole(),
          builder: (context, roleSnapshot) {

            if (!roleSnapshot.hasData) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            String role = roleSnapshot.data!;

            if (role == 'main_admin') {
              return const AdminScreen();
            } else if (role == 'sub_admin') {
              return const SubAdminScreen();
            } else {
              return const StudentScreen();
            }
          },
        );
      },
    );
  }
}