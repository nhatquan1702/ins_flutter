import 'dart:io';
import 'package:flutter/material.dart';

class ProfilePic extends StatelessWidget {
  final File? imageAvatar;
  final VoidCallback? funPickAvatar;

  const ProfilePic({
    super.key,
    this.imageAvatar,
    this.funPickAvatar,
  });

  @override
  Widget build(BuildContext context) {
    final appColor = Theme.of(context);
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          width: 144.0,
          height: 144.0,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(144 / 2)),
            border: Border.all(
              color: appColor.cardColor,
              width: 5.0,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(144 / 2),
            child: GestureDetector(
              onTap: funPickAvatar,
              child: (imageAvatar == null)
                  ? Container(
                      color: appColor.canvasColor.withOpacity(0.1),
                      child: Icon(
                        Icons.add_photo_alternate,
                        color: appColor.canvasColor,
                      ),
                    )
                  : Image.file(
                      imageAvatar!,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
