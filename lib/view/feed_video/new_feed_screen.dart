import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ins_flutter/constant/component/widget/loading_widget.dart';
import 'package:ins_flutter/constant/component/widget/pick_image_dialog.dart';
import 'package:ins_flutter/constant/component/widget/picker_media.dart';
import 'package:ins_flutter/data/model/video.dart';
import 'package:ins_flutter/view/feed_video/provider/video_provider.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import 'widget/action_toolbar.dart';
import 'widget/video_description.dart';

class NewFeedScreen extends StatefulWidget {
  const NewFeedScreen({Key? key}) : super(key: key);

  @override
  State<NewFeedScreen> createState() => _NewFeedScreenState();
}

class _NewFeedScreenState extends State<NewFeedScreen> {
  @override
  void initState() {
    super.initState();
    context.read<VideoProvider>().fetchVideoSource();
    context.read<VideoProvider>().loadVideo(0);
    context.read<VideoProvider>().loadVideo(1);
  }

  @override
  void dispose() {
    super.dispose();
    final listVideo = context.watch<VideoProvider>().videoSource;
    for (var v in listVideo!) {
      v.controller!.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return feedVideos(context);
  }

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

  Widget feedVideos(BuildContext context) {
    final listVideo = context.watch<VideoProvider>().videoSource;

    return listVideo == null
        ? Scaffold(
            backgroundColor: Theme.of(context).cardColor,
            body: LoadingWidget(),
          )
        : Stack(
            children: [
              PageView.builder(
                controller: PageController(
                  initialPage: 0,
                  viewportFraction: 1,
                ),
                itemCount: listVideo.length,
                onPageChanged: (index) {
                  index = index % (listVideo.length.toInt());
                  context.read<VideoProvider>().changeVideo(index);
                },
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  index = index % (listVideo.length);
                  return videoCard(listVideo[index]);
                },
              ),
              SafeArea(
                child: Container(
                  alignment: Alignment.topRight,
                  padding: EdgeInsets.only(right: 8),
                  child: IconButton(
                    onPressed: () => _selectVideo(context),
                    icon: Icon(
                      Icons.add_card,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
            ],
          );
  }

  Widget videoCard(Video video) {
    return Stack(
      children: [
        video.controller != null
            ? GestureDetector(
                onTap: () {
                  if (video.controller!.value.isPlaying) {
                    video.controller!.pause();
                  } else {
                    video.controller!.play();
                  }
                },
                child: SizedBox.expand(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: video.controller!.value.size.width,
                      height: video.controller!.value.size.height,
                      child: VideoPlayer(video.controller!),
                    ),
                  ),
                ),
              )
            : Center(
                child: Container(
                  width: 24,
                  height: 24,
                  color: Colors.transparent,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                VideoDescription(
                  video.username,
                  video.caption,
                  video.songName,
                ),
                ActionsToolbar(
                  video.likes.length,
                  video.commentCount,
                  video.profilePhoto,
                  video.thumbnail,
                ),
              ],
            ),
            VideoProgressIndicator(
              colors: VideoProgressColors(
                backgroundColor: Theme.of(context).canvasColor.withOpacity(0.5),
                playedColor: Theme.of(context).primaryColor,
              ),
              video.controller!,
              allowScrubbing: true,
            ),
          ],
        ),
      ],
    );
  }
}
