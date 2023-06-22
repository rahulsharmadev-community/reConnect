import 'package:flutter/material.dart';
import 'package:reConnect/modules/screens/chat_screen/chatBloc/chat_handler_bloc.dart';
import 'package:reConnect/modules/screens/chat_screen/chatBloc/input_handler_bloc.dart';
import 'package:reConnect/modules/screens/chat_screen/chatdata.dart';
import 'package:reConnect/modules/screens/chat_screen/utils/chat_services.dart';
import 'package:shared/shared.dart';
import 'widgets/chat_input_field.dart';
import 'widgets/message_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatScreen extends StatelessWidget {
  final String chatRoomId;
  const ChatScreen({super.key, required this.chatRoomId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        RepositoryProvider<ChatServices>(create: (context) => ChatServices()),
        BlocProvider<ChatHandlerBloc>(
            create: (context) =>
                ChatHandlerBloc(chatServices: context.read<ChatServices>())),
        BlocProvider<InputHandlerBloc>(
            create: (context) =>
                InputHandlerBloc(chatServices: context.read<ChatServices>()))
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
  final _batchSize = 15;
  bool _isLoading = false;
  late int itemCount = _batchSize;
  late final ScrollController controller;

  @override
  void initState() {
    super.initState();
    controller = context.read<ChatServices>().chatScrollController;
    controller.addListener(_trackingController);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            var focusNode = context.read<ChatServices>().inputFocusNode;
            if (focusNode.hasFocus) {
              focusNode.unfocus();
              return;
            }
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox.expand(
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 50),
                itemCount: itemCount,
                controller: controller,
                reverse: true,
                itemBuilder: (context, index) {
                  var chat = chats[index];
                  return MessageCard(
                    chat,
                    hideClientName: false,
                    hideClientImg: false,
                    hideMessageStatus: false,
                  );
                },
              ),
            ),
            const Align(
                alignment: Alignment.bottomCenter, child: ChatInputField()),
          ],
        ),
      ),
    );
  }

  void _trackingController() {
    var position = controller.position;
    if (!_isLoading && position.pixels == position.maxScrollExtent) {
      _loadNextBatch();
    }
  }

  void _loadNextBatch() {
    logs('load Next Batch..');
    setState(() {
      _isLoading = true;
    });

    // Simulating loading delay
    Future.delayed(const Duration(seconds: 2), () {
      if (itemCount < chats.length) {
        itemCount += chats.length - itemCount > _batchSize
            ? _batchSize
            : chats.length - itemCount;
      } else {
        logs('Chat Not Available');
      }
      _isLoading = false;
      setState(() {});
    });
  }
}
