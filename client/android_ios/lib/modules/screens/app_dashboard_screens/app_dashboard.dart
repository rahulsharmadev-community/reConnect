import 'package:flutter/material.dart';

import 'package:reConnect/modules/screens/app_dashboard_screens/chats_dashboard/chats_dashboard.dart';
import 'package:reConnect/modules/screens/app_dashboard_screens/status_dashboard/status_dashboard.dart';
import 'package:reConnect/utility/navigation/app_navigator.dart';
import 'package:reConnect/utility/routes/app_router.dart';

/// AppDashBoard Screen
class AppDashBoard extends StatelessWidget {
  final int initialPageIndex;
  const AppDashBoard({super.key, required this.initialPageIndex});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: initialPageIndex,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('reConnect'),
          actions: [
            IconButton(
                icon: const Icon(Icons.search),
                onPressed: () => AppNavigator.on((router) =>
                    router.pushNamed(AppRoutes.UserSearchScreen.name))),
            IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () => AppNavigator.on((router) =>
                    router.pushNamed(AppRoutes.SettingsScreen.name)))
          ],
          bottom: bottomTabBar(),
        ),
        body: const TabBarView(
          children: [ChatsDashBoardScreen(), StatusDashBoardScreen()],
        ),
      ),
    );
  }

  TabBar bottomTabBar() {
    return const TabBar(
      tabs: [
        Tab(
            child: Badge(
          label: Text('4'),
          offset: Offset(12, -4),
          child: Text('Chats'),
        )),
        Tab(
            child: Badge(
          label: Text('New'),
          offset: Offset(12, -4),
          child: Text('Status'),
        )),
      ],
    );
  }
}
