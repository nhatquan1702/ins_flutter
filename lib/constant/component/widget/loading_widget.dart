import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget() : super();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: theme.cardColor,
      child: Center(
        child: CircularProgressIndicator(
          color: theme.primaryColor,
        ),
      ),
    );
  }
}
