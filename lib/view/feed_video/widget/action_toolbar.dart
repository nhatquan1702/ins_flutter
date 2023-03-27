import 'package:flutter/material.dart';
import 'package:ins_flutter/constant/component/widget/circle_avatar_widget.dart';
import 'package:ins_flutter/view/feed_video/widget/circle_animation.dart';

class ActionsToolbar extends StatelessWidget {
  final int numLikes;
  final int numComments;
  final String userPic;
  final String cover;

  ActionsToolbar(
    this.numLikes,
    this.numComments,
    this.userPic,
    this.cover,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 16.0, left: 8.0, right: 8.0),
      width: 100.0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            padding: EdgeInsets.all(1.0),
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30.0),
              child: CircleAvatarWidget(
                photoUrl: userPic,
                width: 60,
                height: 60,
              ),
            ),
          ),
          _getSocialAction(
            icon: Icons.favorite,
            title: numLikes.toString(),
          ),
          _getSocialAction(
            icon: Icons.chat,
            title: numComments.toString(),
          ),
          _getSocialAction(
            icon: Icons.share,
            title: 'Chia sẻ',
          ),
          CircleAnimation(
            child: _getMusicPlayerAction(userPic),
          ),
        ],
      ),
    );
  }

  Widget _getSocialAction({
    required String title,
    required IconData icon,
  }) {
    return Container(
      margin: EdgeInsets.only(top: 15.0),
      width: 60.0,
      height: 60.0,
      child: Column(
        children: [
          Icon(
            icon,
            size: 32,
            color: Colors.grey[300],
          ),
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  LinearGradient get musicGradient => LinearGradient(
        colors: [
          Colors.grey[800]!,
          Colors.grey[900]!,
          Colors.grey[900]!,
          Colors.grey[800]!
        ],
        stops: [0.0, 0.4, 0.6, 1.0],
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
      );

  Widget _getMusicPlayerAction(userPic) {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      width: 60,
      height: 60,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10.0),
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              gradient: musicGradient,
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30.0),
              child: CircleAvatarWidget(
                photoUrl: cover,
                width: 50,
                height: 50,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
