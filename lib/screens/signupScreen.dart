// ignore_for_file: file_names

import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:slides_share_user/controllers/authController.dart';
import 'package:slides_share_user/controllers/snackbarController.dart';
import 'package:slides_share_user/screens/loginScreen.dart';
import 'package:the_validator/the_validator.dart';

class SignUpScreen extends StatefulWidget {
  static const String routeName = 'signUpScreen';

  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  final AuthController _authController = AuthController();
  final TextEditingController _indexNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmpasswordTextController =
      TextEditingController();
  bool passwordVisible = true;

  bool isLoading = false;

  signUp() async {
    setState(() {
      isLoading = true;
    });
    String res = await _authController.signUpUsers(
      _indexNumberController.text,
      _emailController.text,
      _passwordController.text,
    );

    setState(() {
      isLoading = false;
    });

    if (res != 'success') {
      return snackBar(res, context);
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    }
  }

  // const LandingCustomerScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              )),
          backgroundColor: Color(0xff72503c),
          title: const Text(
            'SlideTech Student Registration Page',
            style:
                TextStyle(fontWeight: FontWeight.normal, color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage('assets/06.jpg'),
            fit: BoxFit.cover,
          )),
          child: Padding(
            padding:
                const EdgeInsets.only(left: 12, bottom: 8, right: 12, top: 8),
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black26),
                    color: Color.fromARGB(255, 255, 255, 255)),
                width: 350,
                height: 450,
                child: Padding(
                  padding: const EdgeInsets.only(left: 24, right: 24),
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Create Account',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            child: Form(
                              key: _formkey,
                              child: Column(
                                children: [
                                  // fullname
                                  // fullname
                                  // fullname
                                  TextFormField(
                                    controller: _indexNumberController,
                                    textCapitalization:
                                        TextCapitalization.words,
                                    keyboardType: TextInputType.name,
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 14),
                                    decoration: InputDecoration(
                                      labelText: "Index number",
                                      isDense: true,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 15,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.grey),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(width: 1),
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      labelStyle: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                      ),

                                      //for the errors
                                      errorBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        borderSide: const BorderSide(
                                          color: Colors.red,
                                          width: 2.0,
                                        ),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'This field is required';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  // email
                                  // email
                                  // email
                                  TextFormField(
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 14),
                                    decoration: InputDecoration(
                                      labelText: "Email",
                                      isDense: true,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 15,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.grey),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(width: 1),
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      labelStyle: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                      ),

                                      //for the errors
                                      errorBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        borderSide: const BorderSide(
                                          color: Colors.red,
                                          width: 2.0,
                                        ),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                    ),
                                    validator: (value) =>
                                        EmailValidator.validate(value!)
                                            ? null
                                            : "Please enter a valid email",
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  TextFormField(
                                    controller: _passwordController,
                                    obscureText: passwordVisible,
                                    validator: FieldValidator.password(
                                        minLength: 4,
                                        shouldContainNumber: false,
                                        shouldContainCapitalLetter: false,
                                        shouldContainSmallLetter: false,
                                        shouldContainSpecialChars: false,
                                        errorMessage:
                                            "Password must match the required format",
                                        onNumberNotPresent: () {
                                          return "Password must contain at least one Number";
                                        },
                                        onSpecialCharsNotPresent: () {
                                          return "Password must contain special characters";
                                        },
                                        onCapitalLetterNotPresent: () {
                                          return "Must contain CAPITAL letters";
                                        }),
                                    keyboardType: TextInputType.text,
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 14),
                                    decoration: InputDecoration(
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            passwordVisible = !passwordVisible;
                                          });
                                        },
                                        icon: passwordVisible
                                            ? const Icon(
                                                Icons.visibility,
                                                color: Colors.grey,
                                              )
                                            : const Icon(
                                                Icons.visibility_off,
                                                color: Colors.grey,
                                              ),
                                      ),
                                      labelText: "Password",
                                      isDense: true,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 5,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.grey),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(width: 1),
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      labelStyle: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                      ),

                                      //for the errors
                                      errorBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        borderSide: const BorderSide(
                                          color: Colors.red,
                                          width: 2.0,
                                        ),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),

                                  TextFormField(
                                    controller: _confirmpasswordTextController,
                                    keyboardType: TextInputType.text,
                                    obscureText: true,
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 14),
                                    decoration: InputDecoration(
                                      labelText: "Confirm Password",
                                      isDense: true,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 15,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.grey),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(width: 1),
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      labelStyle: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                      ),

                                      //for the error message
                                      errorBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        borderSide: const BorderSide(
                                          color: Colors.red,
                                          width: 2.0,
                                        ),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                    ),
                                    validator: FieldValidator.equalTo(
                                        _passwordController,
                                        message: "Password mismatch"),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    width: 300,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: Color(0xff003c7b)),
                                      onPressed: () {
                                        if (_formkey.currentState!.validate()) {
                                          signUp();
                                        }
                                        // _fullNameController.clear();
                                        // _emailController.clear();
                                        // _usernameController.clear();
                                        // _phoneController.clear();
                                        // _passwordController.clear();
                                        // _confirmpasswordTextController.clear();
                                        // _image!.clear();
                                      },
                                      child: isLoading
                                          ? const SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 3,
                                              ),
                                            )
                                          : const Text(
                                              "Sign Up",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
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
                                      text: "Already have an account? ",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    TextSpan(
                                        text: 'Login Here',
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () => Navigator.of(context)
                                                  .push(PageRouteBuilder(
                                                pageBuilder: (context,
                                                        animation,
                                                        secondaryAnimation) =>
                                                    const LoginScreen(),
                                              ))),
                                  ])),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
