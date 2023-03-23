import 'package:flutter/material.dart';
import 'package:ins_flutter/constant/component/widget/pick_image_avatar.dart';
import 'package:ins_flutter/constant/component/widget/picker_media.dart';
import 'package:ins_flutter/constant/responsive/dimension.dart';
import 'package:ins_flutter/constant/string.dart';
import 'package:ins_flutter/constant/component/widget/base_button.dart';
import 'package:ins_flutter/constant/component/widget/snackbar.dart';
import 'package:ins_flutter/data/repository/user_repository.dart';
import 'package:ins_flutter/view/login/provider/obscure_provider.dart';
import 'package:ins_flutter/view/register/provider/picker_avatar_provider.dart';
import 'package:provider/provider.dart';

import 'widget/avatar_picker.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController passController = TextEditingController();
  TextEditingController passAgainController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  void updateStatus() {
    context.read<ObscureNotifier>().updateObscure();
  }

  void updateStatusAgain() {
    context.read<ObscureNotifier>().updateObscureAgain();
  }

  @override
  Widget build(BuildContext context) {
    final appColor = Theme.of(context);
    bool isObscure = context.watch<ObscureNotifier>().isObscure;
    bool isObscureAgain = context.watch<ObscureNotifier>().isObscureAgain;
    final imageAvatar = context.watch<PickerImageNotifier>().fileImage;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: appColor.cardColor,
      appBar: width > webScreenSize ? null : AppBar(
        backgroundColor: Theme.of(context).cardColor,
        title: Text(
          ConstantStrings.register,
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Center(
            child: SizedBox(
              width: (width > webScreenSize) ? 560 : width,
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  ProfilePic(
                    imageAvatar: imageAvatar,
                    funPickAvatar: () => showChoiceImageDialog(
                      context,
                      ConstantStrings.avatar,
                      () async {
                        context
                            .read<PickerImageNotifier>()
                            .pickerImageFile(
                                await pickImageFromGallery(context));
                        if (mounted) {
                          Navigator.pop(context);
                        }
                      },
                      () async {
                        context
                            .read<PickerImageNotifier>()
                            .pickerImageFile(
                                await pickImageFromCamera(context));
                        if (mounted) {
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextFormField(
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                      controller: nameController,
                      decoration: InputDecoration(
                        floatingLabelStyle: TextStyle(
                          color: appColor.canvasColor.withOpacity(0.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: appColor.primaryColor,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: appColor.canvasColor.withOpacity(0.5),
                          ),
                        ),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        labelText: ConstantStrings.name,
                        suffixStyle: TextStyle(color: appColor.primaryColor),
                        labelStyle: TextStyle(
                          color: appColor.canvasColor.withOpacity(0.5),
                        ),
                        hintText: ConstantStrings.hintName,
                        hintStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: appColor.canvasColor.withOpacity(0.5),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty || !RegExp(r"^").hasMatch(value)) {
                          return ConstantStrings.notValidName;
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextFormField(
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                      controller: emailController,
                      decoration: InputDecoration(
                        floatingLabelStyle: TextStyle(
                          color: appColor.canvasColor.withOpacity(0.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: appColor.primaryColor,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: appColor.canvasColor.withOpacity(0.5),
                          ),
                        ),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        labelText: ConstantStrings.email,
                        suffixStyle: TextStyle(color: appColor.primaryColor),
                        labelStyle: TextStyle(
                          color: appColor.canvasColor.withOpacity(0.5),
                        ),
                        hintText: ConstantStrings.hintEmail,
                        hintStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: appColor.canvasColor.withOpacity(0.5),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty || !RegExp(r"^").hasMatch(value)) {
                          return ConstantStrings.notValidEmail;
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextFormField(
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                      controller: passController,
                      obscureText: isObscure,
                      decoration: InputDecoration(
                        floatingLabelStyle: TextStyle(
                          color: appColor.canvasColor.withOpacity(0.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: appColor.primaryColor,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: appColor.canvasColor.withOpacity(0.5),
                          ),
                        ),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        labelText: ConstantStrings.passwordTitle,
                        hintText: ConstantStrings.hintPassword,
                        hintStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                        suffixIcon: IconButton(
                          onPressed: () => updateStatus(),
                          icon: isObscure
                              ? Icon(
                                  Icons.visibility_off,
                                  color: appColor.canvasColor.withOpacity(0.5),
                                )
                              : Icon(
                                  Icons.visibility,
                                  color: appColor.canvasColor.withOpacity(0.5),
                                ),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty || !RegExp(r'').hasMatch(value)) {
                          return ConstantStrings.notValidPassword;
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextFormField(
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                      controller: passAgainController,
                      obscureText: isObscureAgain,
                      decoration: InputDecoration(
                        floatingLabelStyle: TextStyle(
                          color: appColor.canvasColor.withOpacity(0.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: appColor.primaryColor,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: appColor.canvasColor.withOpacity(0.5),
                          ),
                        ),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        labelText: ConstantStrings.againPassword,
                        hintText: ConstantStrings.hintAgainPassword,
                        hintStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                        suffixIcon: IconButton(
                          onPressed: () => updateStatusAgain(),
                          icon: isObscureAgain
                              ? Icon(
                                  Icons.visibility_off,
                                  color: appColor.canvasColor.withOpacity(0.5),
                                )
                              : Icon(
                                  Icons.visibility,
                                  color: appColor.canvasColor.withOpacity(0.5),
                                ),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty || !RegExp(r'^').hasMatch(value)) {
                          return ConstantStrings.notValidPassword;
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextFormField(
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                      controller: bioController,
                      decoration: InputDecoration(
                        floatingLabelStyle: TextStyle(
                          color: appColor.canvasColor.withOpacity(0.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: appColor.primaryColor,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: appColor.canvasColor.withOpacity(0.5),
                          ),
                        ),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        labelText: ConstantStrings.bio,
                        suffixStyle: TextStyle(color: appColor.primaryColor),
                        labelStyle: TextStyle(
                          color: appColor.canvasColor.withOpacity(0.5),
                        ),
                        hintText: ConstantStrings.hintBio,
                        hintStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: appColor.canvasColor.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  BaseButtonFilled(
                    radius: 10,
                    title: ConstantStrings.register,
                    color: appColor.primaryColor,
                    rootContext: context,
                    onTap: () async {
                      bioController.text = 'no bio yet';
                      passController.text = 'Quang@.123';
                      passAgainController.text = 'Quang@.123';
                      if (imageAvatar == null) {
                        showSnackBarWarning(
                          context: context,
                          title: ConstantStrings.notification,
                          message: ConstantStrings.pleasePickImageAvatar,
                        );
                      } else if (formKey.currentState!.validate()) {
                        //save data to FB
                        String res = await UserRepository().signUpUser(
                          context: context,
                          email: emailController.text,
                          password: passController.text,
                          username: nameController.text,
                          bio: bioController.text,
                          imageAvatar: imageAvatar,
                        );
                        if (res == ConstantStrings.success) {
                          showSnackBarSuccess(
                            context: context,
                            title: ConstantStrings.notification,
                            message: res,
                          );
                        } else {
                          showSnackBarFailure(
                            context: context,
                            title: ConstantStrings.notification,
                            message: res,
                          );
                        }
                      }
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        ConstantStrings.haveAccount,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: appColor.canvasColor.withOpacity(0.5),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushReplacementNamed(
                            context,
                            ConstantStringsRoute.routeToLoginScreen,
                          );
                        },
                        child: Text(
                          ConstantStrings.login,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: appColor.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
