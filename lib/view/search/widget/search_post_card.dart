import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ins_flutter/constant/component/setup/show_time_format.dart';
import 'package:ins_flutter/data/model/post.dart';

class SearchPostCard extends StatelessWidget {
  final Post post;
  const SearchPostCard({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            child: CachedNetworkImage(
              imageUrl: post.postUrl,
              fit: BoxFit.cover,
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
                  Icons.photo,
                  color: theme.canvasColor.withOpacity(0.5),
                ),
              ),
            ),
            width: 56,
            height: 56,
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
                          text: post.username,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        TextSpan(text: ' '),
                        TextSpan(
                          text: post.description,
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
                        post.datePublished,
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
        ],
      ),
    );
  }
}
