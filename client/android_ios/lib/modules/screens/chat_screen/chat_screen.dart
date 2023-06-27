import 'package:flutter/material.dart';
import 'package:reConnect/modules/screens/chat_screen/blocs/input_handler_bloc.dart';
import 'package:reConnect/modules/screens/chat_screen/utils/chat_input_services.dart';
import 'package:reConnect/modules/screens/other_screens/loading_screen.dart';
import 'blocs/chat_service_bloc/chat_service_bloc.dart';
import 'package:shared/shared.dart';
import 'package:uuid/uuid.dart';
import 'widgets/chat_display.dart';
import 'widgets/chat_input_field.dart';
import 'widgets/custom_app_bar.dart';
import 'widgets/message_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatScreen extends StatelessWidget {
  final String chatRoomId;

  const ChatScreen({
    super.key,
    required this.chatRoomId,
  });

  /// Use only in the absence of a chatroomId.
  /// general use when connecting to a new user for the first time.
  ChatScreen.startNewConversation({super.key}) : chatRoomId = const Uuid().v4();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // It connects a UI action to a database request.
        // for the initial real-time connection to the database.
        // responsible for loading previous messages
        BlocProvider<ChatServiceBloc>(
          create: (context) => ChatServiceBloc(chatRoomId),
          lazy: false,
        ),

        //  Use this to store the necessary text field input Utils.
        RepositoryProvider<InputUtils>(create: (context) => InputUtils()),
        BlocProvider<InputHandlerBloc>(
            create: (context) =>
                InputHandlerBloc(inputUtils: context.read<InputUtils>()))
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
  late final ScrollController controller;

  @override
  void initState() {
    super.initState();
    controller = context.read<InputUtils>().chatScrollController;
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
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: Stack(
          children: [
            const SizedBox.expand(
              child: ChatsDisplay(),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: ChatInputField(
                  onSend: (p0) =>
                      context.read<ChatServiceBloc>().add(AddNewMessage(p0)),
                )),
          ],
        ),
      ),
    );
  }

  void _trackingController() {
    var position = controller.position;
    if (position.pixels == position.maxScrollExtent) {
      _loadNextBatch();
    }
  }

  void _loadNextBatch() {
    logs('load Next Batch..');
    context.read<ChatServiceBloc>().add(FetchHistoryMessages());
  }
}
