import 'package:flutter/material.dart';
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
                onPressed: () {},
                child: const Text(
                  'About',
                  style: TextStyle(color: Colors.white),
                )),
          ),
          const SizedBox(
            width: 0,
          ),
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
                  style: TextStyle(color: Colors.white),
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
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'WELCOME TO',
                style: TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 0,
              ),
              const Text(
                'SLIDETECH',
                style: TextStyle(
                    fontSize: 120,
                    color: Color(0xffEBF8B8),
                    fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 150,
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
                          style: TextStyle(color: Colors.white),
                        )),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: 150,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.white),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                          'Learn More',
                          style: TextStyle(color: Colors.black),
                        )),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
