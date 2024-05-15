

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cache_manager/cache_manager.dart';
import 'package:flutter/material.dart';
import 'package:rpe_c/app/constants/app.keys.dart';
import 'package:rpe_c/app/routes/app.routes.dart';
import 'package:rpe_c/core/api/authentication.api.dart';
import 'package:rpe_c/core/logger/logger.dart';
import 'package:rpe_c/core/utils/snackbar.util.dart';

class AuthenticationNotifier with ChangeNotifier {
  final AuthenticationAPI _authenticationAPI = AuthenticationAPI();

  String? _passwordLevel = "";

  String? get passwordLevel => _passwordLevel;

  String? _passwordEmoji = "";

  String? get passwordEmoji => _passwordEmoji;

  void checkPasswordStrength({required String password}) {
    String mediumPattern = r'^(?=.*?[!@#\$&*~]).{8,}';
    String strongPattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';

    if (password.contains(RegExp(strongPattern))) {
      _passwordEmoji = '🚀';
      _passwordLevel = 'Strong';
      notifyListeners();
    } else if (password.contains(RegExp(mediumPattern))) {
      _passwordEmoji = '🔥';
      _passwordLevel = 'Medium';
      notifyListeners();
    } else if (!password.contains(RegExp(strongPattern))) {
      _passwordEmoji = '😢';
      _passwordLevel = 'Weak';
      notifyListeners();
    }
  }

  Future createAccount(
      {required String useremail,
      required BuildContext context,
      required String username,
      required String userpassword}) async {
    try {
      var userData = await _authenticationAPI.createAccount(
          useremail: useremail, username: username, userpassword: userpassword);

      final Map<String, dynamic> parseData = await jsonDecode(userData);
      bool isAuthenticated = parseData['authentication'];
      dynamic authData = parseData['data'];

      if (isAuthenticated) {
        WriteCache.setString(key: AppKeys.userData, value: authData)
            .whenComplete(
          () => Navigator.of(context)
              .pushReplacementNamed(AppRouter.homeRoute), //todo change to home
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackUtil.stylishSnackBar(text: authData, context: context));
      }
    } on SocketException catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
          text: 'Oops No You Need A Good Internet Connection',
          context: context));
    } on TimeoutException catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
          text: 'Houston we have a problem', context: context));
      // handle timeout
    } catch (e) {
      logger.e(e);
    }
  }

  Future userLogin(
      {required String email,
      required BuildContext context,
      required String password}) async {
    Navigator.of(context).pushReplacementNamed(AppRouter.homeRoute);
    //uncomment when use with server
    // try {

    //
    //   var userData =
    //       await _authenticationAPI.userLogin(email: email, password: password);

    //   final Map<String, dynamic> parseData = await jsonDecode(userData);
    //
    //
    //   bool isAuthenticated = parseData['authentication'] as bool;
    //   String authData = parseData['data'];

    //   if (isAuthenticated) {
    //     //todo add uncomment when use with server
    //     // WriteCache.setString(key: AppKeys.userData, value: authData)
    //     //     .whenComplete(
    //     //   () => Navigator.of(context).pushReplacementNamed(
    //     //       // AppRouter.myHomeRoute
    //     //       AppRouter.myHomeRoute), //todo change  to home scene
    //     // );
    //   } else {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //         SnackUtil.stylishSnackBar(text: authData, context: context));
    //   }
    // } on SocketException catch (_) {
    //   ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
    //       text: 'Oops No You Need A Good Internet Connection',
    //       context: context));
    // } on TimeoutException catch (_) {
    //   ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
    //       text: 'Houston we have a problem', context: context));
    //   // handle timeout
    // } catch (e) {
    // }
  }
}
