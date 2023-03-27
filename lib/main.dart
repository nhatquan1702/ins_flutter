import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:ins_flutter/constant/component/widget/loading_widget.dart';
import 'package:ins_flutter/constant/string.dart';
import 'package:ins_flutter/view/comment/provider/comment_provider.dart';
import 'package:ins_flutter/view/feed_video/provider/video_provider.dart';
import 'package:ins_flutter/view/home/provider/home_tab_provider.dart';
import 'package:ins_flutter/view/feed_image/provider/post_provider.dart';
import 'package:ins_flutter/view/home/provider/user_provider.dart';
import 'package:ins_flutter/view/login/login_screen.dart';
import 'package:ins_flutter/constant/provider/picker_image_provider.dart';
import 'package:provider/provider.dart';
import 'constant/route/route.dart';
import 'constant/theme.dart';
import 'constant/provider/image_storage_provider.dart';
import 'firebase_options.dart';
import 'view/account/provider/follow_provider.dart';
import 'constant/provider/obscure_provider.dart';
import 'view/home/responsive_layout.dart';
import 'view/home/widget/mobile_layout.dart';
import 'view/home/widget/web_layout.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PickerImageProvider()),
        ChangeNotifierProvider(create: (_) => ObscureProvider()),
        ChangeNotifierProvider(create: (_) => SelectedHomeTapProvider()),
        ChangeNotifierProvider(
          create: (_) => FirebaseStorageProvider(
            firebaseStorage: FirebaseStorage.instance,
          ),
        ),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => FollowProvider()),
        ChangeNotifierProvider(create: (_) => PostProvider()),
        ChangeNotifierProvider(create: (_) => VideoProvider()),
        ChangeNotifierProvider(create: (_) => CommentProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: ConstantStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(context),
      darkTheme: AppTheme.darkTheme(context),
      onGenerateRoute: (settings) => generateRoute(settings),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.data == null) {
              return const LoginScreen();
            }
            if (snapshot.hasData) {
              return const ResponsiveLayout(
                mobileLayout: MobileLayout(),
                webLayout: WebLayout(),
              );
            } else if (snapshot.hasError) {
              return Scaffold(
                body: Center(
                  child: Text('${snapshot.error}'),
                ),
              );
            }
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            if (snapshot.data == null) {
              return const LoginScreen();
            }
            return Scaffold(body: const LoadingWidget());
          }

          if (snapshot.data!.email == null) {
            return const LoginScreen();
          }
          return const LoginScreen();
        },
      ),
    );
  }
}
