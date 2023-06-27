import 'package:flutter/material.dart';
import 'package:reConnect/modules/widgets/userlisttile.dart';
import 'package:reConnect/utility/navigation/app_navigator.dart';
import 'package:reConnect/utility/routes/app_router.dart';
import 'package:shared/shared.dart';

class ChatsDashBoardScreen extends StatelessWidget {
  const ChatsDashBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<User> list = [];
    return ListView.separated(
      itemCount: list.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, i) => UserListTile(
        name: list[i].name,
        profileImg: list[i].profileImg,
        sweetTrailing: Text(DateTimeFormat(list[i].lastActiveAt!).yMMd()),
        subtitle: Text(
          list[i].lastMessage ?? list[i].about ?? 'Send Invite',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        onTap: () => AppNavigator.on((router) => router.pushNamed(
            AppRoutes.ChatScreen.name,
            pathParameters: {'chatRoomId': ''})),
      ),
    );
  }
}
