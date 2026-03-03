import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/role_service.dart';
import '../services/notification_service.dart';
import '../services/update_service.dart';

import 'admin_screen.dart';

import 'student_screen.dart';
import 'login_screen.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _initializedServices = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initializedServices && FirebaseAuth.instance.currentUser != null) {
      _initializedServices = true;

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await NotificationService().init(context);
        await UpdateService().checkForUpdate(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Not logged in
        if (!snapshot.hasData) {
          return const LoginScreen();
        }

        // Logged in → Load role
        return FutureBuilder<String>(
          future: RoleService.getUserRole(),
          builder: (context, roleSnapshot) {
            if (roleSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            if (!roleSnapshot.hasData) {
              return const Scaffold(
                body: Center(child: Text("Error loading role")),
              );
            }

            final role = roleSnapshot.data!;

            if (role == 'main_admin' || role == 'sub_admin') {
              return AdminScreen(role: role);
            } else {
              return const StudentScreen();
            }
          },
        );
      },
    );
  }
}
