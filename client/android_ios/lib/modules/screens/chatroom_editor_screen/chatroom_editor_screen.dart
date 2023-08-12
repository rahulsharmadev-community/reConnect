// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reConnect/core/APIs/firebase_api/firebase_api.dart';
import 'package:reConnect/core/BLOCs/primary_user_bloc/primary_user_bloc.dart';
import 'package:reConnect/modules/screens/chatroom_editor_screen/widgets/chatroom_editor_appbar.dart';
import 'package:reConnect/modules/screens/chatroom_editor_screen/widgets/chatroom_editor_contacts_listview.dart';
import 'package:reConnect/modules/widgets/anim_slidingbutton.dart';
import 'bloc/cubit/input_handler_cubit.dart';
import 'bloc/input_utils.dart';
import 'package:reConnect/utility/extensions.dart';
import 'package:shared/shared.dart';

class ChatroomEditorScreen extends StatelessWidget {
  final ChatRoomInfo? initRoom;
  get isEditing => initRoom != null;
  const ChatroomEditorScreen({super.key, this.initRoom});

  @override
  Widget build(BuildContext context) {
    final utils = ChatRoomEditorInputUtils();
    return BlocProvider(
      create: (_) {
        return InputHandlerCubit(
            utils: utils,
            isEditing: isEditing,
            primaryUserBloc: context.read<PrimaryUserBloc>(),
            chatRoomsApi: ChatRoomsApi())
          ..addTo(
              role: ChatRoomRole.administrators,
              userId: context.primaryUser.userId);
      },
      child: Scaffold(
        floatingActionButton: Padding(
          padding: const EdgeInsets.fromLTRB(32, 0, 0, 0),
          child: AnimSearchBar(
            textController: utils.searchController,
          ),
        ),
        body: CustomScrollView(
          slivers: [
            ChatroomEditorAppBar(),
            ChatroomEditorContactsListView(),
          ],
        ),
      ),
    );
  }
}
