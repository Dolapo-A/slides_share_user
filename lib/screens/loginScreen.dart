// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, unused_field, use_build_context_synchronously

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:slides_share_user/controllers/authController.dart';
import 'package:slides_share_user/controllers/snackbarController.dart';
import 'package:slides_share_user/screens/ForgotPasswordScreen.dart';
import 'package:slides_share_user/screens/homescreen.dart';
import 'package:slides_share_user/screens/signupScreen.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = 'loginScreen';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  bool _isLoading = false;

  loginUsers() async {
    setState(() {
      _isLoading = true;
    });

    String res = await AuthController()
        .loginUsers(_emailController.text, _passwordController.text);

    setState(() {
      _isLoading = false;
    });

    if (res != 'success') {
      snackBar(res, context);
    } else {
      return Navigator.of(context)
          .pushNamedAndRemoveUntil(HomeScreen.routeName, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff72503c),
        title: Text(
          'SlideTech Login Page',
          style: TextStyle(fontWeight: FontWeight.normal),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage('assets/libone.jpg'),
          fit: BoxFit.cover,
        )),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formkey,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black26),
                    color: Color.fromARGB(255, 255, 255, 255)),
                // width: SizeConfig().widthSize(context, 70),
                // height: SizeConfig().heigthSize(context, 50),
                width: 300,
                height: 330,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'Login',
                            style: TextStyle(
                                fontSize: 26, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 14),
                        decoration: InputDecoration(
                          labelText: "Email",

                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 15,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          labelStyle: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),

                          //for the errors
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: const BorderSide(
                              color: Colors.red,
                              width: 2.0,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        validator: (v) {
                          if (v!.isEmpty) {
                            return 'This field is required';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 14),
                        decoration: InputDecoration(
                          labelText: "Password",

                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 15,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          labelStyle: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),

                          //for the errors
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: const BorderSide(
                              color: Colors.red,
                              width: 2.0,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        validator: (v) {
                          if (v!.isEmpty) {
                            return 'This field is required';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: const Alignment(1, 0),
                        child: RichText(
                            // key: _textsKey,
                            text: TextSpan(
                                text: 'Forgot Password?',
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => Navigator.of(context)
                                          .push(PageRouteBuilder(
                                        pageBuilder: (context, animation,
                                                secondaryAnimation) =>
                                            ForgotPasswordScreen(),
                                      )))),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Color(0xff003c7b)),
                        onPressed: () {
                          if (_formkey.currentState!.validate()) {
                            loginUsers();
                          }
                        },
                        child: Center(
                          child: _isLoading
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  "Login",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      RichText(
                          // key: _textKey,
                          text: TextSpan(children: <TextSpan>[
                        const TextSpan(
                          text: "Don't have an account?",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                        TextSpan(
                            text: ' SignUp Here',
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () =>
                                  Navigator.of(context).push(PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                            secondaryAnimation) =>
                                        const SignUpScreen(),
                                  ))),
                      ])),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
