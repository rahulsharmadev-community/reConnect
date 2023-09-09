import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jars/jars.dart';
import 'package:reConnect/core/BLOCs/primary_user_bloc/primary_user_bloc.dart';
import 'package:reConnect/modules/widgets/userlisttile.dart';
import 'package:reConnect/utility/routes/app_routes.dart';
import '../bloc/room_tile_selector_bloc.dart';

class ChatsDashBoardScreen extends StatefulWidget {
  const ChatsDashBoardScreen({super.key});

  @override
  State<ChatsDashBoardScreen> createState() => _ChatsDashBoardScreenState();
}

class _ChatsDashBoardScreenState extends State<ChatsDashBoardScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrimaryUserBloc, PrimaryUserState>(
      builder: (context, state) {
        final chatRooms = (state as PrimaryUserLoaded).primaryUser.chatRooms;
        final primaryUserId = state.primaryUser.userId;
        return ListView.separated(
          itemCount: chatRooms.length,
          separatorBuilder: (context, i) => const Divider(),
          itemBuilder: (context, i) {
            final room = chatRooms.values.elementAt(i);
            var isDual = room.isOneToOne;
            final member = isDual
                ? state.primaryUser.contacts[room.members[0] != primaryUserId
                    ? room.members[0]
                    : room.members[1]]
                : null;
            final cubit = context.read<ChatRoomTileSelectorCubit>();
            return BlocBuilder<ChatRoomTileSelectorCubit, ChatRoomTileState>(
              builder: (context, state) {
                var isSelected = false;
                if (state is ChatRoomTileSelected) {
                  isSelected = state.chatroomIds.contains(room.chatRoomId);
                }
                Text? dateText = (isDual && member?.lastActiveAt != null)
                    ? Text(member!.lastActiveAt!.format().yMMd())
                    : null;
                var titleText = isDual ? member!.name : room.name!;
                var profileUrl = isDual ? member!.profileImg : room.profileImg;

                var subTitle = isDual
                    ? (member!.lastMessage ?? member.about ?? 'Send Invite')
                    : room.lastMessage?.text;
                return Stack(
                  children: [
                    UserListTile(
                      name: titleText,
                      profileImg: profileUrl,
                      sweetTrailing: dateText,
                      subtitle: subTitle != null
                          ? Text(subTitle,
                              maxLines: 2, overflow: TextOverflow.ellipsis)
                          : null,
                      onTap: () {
                        isSelected
                            ? cubit.unSelectRooms([room.chatRoomId])
                            : AppRoutes.ChatScreen.pushNamed(extra: room.chatRoomId);
                      },
                      onTapHold: () {
                        isSelected
                            ? cubit.unSelectRooms([room.chatRoomId])
                            : cubit.selectRooms([room.chatRoomId]);
                      },
                    ),
                    if (isSelected) buildCheck()
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  Positioned buildCheck() {
    return const Positioned(
      bottom: 8,
      left: 48,
      child: CircleAvatar(
        backgroundColor: Colors.white,
        radius: 13,
        child: Icon(
          Icons.check_circle,
          size: 24,
          color: Colors.green,
        ),
      ),
    );
  }
}
