// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthController {
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;

// Function to SignUp Users(Send User data to firebase)
  Future<String> signUpUsers(
      String indexnumber, String email, String password) async {
    String res = "Some error occured";
    try {
      if (indexnumber.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
        UserCredential cred = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        await FirebaseFirestore.instance
            .collection('students')
            .doc(cred.user!.uid)
            .set({
          'cid': cred.user!.uid,
          'indexNumber': indexnumber,
          'email': email,
        });

        res = 'success';
      } else {
        res = 'Please fields must not be empty';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  //function to signup vendors

  //function to login users
  loginUsers(String email, String password) async {
    String res = 'Some error occured';

    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);

        User? user = FirebaseAuth.instance.currentUser;
        if (user != null && user.email == 'araoyeemmanuel2001@gmail.com') {
          await FirebaseAuth.instance.signOut();
          res =
              'This account is an administrative account and cannot be used here';
        } else {
          res = 'success';
        }
      } else {
        res = 'please fields must not be empty';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  // Function to reset password
  forgotPassword(String email) async {
    String res = 'Some error occured';

    try {
      if (email.isNotEmpty) {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        res = 'success';
      } else {
        res = "Email field must not be empty";
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  logOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
