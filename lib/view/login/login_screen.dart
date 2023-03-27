import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:ins_flutter/constant/component/setup/dimension.dart';
import 'package:ins_flutter/constant/string.dart';
import 'package:ins_flutter/constant/component/widget/snackbar.dart';
import 'package:ins_flutter/data/repository/user_repository.dart';
import 'package:ins_flutter/view/home/provider/user_provider.dart';
import 'package:ins_flutter/view/home/responsive_layout.dart';
import 'package:ins_flutter/view/home/widget/mobile_layout.dart';
import 'package:ins_flutter/view/home/widget/web_layout.dart';
import 'package:provider/provider.dart';

import '../../constant/provider/obscure_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    FlutterNativeSplash.remove();
    super.initState();
  }

  final formKey = GlobalKey<FormState>();
  TextEditingController passController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  void updateStatus() {
    context.read<ObscureProvider>().updateObscure();
  }

  moveToHome(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      context.read<ObscureProvider>().setLoadingStatus(true);
      String res = await UserRepository().loginUser(
        email: emailController.text,
        password: passController.text,
      );
      if (res == ConstantStrings.success) {
        if (mounted) {
          context.read<UserProvider>().refreshUser();
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const ResponsiveLayout(
                  webLayout: WebLayout(),
                  mobileLayout: MobileLayout(),
                ),
              ),
              (route) => false);
          context.read<ObscureProvider>().setLoadingStatus(false);
        }
      } else {
        if (mounted) {
          context.read<ObscureProvider>().setLoadingStatus(false);
          showSnackBarWarning(
            context: context,
            title: ConstantStrings.notification,
            message: res,
          );
        }
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appColor = Theme.of(context);
    bool isObscure = context.watch<ObscureProvider>().isObscure;
    bool isLoading = context.watch<ObscureProvider>().changeStatusLoading;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: appColor.cardColor,
      resizeToAvoidBottomInset: false,
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Center(
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: SizedBox(
                  width: (width > webScreenSize) ? 500 : width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Image(
                        image: AssetImage('assets/images/logo.png'),
                        height: 144,
                        width: 144,
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
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
                                      color:
                                          appColor.canvasColor.withOpacity(0.5),
                                    )
                                  : Icon(
                                      Icons.visibility,
                                      color:
                                          appColor.canvasColor.withOpacity(0.5),
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
                      const SizedBox(
                        height: 16,
                      ),
                      //Custom button login animation by Quang Pham
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Material(
                          color: appColor.primaryColor,
                          borderRadius: BorderRadius.circular(10),
                          child: InkWell(
                            onTap: () => moveToHome(context),
                            child: Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width - 32,
                              alignment: Alignment.center,
                              child: isLoading
                                  ? SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        color: appColor.cardColor,
                                      ),
                                    )
                                  : Text(
                                      ConstantStrings.login,
                                      style: TextStyle(
                                        color: appColor.cardColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: InkWell(
                          child: Text(
                            ConstantStrings.forgotPassword,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: appColor.canvasColor.withOpacity(0.5),
                            ),
                          ),
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 32,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  ConstantStrings.notAccount,
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
                      ConstantStringsRoute.routeToRegisterScreen,
                    );
                  },
                  child: Text(
                    ConstantStrings.register,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: appColor.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
