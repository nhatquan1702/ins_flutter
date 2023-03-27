import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ins_flutter/constant/component/setup/show_time_format.dart';
import 'package:ins_flutter/constant/component/widget/circle_avatar_widget.dart';
import 'package:ins_flutter/constant/string.dart';
import 'package:ins_flutter/constant/component/widget/snackbar.dart';
import 'package:ins_flutter/data/model/post.dart';
import 'package:ins_flutter/data/repository/post_repository_new.dart';
import 'package:ins_flutter/view/comment/comment_screen_new.dart';
import 'package:ins_flutter/view/comment/provider/comment_provider.dart';
import 'package:ins_flutter/view/feed_image/provider/post_provider.dart';
import 'package:ins_flutter/view/home/provider/user_provider.dart';
import 'package:provider/provider.dart';

import '../feed_image/widget/like_animation.dart';

class PostCard extends StatefulWidget {
  final Post post;
  const PostCard({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  @override
  void initState() {
    super.initState();
    context.read<UserProvider>().refreshUser();
    context.read<CommentProvider>().setCommentLength(widget.post.postId);
  }

  likePost(String uid) async {
    await PostRepositoryNew().likePost(
      widget.post.postId.toString(),
      uid,
      widget.post.likes,
    );
  }

  deletePost(String postId) async {
    try {
      await PostRepositoryNew().deletePost(postId);
    } catch (err) {
      showSnackBarWarning(
        context: context,
        title: ConstantStrings.error,
        message: err.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userData = context.watch<UserProvider>().getUser;
    var isLikeAnimating =
        context.watch<PostProvider>().isLikeAnimating[widget.post.postId];
    if (isLikeAnimating == null) {
      isLikeAnimating = false;
    }
    final cmtLength =
        context.watch<CommentProvider>().commentLength[widget.post.postId];

    return userData == null
        ? SizedBox()
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: theme.primaryColor.withOpacity(0.5),
                ),
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 10,
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 16,
                    ).copyWith(right: 0),
                    child: Row(
                      children: <Widget>[
                        CircleAvatarWidget(
                          photoUrl: widget.post.profImage,
                          width: 32,
                          height: 32,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 8,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  widget.post.username,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: theme.primaryColor),
                                ),
                              ],
                            ),
                          ),
                        ),
                        widget.post.uid.toString() == userData.uid
                            ? IconButton(
                                onPressed: () {
                                  showDialog(
                                    useRootNavigator: false,
                                    context: context,
                                    builder: (context) {
                                      return Dialog(
                                        child: ListView(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 16),
                                          shrinkWrap: true,
                                          children: [
                                            ConstantStrings.deletePost,
                                          ]
                                              .map(
                                                (e) => InkWell(
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      vertical: 12,
                                                      horizontal: 16,
                                                    ),
                                                    child: Text(e),
                                                  ),
                                                  onTap: () {
                                                    deletePost(
                                                      widget.post.postId
                                                          .toString(),
                                                    );
                                                    // remove the dialog box
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              )
                                              .toList(),
                                        ),
                                      );
                                    },
                                  );
                                },
                                icon: Icon(
                                  Icons.more_vert,
                                  color: theme.canvasColor.withOpacity(0.6),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                  // IMAGE SECTION OF THE POST
                  GestureDetector(
                    onDoubleTap: () {
                      likePost(userData.uid!);
                      context
                          .read<PostProvider>()
                          .setLikeAnimating(widget.post.postId, true);
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        AspectRatio(
                          aspectRatio: 16 / 9,
                          child: CachedNetworkImage(
                            imageUrl: widget.post.postUrl.toString(),
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
                                size: 100,
                                color: theme.canvasColor.withOpacity(0.5),
                              ),
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 300),
                          opacity: isLikeAnimating ? 1 : 0,
                          child: LikeAnimation(
                            isAnimating: isLikeAnimating,
                            child: Icon(
                              Icons.favorite,
                              color: Colors.red,
                              size: 100,
                            ),
                            duration: const Duration(
                              milliseconds: 400,
                            ),
                            onEnd: () {
                              likePost(userData.uid!);
                              context.read<PostProvider>().fetchListPost();
                              context
                                  .read<PostProvider>()
                                  .setLikeAnimating(widget.post.postId, false);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      LikeAnimation(
                        isAnimating: widget.post.likes.contains(userData.uid),
                        smallLike: true,
                        child: IconButton(
                          icon: widget.post.likes.contains(userData.uid)
                              ? const Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                )
                              : Icon(
                                  Icons.favorite_border,
                                  color: theme.canvasColor.withOpacity(0.5),
                                ),
                          onPressed: () {
                            context
                                .read<PostProvider>()
                                .setLikeAnimating(widget.post.postId, true);
                            context.read<PostProvider>().fetchListPost();
                          },
                        ),
                      ),
                      DefaultTextStyle(
                        style: theme.textTheme.titleSmall!
                            .copyWith(fontWeight: FontWeight.w800),
                        child: Text(
                          '${widget.post.likes.length} ${ConstantStrings.like}',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.comment_outlined,
                          color: theme.canvasColor.withOpacity(0.5),
                          size: 22,
                        ),
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => NewCommentsScreen(
                              postId: widget.post.postId.toString(),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        child: Text(
                          '${cmtLength ?? 0} ${ConstantStrings.comment}',
                          style: theme.textTheme.bodyMedium,
                        ),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => NewCommentsScreen(
                              postId: widget.post.postId,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.share,
                          color: theme.canvasColor.withOpacity(0.5),
                          size: 22,
                        ),
                        onPressed: () {},
                      ),
                      InkWell(
                        child: Text(
                          '${ConstantStrings.share}',
                          style: theme.textTheme.bodyMedium,
                        ),
                        onTap: () {},
                      ),
                    ],
                  ),
                  //DESCRIPTION AND NUMBER OF COMMENTS
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.only(
                            top: 8,
                          ),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: widget.post.username.toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: theme.canvasColor,
                                  ),
                                ),
                                TextSpan(
                                  style: TextStyle(color: theme.canvasColor),
                                  text: ' ${widget.post.description}',
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                            FormatTime.showTimeFormat(
                              widget.post.datePublished,
                              2,
                            ),
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
