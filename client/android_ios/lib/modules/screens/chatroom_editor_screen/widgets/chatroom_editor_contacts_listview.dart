import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reConnect/modules/screens/chatroom_editor_screen/bloc/cubit/input_handler_cubit.dart';
import 'package:reConnect/modules/widgets/userlisttile.dart';
import 'package:reConnect/utility/extensions.dart';
import 'package:shared/shared.dart';

class ChatroomEditorContactsListView extends StatefulWidget {
  const ChatroomEditorContactsListView({super.key});

  @override
  State<ChatroomEditorContactsListView> createState() =>
      _ChatroomEditorContactsListViewState();
}

class _ChatroomEditorContactsListViewState
    extends State<ChatroomEditorContactsListView> {
  late final TextEditingController searchController;
  Iterable<User> contacts = [];
  @override
  void initState() {
    contacts = context.primaryUser.contacts.values;
    searchController = context.read<InputHandlerCubit>().utils.searchController;
    searchController.addListener(() {
      contacts = context.primaryUser.contacts.values.where((element) => element
          .name
          .toLowerCase()
          .contains(searchController.text.toLowerCase()));
      if (mounted) setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InputHandlerCubit, InputHandlerCubitState>(
      builder: (c, s) => SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, i) {
            return i == 0
                ? userListTile(
                    pinMe: true,
                    role: ChatRoomRole.administrators,
                    user: User.fromMap(context.primaryUser.toMap))
                : userListTile(
                    role: role(s, contacts.elementAt(i - 1).userId),
                    user: contacts.elementAt(i - 1));
          },
          childCount: contacts.length + 1,
        ),
      ),
    );
  }

  ChatRoomRole? role(InputHandlerCubitState state, String userId) {
    return state.administrators.contains(userId)
        ? ChatRoomRole.administrators
        : state.members.contains(userId)
            ? ChatRoomRole.members
            : state.moderators.contains(userId)
                ? ChatRoomRole.moderators
                : state.visitors.contains(userId)
                    ? ChatRoomRole.visitor
                    : null;
  }

  userListTile({required User user, ChatRoomRole? role, bool pinMe = false}) {
    var additionText = pinMe ? '(me)' : '';
    var cubit = context.watch<InputHandlerCubit>();
    return UserListTile(
      name: user.name + additionText,
      subtitle: (role != null)
          ? Text(
              role.name,
              style: TextStyle(
                fontSize: 12,
                color: role.color,
              ),
            )
          : null,
      profileImg: user.profileImg,
      trailing: pinMe
          ? null
          : PopupMenuButton(
              splashRadius: 4,
              offset: const Offset(-10, 10),
              clipBehavior: Clip.hardEdge,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.more_vert),
              itemBuilder: (_) => ChatRoomRole.values
                  .map(
                    (e) => PopupMenuItem(
                      height: 42,
                      onTap: () {
                        if (role == e) {
                          cubit.removeFrom(userId: user.userId);
                        } else {
                          cubit.addTo(role: e, userId: user.userId);
                        }
                      },
                      padding: EdgeInsets.zero,
                      child: ListTile(
                        dense: true,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 12),
                        tileColor: role == e ? Colors.white12 : null,
                        leading: SvgPicture.asset(
                          e.svgPath,
                          colorFilter:
                              ColorFilter.mode(e.color, BlendMode.srcIn),
                          height: 18,
                        ),
                        title: Text(
                          e.name,
                          style: TextStyle(color: e.color),
                        ),
                        trailing: role == e ? const Icon(Icons.close) : null,
                      ),
                    ),
                  )
                  .toList(),
            ),
    );
  }
}
