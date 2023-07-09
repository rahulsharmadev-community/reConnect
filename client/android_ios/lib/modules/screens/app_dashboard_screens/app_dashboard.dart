import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reConnect/core/firebase_bloc/primary_user_bloc/primary_user_bloc.dart';
import 'package:reConnect/modules/screens/app_dashboard_screens/bloc/room_tile_selector_bloc.dart';

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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (BuildContext context) =>
                ChatRoomTileSelectorCubit(context.read<PrimaryUserBloc>()))
      ],
      child: DefaultTabController(
        initialIndex: initialPageIndex,
        length: 2,
        child: const Scaffold(
          appBar: _CustomAppBar(),
          body: TabBarView(
            children: [ChatsDashBoardScreen(), StatusDashBoardScreen()],
          ),
        ),
      ),
    );
  }
}

class _CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _CustomAppBar({super.key});

  @override
  get preferredSize => const Size.fromHeight(kToolbarHeight + 24);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatRoomTileSelectorCubit, ChatRoomTileState>(
      builder: (context, state) {
        bool isSelected = state is ChatRoomTileSelected;

        return AppBar(
          title: Text(isSelected ? '${state.chatroomIds.length}' : 'reConnect'),
          leading: isSelected
              ? BackButton(
                  onPressed: () =>
                      context.read<ChatRoomTileSelectorCubit>().unSelectAll())
              : null,
          actions: isSelected
              ? [const SelectActionsWidgets()]
              : [const UnSelectActionsWidgets()],
          bottom: bottomTabBar(),
        );
      },
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

class UnSelectActionsWidgets extends StatelessWidget {
  const UnSelectActionsWidgets({super.key});

  @override
  Row build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      IconButton(
          icon: const Icon(Icons.search),
          onPressed: () => AppNavigator.on(
              (router) => router.pushNamed(AppRoutes.UserSearchScreen.name))),
      IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () => AppNavigator.on(
              (router) => router.pushNamed(AppRoutes.SettingsScreen.name)))
    ]);
  }
}

class SelectActionsWidgets extends StatelessWidget {
  const SelectActionsWidgets({super.key});

  @override
  Row build(BuildContext context) {
    var primaryUser = context.read<PrimaryUserBloc>().primaryUser!;
    var selectedIds = context.read<ChatRoomTileSelectorCubit>().chatroomIds;
    var allIds = primaryUser.chatRooms.map((e) => e.chatRoomId).toList();
    var selectedRoom = selectedIds.map((id) {
      return primaryUser.chatRooms.firstWhere((e) => e.chatRoomId == id);
    }).toList();
    return Row(mainAxisSize: MainAxisSize.min, children: [
      IconButton(icon: const Icon(Icons.push_pin), onPressed: () => {}),
      IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            context.read<ChatRoomTileSelectorCubit>().removeRooms(selectedRoom);
          }),
      IconButton(icon: const Icon(Icons.volume_off), onPressed: () => {}),
      IconButton(
          icon: const Icon(Icons.checklist),
          onPressed: () =>
              context.read<ChatRoomTileSelectorCubit>().selectRooms(allIds))
    ]);
  }
}
