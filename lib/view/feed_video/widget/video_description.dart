import 'package:flutter/material.dart';
import 'package:text_scroll/text_scroll.dart';

class VideoDescription extends StatelessWidget {
  final username;
  final videoTitle;
  final songInfo;

  VideoDescription(
    this.username,
    this.videoTitle,
    this.songInfo,
  );

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 120.0,
        padding: EdgeInsets.only(left: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              username,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Flexible(
              child: Text(
                videoTitle,
                style: TextStyle(
                  color: Colors.white,
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 2,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Icon(
                  Icons.music_note,
                  color: Colors.white,
                  size: 16,
                ),
                Flexible(
                  child: TextScroll(
                    songInfo,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12
                    ),
                    intervalSpaces: 8,
                    velocity: Velocity(pixelsPerSecond: Offset(50, 0)),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
