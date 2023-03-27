import 'package:flutter/material.dart';
import 'package:ins_flutter/constant/string.dart';
import 'package:ins_flutter/view/add_post/widget/add_post_screen.dart';
import 'package:ins_flutter/view/login/login_screen.dart';
import 'package:ins_flutter/view/register/register_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case ConstantStringsRoute.routeToRegisterScreen:
      return MaterialPageRoute(
        builder: (context) => const RegisterScreen(),
      );
    case ConstantStringsRoute.routeToLoginScreen:
      return MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      );
    case ConstantStringsRoute.routeToAddPostScreen:
      return MaterialPageRoute(
        builder: (context) => const AddPostScreen(),
      );
    default:
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: Center(
            child: Text('Một lỗi đã xảy ra!'),
          ),
        ),
      );
  }
}
