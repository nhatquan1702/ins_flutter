import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:ins_flutter/constant/string.dart';
import 'package:ins_flutter/view/home/provider/home_tab_provider.dart';
import 'package:provider/provider.dart';

import 'home_item.dart';

class MobileLayout extends StatefulWidget with WidgetsBindingObserver {
  const MobileLayout({Key? key}) : super(key: key);

  @override
  State<MobileLayout> createState() => _MobileLayoutState();
}

class _MobileLayoutState extends State<MobileLayout> {
  @override
  void initState() {
    FlutterNativeSplash.remove();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final int selectedIndex =
        context.watch<SelectedHomeTapNotifier>().selectedIndex;
    final theme = Theme.of(context);

    return Container(
      color: theme.cardColor,
      child: DefaultTabController(
        length: 5,
        child: Scaffold(
          backgroundColor: theme.cardColor,
          body: Center(
            child: widgetOptions.elementAt(selectedIndex),
          ),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: theme.cardColor,
            elevation: 5,
            selectedFontSize: 16,
            unselectedFontSize: 16,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: const Icon(Icons.feed),
                label: ConstantStrings.feed,
                backgroundColor: theme.cardColor,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.search),
                label: ConstantStrings.search,
                backgroundColor: theme.cardColor,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.add_circle),
                label: ConstantStrings.addPost,
                backgroundColor: theme.cardColor,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.notifications),
                label: ConstantStrings.notification,
                backgroundColor: theme.cardColor
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.person),
                label: ConstantStrings.account,
                backgroundColor: theme.cardColor,
              ),
            ],
            selectedItemColor: theme.primaryColor,
            unselectedItemColor: theme.canvasColor.withOpacity(0.6),
            currentIndex: selectedIndex,
            onTap: (int index) =>
                context.read<SelectedHomeTapNotifier>().onItemTapped(index),
          ),
        ),
      ),
    );
  }
}
