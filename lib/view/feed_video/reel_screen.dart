import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ins_flutter/constant/component/widget/circle_avatar_widget.dart';
import 'package:ins_flutter/constant/component/widget/loading_widget.dart';
import 'package:ins_flutter/constant/component/widget/pick_image_dialog.dart';
import 'package:ins_flutter/constant/component/widget/picker_media.dart';
import 'package:ins_flutter/constant/string.dart';
import 'package:ins_flutter/view/comment/comment_screen_new.dart';
import 'package:ins_flutter/view/feed_video/provider/video_provider.dart';
import 'package:ins_flutter/view/home/provider/user_provider.dart';
import 'package:provider/provider.dart';

import 'widget/circle_animation.dart';
import 'widget/video_card.dart';

class ReelScreen extends StatefulWidget {
  const ReelScreen({super.key});

  @override
  State<ReelScreen> createState() => _ReelScreenState();
}

class _ReelScreenState extends State<ReelScreen> {
  _selectVideo(BuildContext context) async {
    return showChoiceImageDialog(
      context,
      'Chon video',
      () async {
        pickVideo(ImageSource.gallery, context);
      },
      () async {
        pickVideo(ImageSource.camera, context);
      },
    );
  }

  buildProfile(String profilePhoto) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Stack(children: [
        Positioned(
          left: 5,
          child: Container(
            width: 50,
            height: 50,
            padding: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),
            child: CircleAvatarWidget(
              width: 50,
              height: 50,
              photoUrl: profilePhoto,
            ),
          ),
        )
      ]),
    );
  }

  buildMusicAlbum(String profilePhoto) {
    return SizedBox(
      height: 40,
      width: 40,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(8),
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Colors.grey,
                  Colors.white,
                ],
              ),
              borderRadius: BorderRadius.circular(50),
            ),
            child: CircleAvatarWidget(
              width: 50,
              height: 50,
              photoUrl: profilePhoto,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    context.read<VideoProvider>().fetchListVideo();
    context.read<UserProvider>().refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final userData = context.watch<UserProvider>().getUser;
    final videoData = context.watch<VideoProvider>().getListVideo;

    return Scaffold(
      backgroundColor: theme.cardColor,
      appBar: AppBar(
        backgroundColor: theme.cardColor,
        title: Text(
          ConstantStrings.reel,
          style: TextStyle(color: theme.canvasColor),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () => _selectVideo(context),
            icon: Icon(
              Icons.add,
              color: theme.primaryColor,
            ),
          ),
        ],
      ),
      body: (userData == null || videoData == null)
          ? LoadingWidget()
          : PageView.builder(
              itemCount: videoData.length,
              controller: PageController(initialPage: 0, viewportFraction: 1),
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                final data = videoData[index];
                return Stack(
                  children: [
                    VideoPlayerItem(
                      videoUrl: data.videoUrl,
                    ),
                    Column(
                      children: [
                        const SizedBox(
                          height: 100,
                        ),
                        Expanded(
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.only(
                                    left: 20,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        data.username,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      Text(
                                        data.caption,
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.music_note,
                                            size: 16,
                                            color: Colors.white,
                                          ),
                                          Text(
                                            data.songName,
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 12,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                width: 100,
                                margin: EdgeInsets.only(top: size.height / 4),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    buildProfile(
                                      data.profilePhoto,
                                    ),
                                    Column(
                                      children: [
                                        InkWell(
                                          onTap: () {},
                                          // onTap: () => videoController
                                          //     .likeVideo(data.id),
                                          child: Icon(
                                            Icons.favorite,
                                            size: 24,
                                            color: data.likes.contains(
                                              userData.uid,
                                            )
                                                ? Colors.red
                                                : Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          data.likes.length.toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        )
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        InkWell(
                                          onTap: () =>
                                              Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  NewCommentsScreen(
                                                postId: data.id,
                                              ),
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.comment,
                                            size: 22,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          data.commentCount.toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        )
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        InkWell(
                                          onTap: () {},
                                          child: const Icon(
                                            Icons.share,
                                            size: 22,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          data.shareCount.toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        )
                                      ],
                                    ),
                                    CircleAnimation(
                                      child: buildMusicAlbum(data.profilePhoto),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
    );
  }
}
