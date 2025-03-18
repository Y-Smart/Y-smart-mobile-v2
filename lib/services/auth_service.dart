import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:y_smart_mobile/providers/jwt_provider.dart';
import 'package:y_smart_mobile/screens/home_screen.dart';
import 'package:y_smart_mobile/utils/constants.dart';
import 'package:y_smart_mobile/utils/utils.dart';

class AuthService {
  void signUpUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      var jwtProvider = Provider.of<JwtProvider>(context, listen: false);
      final navigator = Navigator.of(context);

      http.Response res = await http.post(
        Uri.parse('${Constants.API_URL}/auth/signup'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'email': email, 
          'password': password
        })
      );

      final data = jsonDecode(res.body);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        jwtProvider.setJwt(res.body);
        await navigator.pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
          (route) => false,
        );
      } else {
        showSnackBar(context, data['message']);
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void signInUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    var jwtProvider = Provider.of<JwtProvider>(context, listen: false);
    final navigator = Navigator.of(context);

    try {
      http.Response res = await http.post(
        Uri.parse('${Constants.API_URL}/auth/signin'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'email': email, 
          'password': password
        })
      );

      final data = jsonDecode(res.body);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        jwtProvider.setJwt(res.body);
        await navigator.pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
          (route) => false,
        );
      } else {
        showSnackBar(context, data['message']);
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
