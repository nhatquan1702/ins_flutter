import 'package:flutter/material.dart';
import 'package:ins_flutter/constant/component/setup/dimension.dart';
import 'package:ins_flutter/constant/component/widget/loading_widget.dart';
import 'package:ins_flutter/constant/string.dart';
import 'package:ins_flutter/view/feed_image/provider/post_provider.dart';
import 'package:ins_flutter/view/search/search_screen.dart';
import 'package:provider/provider.dart';

import '../add_post/post_card.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PostProvider>().fetchListPost();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);
    final listPost = context.watch<PostProvider>().getListPost;

    return Scaffold(
      backgroundColor: theme.cardColor,
      appBar: width > webScreenSize
          ? null
          : AppBar(
              backgroundColor: theme.cardColor,
              centerTitle: false,
              title: Text(
                ConstantStrings.appName,
                style: TextStyle(
                  color: theme.canvasColor,
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.search,
                    color: theme.primaryColor,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchScreen(
                          isSearchPost: true,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(
                  width: 4,
                ),
              ],
            ),
      body: listPost == null
          ? LoadingWidget()
          : ListView.builder(
              itemCount: listPost.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 2,
                    vertical: 4,
                  ),
                  child: PostCard(
                    post: listPost[index],
                  ),
                );
              }),
      floatingActionButton: width < webScreenSize
          ? null
          : FloatingActionButton(
              backgroundColor: theme.cardColor,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchScreen(
                      isSearchPost: true,
                    ),
                  ),
                );
              },
              child: Icon(
                Icons.search,
                color: theme.primaryColor,
              ),
            ),
    );
  }
}
