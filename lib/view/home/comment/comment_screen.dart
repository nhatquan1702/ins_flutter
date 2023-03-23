import 'package:flutter/material.dart';
import 'package:ins_flutter/constant/component/widget/circle_avatar_widget.dart';
import 'package:ins_flutter/constant/component/widget/loading_widget.dart';
import 'package:ins_flutter/constant/component/widget/snackbar.dart';
import 'package:ins_flutter/constant/responsive/dimension.dart';
import 'package:ins_flutter/constant/string.dart';
import 'package:ins_flutter/data/model/comment.dart';
import 'package:ins_flutter/data/model/post.dart';
import 'package:ins_flutter/data/repository/post_repository.dart';
import 'package:ins_flutter/view/home/comment/provider/comment_provider.dart';
import 'package:ins_flutter/view/home/provider/post_provider.dart';
import 'package:ins_flutter/view/home/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import 'widget/comment_card.dart';

class CommentsScreen extends StatefulWidget {
  final postId;
  CommentsScreen({
    Key? key,
    required this.postId,
  }) : super(key: key);

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  @override
  void initState() {
    context.read<UserProvider>().refreshUser();
    context.read<CommentNotifier>().fetchListComment(widget.postId);
    super.initState();
  }

  final TextEditingController commentEditingController =
      TextEditingController();

  void postComment(String uid, String name, String profilePic) async {
    try {
      final comment = Comment(
        commentId: Uuid().v1(),
        datePublished: DateTime.now(),
        name: name,
        profilePic: profilePic,
        text: commentEditingController.text,
        uid: uid,
      );

      String res = await PostRepository().postComment(
        widget.postId,
        commentEditingController.text,
        comment,
      );

      if (res == ConstantStrings.success) {
        if (mounted) {
          final listPost = List<Post>.from(
              context.read<PostNotifier>().getListPost ?? <Post>[]);
          final index =
              listPost.indexWhere((element) => element.postId == widget.postId);
          final comments = List<Comment>.from(listPost[index].comments ?? []);
          comments.insert(0, comment);
          listPost[index] = listPost[index].copyWith(comments: comments);
          context.read<PostNotifier>().setListPost(listPost);
          // context.read<CommentNotifier>().setCommentLength(widget.postId);
          // context.read<CommentNotifier>().fetchListComment(widget.postId);
          showSnackBarSuccess(
            context: context,
            title: ConstantStrings.comment,
            message: res,
          );
        }
      }
      setState(() {
        commentEditingController.text = "";
      });
    } catch (err) {
      if (mounted) {
        showSnackBarFailure(
          context: context,
          title: ConstantStrings.error,
          message: err.toString(),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = context.watch<UserProvider>().getUser;
    final listPost = context.watch<PostNotifier>().getListPost;
    final post = (listPost ?? [])
        .firstWhere((element) => element.postId == widget.postId);
    final width = MediaQuery.of(context).size.width;

    return user == null
        ? LoadingWidget()
        : Scaffold(
            backgroundColor: theme.cardColor,
            appBar: width > webScreenSize
                ? null
                : AppBar(
                    leading: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: theme.canvasColor,
                      ),
                    ),
                    backgroundColor: theme.cardColor,
                    title: Text(
                      ConstantStrings.commentB,
                      style: TextStyle(
                        color: theme.canvasColor,
                      ),
                    ),
                    centerTitle: false,
                  ),
            body: listPost == null
                ? LoadingWidget()
                : ListView.builder(
                    itemCount: post.comments?.length ?? 0,
                    itemBuilder: (ctx, index) => CommentCard(
                      comment: post.comments![index],
                    ),
                  ),

            // text input
            bottomNavigationBar: SafeArea(
              child: Container(
                color: theme.cardColor,
                height: kToolbarHeight,
                margin: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                padding: const EdgeInsets.only(left: 16, right: 8),
                child: Row(
                  children: [
                    CircleAvatarWidget(
                      photoUrl: user.photoUrl!,
                      width: 36,
                      height: 36,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16, right: 8),
                        child: TextField(
                          controller: commentEditingController,
                          decoration: InputDecoration(
                            hintText:
                                '${user.username} ${ConstantStrings.comment}',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => postComment(
                        user.uid!,
                        user.username!,
                        user.photoUrl!,
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 8,
                        ),
                        child: Text(
                          ConstantStrings.post,
                          style: TextStyle(color: theme.primaryColor),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
