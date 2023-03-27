import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ins_flutter/constant/component/widget/pick_image_dialog.dart';
import 'package:ins_flutter/constant/component/widget/picker_media.dart';
import 'package:ins_flutter/constant/component/widget/circle_avatar_widget.dart';
import 'package:ins_flutter/constant/component/widget/loading_widget.dart';
import 'package:ins_flutter/constant/string.dart';
import 'package:ins_flutter/data/repository/post_repository_new.dart';
import 'package:ins_flutter/view/home/provider/user_provider.dart';
import 'package:ins_flutter/constant/component/widget/snackbar.dart';
import 'package:ins_flutter/constant/provider/obscure_provider.dart';
import 'package:ins_flutter/constant/provider/picker_image_provider.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  @override
  void initState() {
    context.read<UserProvider>().refreshUser();
    super.initState();
  }

  final TextEditingController _descriptionController = TextEditingController();

  _selectImage(BuildContext context) async {
    return showChoiceImageDialog(
      context,
      ConstantStrings.choseImage,
      () async {
        Navigator.of(context).pop();
        Uint8List file = await pickImage(ImageSource.gallery);
        context.read<PickerImageProvider>().pickerImageUInt8list(file);
      },
      () async {
        Navigator.pop(context);
        Uint8List file = await pickImage(ImageSource.camera);
        context.read<PickerImageProvider>().pickerImageUInt8list(file);
      },
    );
  }

  void postImage(
    BuildContext context,
    String uid,
    String username,
    String profImage,
    Uint8List file,
  ) async {
    context.read<ObscureProvider>().setLoadingAddPostScreen(true);
    try {
      String res = await PostRepositoryNew().uploadPost(
        _descriptionController.text,
        file,
        uid,
        username,
        profImage,
      );
      if (res == ConstantStrings.success) {
        context.read<ObscureProvider>().setLoadingAddPostScreen(false);
        if (mounted) {
          showSnackBarSuccess(
            context: context,
            title: ConstantStrings.notification,
            message: res,
          );
        }
        clearImage();
      } else {
        if (mounted) {
          showSnackBarWarning(
            context: context,
            title: ConstantStrings.notification,
            message: res,
          );
        }
      }
    } catch (err) {
      context.read<ObscureProvider>().setLoadingAddPostScreen(false);
      if (mounted) {
        showSnackBarFailure(
          context: context,
          title: ConstantStrings.notification,
          message: err.toString(),
        );
        print('${err.toString()}');
      }
    }
  }

  void clearImage() {
    context.read<PickerImageProvider>().pickerImageUInt8list(null);
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userProvider = context.watch<UserProvider>().getUser;
    final imageUInt8 = context.watch<PickerImageProvider>().uInt8list;
    bool isLoading = context.watch<ObscureProvider>().loadingAddPostScreen;

    return userProvider == null
        ? LoadingWidget()
        : (imageUInt8 == null
            ? Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: theme.canvasColor.withOpacity(0.5),
                    backgroundColor: theme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onPressed: () => _selectImage(context),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        ConstantStrings.upload,
                        style: TextStyle(
                          color: theme.canvasColor.withOpacity(0.5),
                        ),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Icon(
                        Icons.upload,
                        size: 24.0,
                      ),
                    ],
                  ),
                ),
              )
            : Scaffold(
                backgroundColor: theme.cardColor,
                appBar: AppBar(
                  backgroundColor: theme.cardColor,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: clearImage,
                  ),
                  title: const Text(
                    ConstantStrings.addPost,
                  ),
                  centerTitle: false,
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => postImage(
                        context,
                        userProvider.uid!,
                        userProvider.username!,
                        userProvider.photoUrl!,
                        imageUInt8,
                      ),
                      child: Text(
                        ConstantStrings.post,
                        style: TextStyle(
                          color: theme.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                    )
                  ],
                ),
                // POST FORM
                body: Column(
                  children: <Widget>[
                    isLoading
                        ? LinearProgressIndicator(
                            color: theme.primaryColor,
                          )
                        : const Padding(padding: EdgeInsets.only(top: 0.0)),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: SizedBox(
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                              fit: BoxFit.fill,
                              alignment: FractionalOffset.topCenter,
                              image: MemoryImage(imageUInt8),
                            )),
                          ),
                        ),
                      ),
                    ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          CircleAvatarWidget(
                            photoUrl: userProvider.photoUrl!,
                            width: 40,
                            height: 40,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            userProvider.username!,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: SizedBox(
                          width: double.infinity,
                          child: TextField(
                            controller: _descriptionController,
                            decoration: const InputDecoration(
                              hintText: ConstantStrings.pleaseEnterCaption,
                              border: InputBorder.none,
                            ),
                            maxLines: 10,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ));
  }
}
