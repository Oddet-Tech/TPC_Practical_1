//Group P1 members: Shilenge Oddet 223015126
//Brandon Lombaard 223021599
//Motloli TJ 22206982
//Quadri PF 224017653
//Asive Mnyamazi 224113476
//Selahla KO 221007346
// Makhanye NJ 220000689
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
//Incase Studentt forgets their password,
// they can reset it by entering their email address,
// and a password reset link will be sent to their email.
class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final TextEditingController emailController = TextEditingController();
//By entering the Email, a Change password Link will be sent to the email address provided by the student.
  Future<void> _resetPassword() async {
    final supabase = Supabase.instance.client;
    final messenger = ScaffoldMessenger.of(context);
    try {
      await supabase.auth.resetPasswordForEmail(emailController.text.trim());
      if (!mounted) return;
      messenger.showSnackBar(
        const SnackBar(content: Text('Password reset link sent to your email')),
      );
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Forgot Password')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Enter your email'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _resetPassword,
              child: const Text('Send Reset Link'),
            ),
          ],
        ),
      ),
    );
  }
}
