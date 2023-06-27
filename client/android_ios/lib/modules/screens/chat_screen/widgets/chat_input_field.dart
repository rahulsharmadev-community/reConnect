import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reConnect/core/firebase_bloc/primary_user_bloc/primary_user_bloc.dart';
import 'package:reConnect/modules/screens/chat_screen/blocs/input_handler_bloc.dart';
import 'package:reConnect/modules/screens/chat_screen/widgets/message_card.dart';
import 'package:shared/shared.dart';

import '../utils/chat_input_services.dart';

class ChatInputField extends StatefulWidget {
  final Function(Message) onSend;
  const ChatInputField({Key? key, required this.onSend}) : super(key: key);

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  onSend() {
    var state = context.read<InputHandlerBloc>().state;
    var message = Message(
      text: context.read<InputUtils>().inputController.text,
      replay: state is ReplyState ? state.message : null,
      senderId: context.read<PrimaryUserBloc>().primaryUser!.userId,
      receiverIds: const [],
      mentionedUserIds: const [],
      status: MessageStatus.sent,
      type: state is ReplyState ? MessageType.reply : MessageType.regular,
    );
    widget.onSend(message);
    context.read<InputHandlerBloc>().add(OnMessageSendHandler(message));
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  get contextStyle => const TextStyle(fontSize: 10);
  get captionStyle => const TextStyle(fontSize: 11);
  @override
  Widget build(BuildContext context) {
    var chatServices = context.read<InputUtils>();
    bool hasInput = chatServices.inputController.text.trim().isNotEmpty;
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                BlocBuilder<InputHandlerBloc, InputHandlerState>(
                  builder: (context, state) {
                    return AnimatedCrossFade(
                      duration: 150.milliseconds,
                      crossFadeState: state is ReplyState
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                      firstChild: state is ReplyState
                          ? buildReplyCard(state.message)
                          : const Offstage(),
                      secondChild: const Offstage(),
                    );
                  },
                ),
                buildInputTextField(context, chatServices),
              ],
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: hasInput ? onSend : () {},
            child: CircleAvatar(
              radius: 24,
              backgroundColor: const Color.fromARGB(255, 71, 100, 167),
              child: Icon(
                hasInput ? Icons.send : Icons.mic,
                size: hasInput ? 26 : 30,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }

  Container buildInputTextField(BuildContext context, InputUtils chatServices) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: 48,
        maxHeight: 150,
      ),
      decoration: const BoxDecoration(
        color: Color(0xff373E4E),
        borderRadius: BorderRadius.all(Radius.circular(28)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 0, 4, 12),
            child: InkResponse(
              onTap: () async {
                await showModalBottomSheet(
                    builder: (ctx) {
                      return Container(
                        height: 350,
                      );
                    },
                    context: context);
              },
              child: const Icon(
                Icons.emoji_emotions,
                size: 26,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: TextFormField(
              controller: chatServices.inputController,
              focusNode: chatServices.inputFocusNode,
              onChanged: (value) => setState(() {}),
              cursorColor: const Color(0xff705cff),
              minLines: 1,
              maxLines: 20,
              scrollPadding: EdgeInsets.zero,
              decoration: const InputDecoration(
                  constraints: BoxConstraints(minHeight: 48, maxHeight: 150),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: Color.fromARGB(255, 190, 190, 190),
                  ),
                  hintText: "Type message here ...",
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  isDense: true),
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(4, 0, 4, 12),
            child: Icon(
              Icons.camera_alt,
              size: 26,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Container buildReplyCard(Message message) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 22),
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      constraints: const BoxConstraints(
          minHeight: 36, maxHeight: 68, minWidth: double.maxFinite),
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 100, 105, 114),
        borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            top: 0,
            child: InkWell(
              child: const CircleAvatar(
                radius: 8,
                backgroundColor: Colors.black45,
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 12,
                ),
              ),
              onTap: () {
                context.read<InputHandlerBloc>().add(OnIdle());
                setState(() {});
              },
            ),
          ),
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Offstage(
                    offstage: false,
                    child: Text(
                      'Rohit',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 11),
                    )),
                const SizedBox(width: 2),
                Text(
                  message.text ?? '',
                  style: contextStyle,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ]),
        ],
      ),
    );
  }
}
