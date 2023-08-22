import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reConnect/modules/screens/chat_screen/chat_blocs/chat_service_bloc/chat_service_bloc.dart';
import 'package:reConnect/modules/screens/chat_screen/chat_blocs/input_handler_bloc/input_handler_bloc.dart';
import 'package:reConnect/modules/screens/chat_screen/utils/chat_input_services.dart';
import 'package:reConnect/modules/screens/chat_screen/widgets/message_card/message_card.dart';
import 'package:reConnect/modules/screens/other_screens/loading_screen.dart';
import 'package:reConnect/utility/extensions.dart';

class ChatsDisplay extends StatelessWidget {
  const ChatsDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatServiceBloc, ChatServiceState>(
      listener: (context, state) {
        if (state is ChatRoomConnected && state.alertMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.alertMessage!),
          ));
        }
      },
      builder: (context, state) {
        switch (state.runtimeType) {
          case ChatRoomConnected:
            var msgs = (state as ChatRoomConnected).messages;
            return ListView.builder(
              padding: const EdgeInsets.only(bottom: 50),
              itemCount: msgs.length,
              controller: context.read<InputUtils>().chatScrollController,
              reverse: true,
              itemBuilder: (context, i) {
                var msg = msgs[i];
                return Dismissible(
                    key: Key(msg.messageId),
                    direction: msg.senderId != context.primaryUser.userId
                        ? DismissDirection.startToEnd
                        : msg.messageId == msgs.first.messageId
                            ? DismissDirection.none
                            : DismissDirection.endToStart,
                    confirmDismiss: (direction) async {
                      context
                          .read<InputHandlerBloc>()
                          .add(OnReplyHandler.add(msg));
                      return false;
                    },
                    child: MessageCard(msgs[i]));
              },
            );
          case ChatRoomNotFound:
            return chatRoomNotFound();
          default:
            return const LoadingScreen();
        }
      },
    );
  }

  Center chatRoomNotFound() => const Center(
        child: Text(
          'Chat Room Not Found\n Start Chating Now',
          textAlign: TextAlign.center,
        ),
      );
}
