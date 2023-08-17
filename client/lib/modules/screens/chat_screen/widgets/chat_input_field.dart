
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:reConnect/modules/screens/camera_screen/camera_screen.dart';
import 'package:reConnect/modules/screens/chat_screen/chat_blocs/input_handler_bloc/input_handler_bloc.dart';
import 'package:reConnect/modules/screens/chat_screen/inner_routing.dart';
import 'package:reConnect/modules/screens/chat_screen/screens/send_and_preview_image_screen.dart';
import 'package:reConnect/modules/screens/chat_screen/widgets/attachment_card.dart';
import 'package:reConnect/utility/extensions.dart';
import 'package:shared/shared.dart';
import '../utils/chat_input_services.dart';

class ChatInputField extends StatefulWidget {
  const ChatInputField({Key? key}) : super(key: key);

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  onSendTap() => context.read<InputHandlerBloc>().add(OnMessageSendHandler());

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
                    // Handle Widgets
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (state.hasKiC)
                          AnimatedCrossFade(
                            duration: 150.milliseconds,
                            crossFadeState: state.hasKiC
                                ? CrossFadeState.showFirst
                                : CrossFadeState.showSecond,
                            firstChild: AttachmentCard.forKiC(state.kiC),
                            secondChild: const SizedBox(),
                          ),
                        if (state.hasReplyMsg)
                          AnimatedCrossFade(
                            duration: 150.milliseconds,
                            crossFadeState: state.hasReplyMsg
                                ? CrossFadeState.showFirst
                                : CrossFadeState.showSecond,
                            firstChild:
                                buildReplyCard(state.replyMsg!, state.hasKiC),
                            secondChild: const SizedBox(),
                          ),
                      ],
                    );
                  },
                ),
                buildInputTextField(context, chatServices),
              ],
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: hasInput ? onSendTap : null,
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
    const boxConstraints = BoxConstraints(
      minHeight: 48,
      maxHeight: 150,
    );
    return Container(
      constraints: boxConstraints,
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
                      return Container(height: 350);
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
            child: TextField(
              contentInsertionConfiguration: ContentInsertionConfiguration(
                  onContentInserted: (value) => context
                      .read<InputHandlerBloc>()
                      .add(OnKiCHandler.add(value))),
              controller: chatServices.inputController,
              focusNode: chatServices.inputFocusNode,
              onChanged: (value) => setState(() {}),
              cursorColor: const Color(0xff705cff),
              minLines: 1,
              maxLines: 20,
              scrollPadding: EdgeInsets.zero,
              decoration: const InputDecoration(
                  constraints: boxConstraints,
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
          const SelectAttachmentsButton(),
        ],
      ),
    );
  }

  Container buildReplyCard(Message msg, bool isLeftEnable) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 22),
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      constraints: const BoxConstraints(
          minHeight: 36, maxHeight: 68, minWidth: double.maxFinite),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 100, 105, 114),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(isLeftEnable ? 0 : 14),
            topRight: const Radius.circular(14)),
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
              onTap: () => context
                  .read<InputHandlerBloc>()
                  .add(InputHandlerEvent.onIdle()),
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
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 11,
                    ),
                  ),
                ),
                const SizedBox(width: 2),
                Text(
                  msg.text ?? '',
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

class SelectAttachmentsButton extends StatelessWidget {
  const SelectAttachmentsButton({super.key});

  @override
  Widget build(BuildContext context) {
    var innerRouting = context.read<InnerRouting>();
    List<SpeedDialChild> menuList = [
      SpeedDialChild(
          shape: context.decoration.roundedBorder(100),
          onTap: () {
            innerRouting.push(
              CameraScreen(
                onPop: innerRouting.pop,
                onPreview: (images) => innerRouting
                    .push(SendAndPreviewImagesScreen(images: images)),
              ),
            );
          },
          child: const Icon(Icons.camera_alt_rounded)),
      SpeedDialChild(
          shape: context.decoration.roundedBorder(100),
          onTap: () async {
            final images = await pickFiles(FileType.image);
            if (images != null && images.isNotEmpty) {
              var list = images
                  .map((e) => (e.extension!.toLowerCase(), e.bytes!))
                  .toList();
              innerRouting.push(SendAndPreviewImagesScreen(images: list));
            }
          },
          child: const Icon(Icons.image_outlined)),
    ];
    const size = Size(42, 42);

    return Padding(
      padding: const EdgeInsets.only(bottom: 3.0),
      child: SpeedDial(
        children: menuList,
        buttonSize: size,
        backgroundColor: Colors.transparent,
        elevation: 0,
        spaceBetweenChildren: 12,
        childMargin: const EdgeInsets.all(16),
        childPadding: EdgeInsets.zero,
        shape: context.decoration.roundedBorder(100),
        child: const Icon(Icons.attach_file_outlined, size: 32),
      ),
    );
  }

  Future<List<PlatformFile>?> pickFiles(FileType type,
      [bool allowMultiple = true]) async {
    List<PlatformFile>? result;
    try {
      result = (await FilePicker.platform.pickFiles(
              type: type, allowMultiple: allowMultiple, withData: true))
          ?.files;
    } on PlatformException catch (e) {
      print('Unsupported operation$e');
    } catch (e) {
      print(e.toString());
    }
    return result;
  }
}
