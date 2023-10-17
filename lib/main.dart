import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:slides_share_user/screens/ForgotPasswordScreen.dart';
import 'package:slides_share_user/screens/homescreen.dart';
import 'package:slides_share_user/screens/initialHomeScreen.dart';
import 'package:slides_share_user/screens/loginScreen.dart';
import 'package:slides_share_user/screens/signupScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyBS4g-v_HIcbh_hIkfyQbFBgA-scjIBWgQ",
          authDomain: "slidesshare-f089e.firebaseapp.com",
          projectId: "slidesshare-f089e",
          storageBucket: "slidesshare-f089e.appspot.com",
          messagingSenderId: "348273033224",
          appId: "1:348273033224:web:436a08c3bd048bdbecd1bd"));

            MobileAds.instance.initialize();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  // final Future<FirebaseApp> _initialFirebaseApp = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      initialRoute: InitialHomeScreen.routeName,
      routes: {
        InitialHomeScreen.routeName: (context) => const InitialHomeScreen(),
        SignUpScreen.routeName: (context) => const SignUpScreen(),
        LoginScreen.routeName: (context) => const LoginScreen(),
        ForgotPasswordScreen.routeName: (context) =>
            const ForgotPasswordScreen(),
        HomeScreen.routeName: (context) => const HomeScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
