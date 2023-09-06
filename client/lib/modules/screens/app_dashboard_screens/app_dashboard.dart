import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reConnect/core/BLOCs/primary_user_bloc/primary_user_bloc.dart';
import 'package:reConnect/modules/screens/app_dashboard_screens/bloc/room_tile_selector_bloc.dart';
import 'package:reConnect/modules/screens/app_dashboard_screens/chats_dashboard/chats_dashboard.dart';
import 'package:reConnect/modules/screens/app_dashboard_screens/status_dashboard/status_dashboard.dart';
import 'package:reConnect/utility/extensions.dart';
import 'package:reConnect/utility/routes/app_routes.dart';

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
  const _CustomAppBar();

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

  List<PopupMenuEntry> get menuList => [
        PopupMenuItem(
            onTap: () => AppRoutes.ChatroomEditorScreen.pushNamed(
                pathParameters: {'id': 'new'}),
            child: const Row(children: [
              Icon(Icons.group_add),
              SizedBox(width: 8),
              Text('New group')
            ])),
        PopupMenuItem(
            onTap: () {},
            child: const Row(children: [
              Icon(Icons.devices_rounded),
              SizedBox(width: 8),
              Text('Linked devices')
            ])),
        PopupMenuItem(
            onTap: AppRoutes.SettingsScreen.pushNamed,
            child: const Row(children: [
              Icon(Icons.settings),
              SizedBox(width: 8),
              Text('Settings')
            ])),
      ];
  @override
  Row build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: AppRoutes.UserSearchScreen.pushNamed,
      ),
      PopupMenuButton(
        itemBuilder: (_) => menuList,
        shape: context.decoration.roundedBorder(8),
        icon: const Icon(Icons.more_vert),
      )
    ]);
  }
}

class SelectActionsWidgets extends StatelessWidget {
  const SelectActionsWidgets({super.key});

  @override
  Row build(BuildContext context) {
    var primaryUser = context.read<PrimaryUserBloc>().primaryUser!;
    var selectedIds = context.read<ChatRoomTileSelectorCubit>().chatroomIds;
    var allIds = primaryUser.chatRooms.keys;
    var selectedRoom =
        selectedIds.map((id) => primaryUser.chatRooms[id]!).toList();

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
