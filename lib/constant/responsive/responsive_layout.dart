import 'package:flutter/material.dart';
import 'package:ins_flutter/constant/responsive/dimension.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget webLayout;
  final Widget mobileLayout;
  const ResponsiveLayout({
    super.key,
    required this.webLayout,
    required this.mobileLayout,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constrains) {
      if (constrains.maxWidth > webScreenSize) {
        return webLayout;
      }
      return mobileLayout;
    });
  }
}
