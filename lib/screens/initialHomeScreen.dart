
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:slides_share_user/screens/loginScreen.dart';
import 'package:slides_share_user/screens/signupScreen.dart';

class InitialHomeScreen extends StatefulWidget {
  static const String routeName = 'initialHomeScreen';

  const InitialHomeScreen({super.key});

  @override
  State<InitialHomeScreen> createState() => _InitialHomeScreenState();
}

class _InitialHomeScreenState extends State<InitialHomeScreen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    double textSize =
        screenWidth * 0.02; // You can adjust the multiplier as needed
    double textSizeTitle =
        screenWidth * 0.15; // You can adjust the multiplier as needed
   
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Row(
          children: <Widget>[
            Text(
              'SlideTech',
              style:
                  TextStyle(fontWeight: FontWeight.w700, color: Colors.black87),
            ),
          ],
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Color(0xff003c7b)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                  );
                },
                child: const Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                )),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/02.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            color:
                Colors.black.withOpacity(0.5), // Adjust the opacity as needed
          ),
          // Content
          Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    'WELCOME TO',
                    style: TextStyle(
                        fontSize: textSize,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                  const Gap(10),
                  Text(
                    'SLIDETECH',
                    style: TextStyle(
                        fontSize: textSizeTitle,
                        color: Color(0xffEBF8B8),
                        fontWeight: FontWeight.bold,
                        height: 1),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 100,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Color(0xff003c7b)),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignUpScreen()),
                              );
                            },
                            child: const Text(
                              'Sign up',
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            )),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: 100,
                        child: ElevatedButton(
                            style:
                                ElevatedButton.styleFrom(primary: Colors.white),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Welcome to Our Web Application",
                                          style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.w800),
                                        ),
                                        Divider(
                                          thickness: 2,
                                        ),
                                      ],
                                    ),
                                    content: Container(
                                      width: 600,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          const Text(
                                            "An innovative web application designed to revolutionize the dissemination of slides for the Computer Science Department at Koforidua Technical University (KTU). Join us in bridging the gap between traditional communication methods and modern technological expectations. Experience a comprehensive solution tailored to your unique needs.",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text("OK"),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: const Text(
                              'About Us',
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 12),
                            )),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
