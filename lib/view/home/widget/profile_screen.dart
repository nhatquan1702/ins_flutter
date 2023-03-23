import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ins_flutter/constant/component/widget/circle_avatar_widget.dart';
import 'package:ins_flutter/constant/component/widget/loading_widget.dart';
import 'package:ins_flutter/constant/responsive/dimension.dart';
import 'package:ins_flutter/constant/string.dart';
import 'package:ins_flutter/data/repository/post_repository.dart';
import 'package:ins_flutter/data/repository/post_repository_new.dart';
import 'package:ins_flutter/data/repository/user_repository.dart';
import 'package:ins_flutter/view/home/provider/post_provider.dart';
import 'package:ins_flutter/view/home/provider/user_provider.dart';
import 'package:ins_flutter/view/login/login_screen.dart';
import 'package:provider/provider.dart';

import 'follow_widget.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  final bool isTapScreen;
  const ProfileScreen(
      {super.key, required this.uid, required this.isTapScreen});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<UserProvider>().refreshUserById(widget.uid);
    context.read<PostNotifier>().fetchListPostByUser(widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;
    final userData = context.watch<UserProvider>().userById;
    final postData = context.watch<PostNotifier>().getListPostByUserId;
    var isFollow = false;
    if (userData != null) {
      isFollow =
          userData.followers!.contains(FirebaseAuth.instance.currentUser!.uid);
    }

    return userData == null || postData == null
        ? Scaffold(body: const LoadingWidget())
        : Scaffold(
            backgroundColor: theme.cardColor,
            appBar: width > webScreenSize
                ? null
                : AppBar(
                    backgroundColor: theme.cardColor,
                    title: Text(
                      userData.username ?? '',
                    ),
                    centerTitle: false,
                    leading: widget.isTapScreen
                        ? null
                        : IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(
                              Icons.arrow_back,
                              color: theme.canvasColor,
                            ),
                          ),
                  ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatarWidget(
                            photoUrl: userData.photoUrl ?? '',
                            width: 80,
                            height: 80,
                          ),
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    buildStatColumn(
                                      postData.length,
                                      ConstantStrings.post,
                                    ),
                                    buildStatColumn(
                                      userData.followers!.length,
                                      ConstantStrings.follower,
                                    ),
                                    buildStatColumn(
                                      userData.following!.length,
                                      ConstantStrings.following,
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    FirebaseAuth.instance.currentUser!.uid ==
                                            widget.uid
                                        ? FollowButton(
                                            text: ConstantStrings.logout,
                                            backgroundColor: theme.primaryColor,
                                            textColor: theme.canvasColor,
                                            borderColor: theme.primaryColor,
                                            function: () async {
                                              await UserRepository().signOut();
                                              if (mounted) {
                                                Navigator.of(context)
                                                    .pushReplacement(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const LoginScreen(),
                                                  ),
                                                );
                                              }
                                            },
                                          )
                                        : isFollow
                                            ? FollowButton(
                                                text: ConstantStrings.unFollow,
                                                backgroundColor:
                                                    theme.primaryColor,
                                                textColor: theme.canvasColor,
                                                borderColor: theme.primaryColor,
                                                function: () async {
                                                  await PostRepositoryNew()
                                                      .followUser(
                                                    FirebaseAuth.instance
                                                        .currentUser!.uid,
                                                    userData.uid ?? '',
                                                  );
                                                  context
                                                      .read<UserProvider>()
                                                      .refreshUserById(
                                                          userData.uid!);
                                                },
                                              )
                                            : FollowButton(
                                                text: ConstantStrings.follow,
                                                backgroundColor:
                                                    theme.primaryColor,
                                                textColor: theme.canvasColor,
                                                borderColor: theme.primaryColor,
                                                function: () async {
                                                  await PostRepository()
                                                      .followUser(
                                                    FirebaseAuth.instance
                                                        .currentUser!.uid,
                                                    userData.uid ?? '',
                                                  );
                                                  context
                                                      .read<UserProvider>()
                                                      .refreshUserById(
                                                          userData.uid!);
                                                },
                                              ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(
                          top: 15,
                        ),
                        child: Text(
                          userData.username ?? '',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(
                          top: 1,
                        ),
                        child: Text(
                          userData.bio ?? '',
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: GridView.builder(
                    shrinkWrap: true,
                    itemCount: postData.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 1.5,
                      childAspectRatio: 1,
                    ),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(2),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: CachedNetworkImage(
                            imageUrl: postData[index].postUrl,
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
                                size: 56,
                                color: theme.canvasColor.withOpacity(0.5),
                              ),
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
  }

  Column buildStatColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Theme.of(context).canvasColor,
            ),
          ),
        ),
      ],
    );
  }
}
