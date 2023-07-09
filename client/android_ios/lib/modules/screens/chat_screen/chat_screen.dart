import 'package:flutter/material.dart';
import 'package:reConnect/core/firebase_bloc/primary_user_bloc/primary_user_bloc.dart';
import 'package:reConnect/modules/screens/chat_screen/chat_blocs/chat_service_bloc/chat_service_bloc.dart';
import 'package:reConnect/modules/screens/chat_screen/chat_blocs/input_handler_bloc/input_handler_bloc.dart';
import 'package:reConnect/modules/screens/chat_screen/utils/chat_input_services.dart';
import 'package:reConnect/core/firebase_api/firebase_api.dart';
import 'package:shared/shared.dart';
import 'widgets/chat_display.dart';
import 'widgets/chat_input_field.dart';
import 'widgets/custom_app_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatScreen extends StatelessWidget {
  final String chatRoomId;
  final ChatRoomInfo? chatRoom;
  const ChatScreen({
    super.key,
    required this.chatRoomId,
  }) : chatRoom = null;

  /// Use only in the absence of a chatroomId.
  /// general use when connecting to a new user for the first time.
  ChatScreen.startNewConversation({super.key, required this.chatRoom})
      : chatRoomId = chatRoom!.chatRoomId;

  @override
  Widget build(BuildContext context) {
    var member = chatRoom?.members.firstWhere((e) => e != chatRoom!.createdBy);
    return MultiBlocProvider(
      providers: [
        // It connects a UI action to a database request.
        // for the initial real-time connection to the database.
        // responsible for loading previous messages
        BlocProvider<ChatServiceBloc>(
          create: (context) => ChatServiceBloc(
              chatRoomId: chatRoomId,
              createChatRoom: chatRoom,
              userRepository: UserRepository(member),
              chatRoomsRepository: ChatRoomsRepository(),
              primaryUserBloc: context.read<PrimaryUserBloc>()),
          lazy: false,
        ),

        //  Use this to store the necessary text field input Utils.
        RepositoryProvider<InputUtils>(create: (context) => InputUtils()),

        BlocProvider<InputHandlerBloc>(
            create: (context) => InputHandlerBloc(
                inputUtils: context.read<InputUtils>(),
                chatServiceBloc: context.read<ChatServiceBloc>()))
      ],
      child: const _ChatScreen(),
    );
  }
}

class _ChatScreen extends StatefulWidget {
  const _ChatScreen();
  @override
  State<_ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<_ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(),
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox.expand(
              child: ChatsDisplay(),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ChatInputField(),
            ),
          ],
        ),
      ),
    );
  }
}
