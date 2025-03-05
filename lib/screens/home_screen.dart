import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:practical_signin/screens/signin_screen.dart';

class HomeScreen extends StatelessWidget {
  final User user;
  const HomeScreen({super.key, required this.user});

  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut(); // Firebase Sign Out
      await GoogleSignIn().signOut(); // Google Sign Out

      // Navigate back to sign-in screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SigninScreen()),
      );
    } catch (e) {
      print("Error signing out: $e");
    }
  }

  List<String> getLinkedProviders(User user) {
    return user.providerData
        .map((info) => info.providerId)
        .where((id) => id != 'password') // Exclude email/password provider
        .map((id) {
          switch (id) {
            case 'google.com':
              return 'Google';
            case 'twitter.com':
              return 'Twitter';
            case 'github.com':
              return 'GitHub';
            case 'facebook.com':
              return 'Facebook';
            case 'apple.com':
              return 'Apple';
            default:
              return id; // Fallback for unknown providers
          }
        })
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    List<String> linkedAccounts = getLinkedProviders(user);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _signOut(context),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Welcome, ${user.displayName ?? 'User'}!",
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            Text(
              linkedAccounts.isNotEmpty
                  ? "Linked Accounts: ${linkedAccounts.join(', ')}"
                  : "No linked accounts",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
