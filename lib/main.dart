import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:practical_signin/screens/signin_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
      FacebookAuth.i.webAndDesktopInitialize(
    appId: "YOUR_FACEBOOK_APP_ID",
    cookie: true,
    xfbml: true,
    version: "v18.0",
  );
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Firebase Google Sign-In',
      home: SigninScreen(),
    );
  }
}
