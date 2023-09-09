import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jars/jars.dart';
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
          showJSnackBar(
            context,
            config: JSnackbarConfig(Text(state.alertMessage!)),
          );
        }
      },
      builder: (context, state) {
        switch (state.runtimeType) {
          case ChatRoomConnected:
            return onChatRoomConnected(context);
          case ChatRoomNotFound:
            return onChatRoomNotFound();
          default:
            return const LoadingScreen();
        }
      },
    );
  }

  Widget onChatRoomConnected(BuildContext context) {
    var msgs = context.read<ChatServiceBloc>().messages;

    return ListView.builder(
      reverse: true,
      itemCount: msgs.length,
      padding: const EdgeInsets.only(bottom: 50),
      controller: context.read<InputUtils>().chatScrollController,
      itemBuilder: (context, i) {
        var isLastClient = msgs[i].senderId != context.primaryUser.userId;

        return MessageCard(
          msgs[i],
          key: Key(msgs[i].messageId),
          isForClient: isLastClient,
          isLastMsg: i == 0,
          confirmDismiss: (direction) async {
            var bloc = context.read<InputHandlerBloc>();
            bloc.add(OnReplyHandler.add(msgs[i]));
            return false;
          },
        );
      },
    );
  }

  Center onChatRoomNotFound() {
    return const Center(
      child: Text(
        'Chat Room Not Found\n Start Chating Now',
        textAlign: TextAlign.center,
      ),
    );
  }
}
