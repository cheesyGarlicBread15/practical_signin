import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:practical_signin/screens/home_screen.dart';

class SetPasswordScreen extends StatefulWidget {
  final User user;
  const SetPasswordScreen({super.key, required this.user});

  @override
  State<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _setPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final email = widget.user.email;
      if (email == null) throw Exception("Email not found");

      // Create an email/password credential
      AuthCredential emailCredential = EmailAuthProvider.credential(
        email: email,
        password: _passwordController.text.trim(),
      );

      // Link Email/Password to the existing Google-signed-in user
      await widget.user.linkWithCredential(emailCredential);

      // Redirect to Home Screen
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => HomeScreen(user: widget.user)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to set password: $e")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Set Password")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Set Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) => (value == null || value.length < 6)
                    ? 'Password must be at least 6 characters'
                    : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _setPassword,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text("Save Password"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
