import 'package:flutter/material.dart';
import 'package:ins_flutter/constant/component/widget/circle_avatar_widget.dart';
import 'package:ins_flutter/constant/string.dart';
import 'package:ins_flutter/view/feed_image/provider/post_provider.dart';
import 'package:ins_flutter/view/home/provider/user_provider.dart';
import 'package:ins_flutter/view/search/widget/search_post_card.dart';
import 'package:ins_flutter/constant/provider/obscure_provider.dart';
import 'package:provider/provider.dart';

import '../account/profile_screen.dart';

class SearchScreen extends StatefulWidget {
  final bool isSearchPost;
  const SearchScreen({Key? key, required this.isSearchPost}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final postSearch = context.watch<PostProvider>().getListPostBySearch;
    final userSearch = context.watch<UserProvider>().getListUserBySearch;

    return Scaffold(
      backgroundColor: theme.cardColor,
      appBar: AppBar(
        leading: !widget.isSearchPost
            ? null
            : IconButton(
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
                iconSize: 20,
                icon: Icon(
                  Icons.arrow_back,
                  color: theme.canvasColor,
                ),
              ),
        backgroundColor: theme.cardColor,
        title: TextField(
          controller: searchController,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: widget.isSearchPost
                ? ConstantStrings.searchPost
                : ConstantStrings.searchUser,
            hintStyle: theme.textTheme.bodyMedium,
          ),
          style: theme.textTheme.bodyLarge,
          autofocus: context.watch<ObscureProvider>().keySearchScreen.isEmpty
              ? false
              : true,
          textInputAction: TextInputAction.search,
          onChanged: (String value) {
            if (widget.isSearchPost) {
              context.read<PostProvider>().searchPost(value);
            } else {
              context.read<UserProvider>().searchUser(value);
            }
            context.read<ObscureProvider>().setKeySearchScreen(value);
          },
          onSubmitted: (String value) {
            if (widget.isSearchPost) {
              context.read<PostProvider>().searchPost(value);
            } else {
              context.read<UserProvider>().searchUser(value);
            }
            context.read<ObscureProvider>().setKeySearchScreen(value);
          },
        ),
        actions: [
          if (searchController.text == '')
            SizedBox()
          else
            IconButton(
              onPressed: () {
                if (searchController.text != '') {
                  searchController.clear();
                  searchController.text = '';
                  context.read<ObscureProvider>().setKeySearchScreen('');
                }
              },
              icon: Icon(
                Icons.close,
                color: theme.primaryColor,
              ),
            )
        ],
        elevation: 1,
      ),
      body: widget.isSearchPost
          ? (postSearch == null
              ? SizedBox()
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: postSearch.length,
                    itemBuilder: (context, index) =>
                        SearchPostCard(post: postSearch[index]),
                  ),
                ))
          : (userSearch == null
              ? SizedBox()
              : ListView.builder(
                  itemCount: userSearch.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ProfileScreen(
                            uid: userSearch[index].uid ?? '',
                            isTapScreen: false,
                          ),
                        ),
                      ),
                      child: userSearch[index].photoUrl == null
                          ? SizedBox()
                          : ListTile(
                              leading: CircleAvatarWidget(
                                photoUrl: userSearch[index].photoUrl!,
                                width: 40,
                                height: 40,
                              ),
                              title: Text(
                                userSearch[index].username!,
                              ),
                            ),
                    );
                  },
                )),
    );
  }
}
