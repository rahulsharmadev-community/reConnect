import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reConnect/modules/screens/chat_screen/chatBloc/chat_handler_bloc.dart';
import 'package:reConnect/modules/screens/chat_screen/chatBloc/input_handler_bloc.dart';
import 'package:shared/shared.dart';

// Demo login user id
const logInUser = 'df52fdf3b6725e4af2da';

class MessageCard extends StatelessWidget {
  const MessageCard(
    this.message, {
    Key? key,
    required this.hideClientName,
    required this.hideClientImg,
    required this.hideMessageStatus,
  }) : super(key: key);
  final Message message;

  final bool hideClientName;
  final bool hideClientImg;
  final bool hideMessageStatus;

  messageBorderRadius(
          {bool isTopLeft = false,
          bool isbottomRight = false,
          double curved = 18}) =>
      BorderRadius.only(
        topLeft: Radius.circular(isTopLeft ? 2 : curved),
        topRight: Radius.circular(curved),
        bottomRight: Radius.circular(isbottomRight ? 2 : curved),
        bottomLeft: Radius.circular(curved),
      );
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: message.senderId != logInUser
            ? MainAxisAlignment.start
            : MainAxisAlignment.end,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7),
            child: message.senderId != logInUser
                ? clientMessageCard(context)
                : loggedInUserMessageCard(context),
          )
        ],
      ),
    );
  }

  get replyContextStyle => const TextStyle(fontSize: 10);
  get replyTitleStyle => const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w500,
      );
  get contextStyle => const TextStyle(fontSize: 13);
  get captionStyle => const TextStyle(fontSize: 11);
  Widget loggedInUserMessageCard(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 158, 184, 255),
            borderRadius: messageBorderRadius(isbottomRight: true),
          ),
          child: Wrap(
            alignment: WrapAlignment.end,
            spacing: 8,
            crossAxisAlignment: WrapCrossAlignment.end,
            children: [
              if (message.type == MessageType.reply) replyCard(),
              Text(
                message.status == MessageStatus.deleted
                    ? '🚫 You deleted this message'
                    : message.text ?? '',
                style: contextStyle,
              ),
              Offstage(
                offstage: hideMessageStatus,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(DateTimeFormat(message.createdAt).hm(showPeriod: true),
                        textAlign: TextAlign.end, style: captionStyle),
                    buildMessageStatus(message.status),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  /// Only Visiable when message type is Reply
  Widget replyCard() {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      constraints: const BoxConstraints(
          minHeight: 36, maxHeight: 68, minWidth: double.maxFinite),
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 167, 170, 172),
        borderRadius: BorderRadius.all(Radius.circular(14)),
      ),
      child: Row(
        children: [
          Container(
            height: double.maxFinite,
            width: 3,
            margin: const EdgeInsets.fromLTRB(0, 4, 4, 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color.fromARGB(255, 100, 105, 114),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Offstage(
                    offstage: false,
                    child: Text(
                      message.senderId,
                      style: replyTitleStyle,
                    )),
                const SizedBox(width: 2),
                Text(
                  message.replay?.text ?? '',
                  style: replyContextStyle,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget clientMessageCard(BuildContext context) {
    return Dismissible(
      key: Key(message.messageId),
      direction: DismissDirection.startToEnd,
      confirmDismiss: (direction) async {
        context.read<ChatHandlerBloc>().add(CHE_OnReply(message));
        context.read<InputHandlerBloc>().add(IHE_OnReply(message));
        return false;
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 167, 170, 172),
              borderRadius: messageBorderRadius(isTopLeft: true),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Offstage(
                    offstage: hideClientName,
                    child: const Text(
                      'Rohit',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    )),
                const SizedBox(width: 8),
                Wrap(
                  alignment: WrapAlignment.end,
                  crossAxisAlignment: WrapCrossAlignment.end,
                  children: [
                    Text(
                      message.text ?? '',
                      style: contextStyle,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        DateTimeFormat(message.createdAt).hm(showPeriod: true),
                        style: captionStyle,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMessageStatus(MessageStatus status) {
    late final (IconData, Color) icon;
    switch (status) {
      case MessageStatus.deleted:
        icon = (Icons.delete_forever, Colors.red);
        break;
      case MessageStatus.sent:
        icon = (Icons.done, Colors.blueGrey);
      case MessageStatus.seen:
        icon = (Icons.done_all, Colors.blue);
        break;
      case MessageStatus.failed:
        icon = (Icons.priority_high, Colors.yellow);
        break;
      default:
        icon = (Icons.schedule, Colors.grey);
    }
    return Padding(
      padding: const EdgeInsets.only(left: 3.0),
      child: Icon(
        icon.$1,
        color: icon.$2,
        size: 12,
      ),
    );
  }
}
