import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ins_flutter/view/add_post/widget/add_post_screen.dart';
import 'package:ins_flutter/view/feed_image/feed_screen.dart';
import 'package:ins_flutter/view/feed_video/new_feed_screen.dart';
import 'package:ins_flutter/view/feed_video/reel_screen.dart';
import 'package:ins_flutter/view/account/profile_screen.dart';
import 'package:ins_flutter/view/search/search_screen.dart';

final List<Widget> widgetOptions = <Widget>[
  const FeedScreen(),
  const SearchScreen(
    isSearchPost: false,
  ),
  const AddPostScreen(),
  NewFeedScreen(),
  //const ReelScreen(),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
    isTapScreen: true,
  ),
];
