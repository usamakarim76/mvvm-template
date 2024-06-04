import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mvvm/view/home/home_view.dart';
import 'package:mvvm/view/login/login_view.dart';
import 'package:mvvm/view_model/services/session_manager/session_controller.dart';

class SplashServices {
  void checkAuthentication(BuildContext context) async {
    SessionController().getUserFromPreference().then((value) async {
      if (SessionController().isLogin.toString() == 'true') {
        Timer(
            const Duration(seconds: 2),
            () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeView()),
                )
            //pushNamedAndRemoveUntil(context, RoutesName.home, (route) => false),
            );
      } else {
        Timer(
            const Duration(seconds: 2),
            () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginView()),
                )
            // Navigator.pushNamedAndRemoveUntil(
            //     context, RoutesName.login, (route) => false),
            );
      }
    }).onError((error, stackTrace) {
      Timer(
          const Duration(seconds: 2),
          () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginView()),
              )
          //  Navigator.pushNamedAndRemoveUntil(
          //     context, RoutesName.login, (route) => false),
          );
    });
  }
}
