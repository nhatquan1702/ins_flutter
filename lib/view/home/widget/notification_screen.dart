import 'package:flutter/material.dart';
import 'package:ins_flutter/constant/string.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.cardColor,
      body: Center(
        child: Text(
          ConstantStrings.notification,
          style: TextStyle(
            color: theme.canvasColor,
          ),
        ),
      ),
    );
  }
}
