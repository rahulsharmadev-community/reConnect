import 'package:flutter/material.dart';
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
      itemBuilder: (context, index) => listTile(list[index]),
    );
  }

  ListTile listTile(User user) {
    return ListTile(
      onTap: () => AppNavigator.on((router) => router.pushNamed(
          AppRoutes.ChatScreen.name,
          pathParameters: {'chatRoomId': ''})),
      leading: const CircleAvatar(
        radius: 26,
      ),
      contentPadding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
      title: Row(children: [
        Expanded(
          child: Text(user.name),
        ),
        if (user.lastActive != null)
          Text(DateTimeFormat(user.lastActive!).yMMd())
      ]),
      subtitle: Text(
        user.lastMessage ?? user.about ?? 'Send Invite',
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
