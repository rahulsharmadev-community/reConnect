import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reConnect/modules/screens/chat_screen/chat_blocs/chat_service_bloc/chat_service_bloc.dart';
import 'package:reConnect/modules/screens/chat_screen/utils/chat_input_services.dart';
import 'package:reConnect/modules/screens/chat_screen/widgets/message_card.dart';
import 'package:reConnect/modules/screens/other_screens/loading_screen.dart';

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
            var data = (state as ChatRoomConnected);
            return ListView.builder(
              padding: const EdgeInsets.only(bottom: 50),
              itemCount: data.messages.length,
              controller: context.read<InputUtils>().chatScrollController,
              reverse: true,
              itemBuilder: (context, index) {
                return MessageCard(
                  data.messages[index],
                  hideClientName: false,
                  hideClientImg: false,
                  hideMessageStatus: false,
                );
              },
            );
          case ChatRoomNotFound:
            return const Center(
              child: Text(
                'Chat Room Not Found\n Start Chating Now',
                textAlign: TextAlign.center,
              ),
            );
          default:
            return const LoadingScreen(false);
        }
      },
    );
  }
}
