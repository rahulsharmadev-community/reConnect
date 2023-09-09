import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jars/jars.dart';
import 'package:reConnect/modules/screens/chat_screen/chat_blocs/chat_service_bloc/chat_service_bloc.dart';
import 'package:reConnect/modules/screens/chat_screen/chat_blocs/input_handler_bloc/input_handler_bloc.dart';
import 'package:reConnect/modules/screens/chat_screen/utils/chat_input_services.dart';
import 'package:reConnect/modules/screens/chat_screen/widgets/message_card/message_card.dart';
import 'package:reConnect/modules/screens/other_screens/loading_screen.dart';
import 'package:reConnect/utility/extensions.dart';
import 'package:shared/shared.dart';

class ChatsDisplay extends StatelessWidget {
  const ChatsDisplay({super.key});

  List<Widget> createList(BuildContext context, List<Message> msgs) {
    var ls = <Widget>[];
    for (int i = 0; i < msgs.length; i++) {
      var isClient = msgs[i].senderId != context.primaryUser.userId;
      ls.add(Dismissible(
        key: Key(msgs[i].messageId),
        direction: isClient
            ? DismissDirection.startToEnd
            : i == 0
                ? DismissDirection.none
                : DismissDirection.endToStart,
        confirmDismiss: (direction) async {
          context.read<InputHandlerBloc>().add(OnReplyHandler.add(msgs[i]));
          return false;
        },
        child: MessageCard(
          msgs[i],
          key: Key(msgs[i].messageId),
          isForClient: isClient,
        ),
      ));
    }
    return ls;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatServiceBloc, ChatServiceState>(
      listener: (context, state) {
        if (state is ChatRoomConnected && state.alertMessage != null) {
          showJSnackBar(context,
              config: JSnackbarConfig(
                Text(state.alertMessage!),
              ));
        }
      },
      builder: (context, state) {
        switch (state.runtimeType) {
          case ChatRoomConnected:
            final msgs = (state as ChatRoomConnected).messages;
            final ls = createList(context, msgs);
            return ListView.builder(
              padding: const EdgeInsets.only(bottom: 50),
              itemCount: ls.length,
              controller: context.read<InputUtils>().chatScrollController,
              reverse: true,
              itemBuilder: (context, i) => ls[i],
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
