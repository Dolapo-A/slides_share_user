
import 'package:flutter/material.dart';

snackBar(String title, BuildContext context) {
  
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      
      backgroundColor: Colors.white,
      content: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
      )));
}
