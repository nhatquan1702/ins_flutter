import 'package:flutter/material.dart';
import 'package:ins_flutter/constant/component/setup/show_time_format.dart';
import 'package:ins_flutter/constant/component/widget/circle_avatar_widget.dart';
import 'package:ins_flutter/data/model/comment.dart';

class CommentCard extends StatelessWidget {
  final Comment comment;
  const CommentCard({Key? key, required this.comment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Row(
        children: [
          CircleAvatarWidget(
            photoUrl: comment.profilePic!,
            width: 36,
            height: 36,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: comment.name!,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor),
                        ),
                        TextSpan(text: ' '),
                        TextSpan(
                          text: comment.text!,
                          style: TextStyle(
                            color: Theme.of(context).canvasColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      FormatTime.showTimeFormat(
                        comment.datePublished,
                        2,
                      ),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: const Icon(
              Icons.favorite_border,
              size: 16,
            ),
          )
        ],
      ),
    );
  }
}
