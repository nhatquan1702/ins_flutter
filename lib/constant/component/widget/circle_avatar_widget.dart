import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CircleAvatarWidget extends StatelessWidget {
  final String photoUrl;
  final double width;
  final double height;
  const CircleAvatarWidget({
    required this.photoUrl,
    required this.width,
    required this.height,
  }) : super();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ClipOval(
      child: CachedNetworkImage(
        width: width,
        height: height,
        imageUrl: photoUrl,
        placeholder: (context, url) => SizedBox(
          width: 24,
          height: 24,
          child: Center(
            child: CircularProgressIndicator(
              color: theme.primaryColor,
            ),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          color: theme.canvasColor.withOpacity(0.2),
          child: Icon(
            Icons.person,
            color: theme.canvasColor.withOpacity(0.5),
          ),
        ),
        fit: BoxFit.cover,
      ),
    );
  }
}
