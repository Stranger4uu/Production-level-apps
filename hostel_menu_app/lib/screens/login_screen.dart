import 'student_screen.dart';
import 'admin_screen.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLogin = true;

  void handleAuth() async {
    try {
      AppUser? user;

      if (isLogin) {
        user = await _authService.login(
          emailController.text.trim(),
          passwordController.text.trim(),
        );
      } else {
        user = await _authService.register(
          emailController.text.trim(),
          passwordController.text.trim(),
        );
      }

      if (!mounted) return;  // 🔥 ADD THIS LINE

      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Welcome")),
        );
      }
    } catch (e) {
      if (!mounted) return;  // 🔥 ADD THIS HERE TOO

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceAll("Exception: ", ""))),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hostel Menu App")),
      body: Center(   // 🔥 THIS IS WHERE WE MODIFIED BODY
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: handleAuth,
                  child: Text(isLogin ? "Login" : "Register"),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      isLogin = !isLogin;
                    });
                  },
                  child: Text(
                    isLogin
                        ? "Create new account"
                        : "Already have account?",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}