import 'package:final_tpg_project_p1/view/student_home.dart';
import 'package:flutter/material.dart';
import 'package:final_tpg_project_p1/service/auth_service.dart';
import 'signup.dart';
import 'forgot_password.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  void login() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      await _authService.signIn(emailController.text, passwordController.text);

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Login successful')));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const StudentHome()),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Login failed: $e')));
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),

      body: Padding(
        padding: EdgeInsets.all(16),

        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),

            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: "Password"),
            ),

            Align(
              alignment: Alignment.centerRight,

              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,

                    MaterialPageRoute(
                      builder: (context) => ForgotPasswordPage(),
                    ),
                  );
                },

                child: Text("Forgot Password?"),
              ),
            ),

            SizedBox(height: 20),

            isLoading
                ? CircularProgressIndicator()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,

                    children: [
                      ElevatedButton(onPressed: login, child: Text("Login")),

                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,

                            MaterialPageRoute(
                              builder: (context) => SignupScreen(),
                            ),
                          );
                        },

                        child: Text("Create an account"),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
