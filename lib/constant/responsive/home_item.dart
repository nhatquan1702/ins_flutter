import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ins_flutter/view/home/widget/add_post_screen.dart';
import 'package:ins_flutter/view/home/widget/feed_screen.dart';
import 'package:ins_flutter/view/home/widget/notification_screen.dart';
import 'package:ins_flutter/view/home/widget/profile_screen.dart';
import 'package:ins_flutter/view/home/widget/search_screen.dart';

final List<Widget> widgetOptions = <Widget>[
  const FeedScreen(),
  const SearchScreen(
    isSearchPost: false,
  ),
  const AddPostScreen(),
  const NotificationScreen(),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
    isTapScreen: true,
  ),
];
