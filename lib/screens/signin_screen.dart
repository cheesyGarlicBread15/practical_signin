import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:practical_signin/screens/home_screen.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
      clientId:
          '228367469843-cd68bkqhts8a4li0ubvu5tpuj2ovctm1.apps.googleusercontent.com');
  bool _isLoading = false; // Loading state

  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true); // Show loading indicator

    try {
      // Google Sign-In
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        setState(() => _isLoading = false); // Stop loading if cancelled
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Firebase Authentication
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // Navigate to Home Screen
      if (userCredential.user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => HomeScreen(user: userCredential.user!)),
        );
      }
    } catch (e) {
      print("Error signing in with Google: $e");
    } finally {
      setState(() => _isLoading = false); // Stop loading after completion
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign In")),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator() // Show loading indicator
            : ElevatedButton(
                onPressed: _signInWithGoogle,
                child: Text("Sign in with Google"),
              ),
      ),
    );
  }
}
