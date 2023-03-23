import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:ins_flutter/constant/component/widget/loading_widget.dart';
import 'package:ins_flutter/constant/responsive/mobile_layout.dart';
import 'package:ins_flutter/constant/responsive/web_layout.dart';
import 'package:ins_flutter/constant/string.dart';
import 'package:ins_flutter/view/home/comment/provider/comment_provider.dart';
import 'package:ins_flutter/view/home/provider/home_tab_provider.dart';
import 'package:ins_flutter/view/home/provider/post_provider.dart';
import 'package:ins_flutter/view/home/provider/user_provider.dart';
import 'package:ins_flutter/view/login/login_screen.dart';
import 'package:ins_flutter/view/register/provider/picker_avatar_provider.dart';
import 'package:provider/provider.dart';
import 'constant/responsive/responsive_layout.dart';
import 'constant/route/route.dart';
import 'constant/theme.dart';
import 'constant/provider/image_storage_provider.dart';
import 'firebase_options.dart';
import 'view/home/provider/follow_provider.dart';
import 'view/login/provider/obscure_provider.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PickerImageNotifier()),
        ChangeNotifierProvider(create: (_) => ObscureNotifier()),
        ChangeNotifierProvider(create: (_) => SelectedHomeTapNotifier()),
        ChangeNotifierProvider(
          create: (_) => FirebaseStorageRepository(
            firebaseStorage: FirebaseStorage.instance,
          ),
        ),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => FollowNotifier()),
        ChangeNotifierProvider(create: (_) => PostNotifier()),
        ChangeNotifierProvider(create: (_) => CommentNotifier()),
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
