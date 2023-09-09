import 'package:flutter/material.dart';
import 'package:reConnect/addition.dart';
import 'package:reConnect/core/APIs/github_api/github_repository_api.dart';
import 'package:reConnect/modules/screens/chat_screen/chat_blocs/chat_service_bloc/chat_service_bloc.dart';
import 'package:reConnect/modules/screens/chat_screen/chat_blocs/input_handler_bloc/input_handler_bloc.dart';
import 'package:shared/utility/src/inner_routing.dart';
import 'package:reConnect/modules/screens/chat_screen/utils/chat_input_services.dart';
import 'package:reConnect/utility/extensions.dart';
import 'package:shared/shared.dart';
import 'widgets/chat_display.dart';
import 'widgets/chat_input_field.dart';
import 'widgets/chat_app_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatScreen extends StatelessWidget {
  final String chatroomId;
  const ChatScreen({
    super.key,
    required this.chatroomId,
  });
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // It connects a UI action to a database request.
        // for the initial real-time connection to the database.
        // responsible for loading previous messages
        BlocProvider<ChatServiceBloc>(
          create: (context) {
            return ChatServiceBloc(
                chatroomId: chatroomId,
                primaryUser: context.primaryUser,
                gitHubRepositorysApi: GitHubRepositorysApi());
          },
          lazy: false,
        ),

        //  Use this to store the necessary text field input Utils.
        RepositoryProvider<InputUtils>(create: (context) => InputUtils()),

        BlocProvider<InputHandlerBloc>(
            create: (context) => InputHandlerBloc(
                initalMsg: Message(senderId: context.primaryUser.userId),
                inputUtils: context.read<InputUtils>(),
                chatServiceBloc: context.read<ChatServiceBloc>())),

        RepositoryProvider<InnerRouting>(
          create: (context) => InnerRouting(),
        ),
      ],
      child: BlocBuilder<InnerRouting, InnerRoutes>(
        builder: (context, state) {
          return Stack(
            fit: StackFit.expand,
            children: [
              const _ChatScreen(),
              ...state.values.toList(),
            ],
          );
        },
      ),
    );
  }
}

class _ChatScreen extends StatelessWidget {
  const _ChatScreen();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ChatAppBar(),
      body: SafeArea(
        child: Stack(
          children: [
            const ChatsDisplay().expandBox(),
            const ChatInputField().align.bottomCenter(),
          ],
        ),
      ),
    );
  }
}
