import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_size_getter/image_size_getter.dart'
    show MemoryInput, ImageSizeGetter;
import 'package:jars/jars.dart';
import 'package:shared/utility/src/inner_routing.dart';
import '../chat_blocs/input_handler_bloc/input_handler_bloc.dart';
import 'package:shared/shared.dart';

class SendAndPreviewImagesScreen extends StatefulWidget {
  final List<(String, Uint8List)> images;

  const SendAndPreviewImagesScreen({super.key, required this.images});

  @override
  State<SendAndPreviewImagesScreen> createState() =>
      _SendAndPreviewImagesScreenState();
}

class _SendAndPreviewImagesScreenState
    extends State<SendAndPreviewImagesScreen> {
  var attachments = <Attachment>[];
  late final PageController pageController;
  late final TextEditingController textController;

  int get currentpage => pageController.page?.round() ?? 0;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
    attachments = widget.images.map((e) {
      var size = ImageSizeGetter.getSize(MemoryInput(e.$2));
      return Attachment.fromDevice(
          ext: e.$1,
          type: AttachmentType.image,
          bytes: e.$2,
          caption: '',
          size: Size(size.width.toDouble(), size.height.toDouble()));
    }).toList();
    pageController = PageController();
    pageController.addListener(() {
      setState(() {
        textController.text = attachments[currentpage].caption ?? '';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var innerRouting = context.read<InnerRouting>();
    var outlineInputBorder = const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
        borderRadius: BorderRadius.all(Radius.circular(100.0)));
    return WillPopScope(
      onWillPop: () async {
        innerRouting.pop();
        return false;
      },
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Preview'),
            leading: BackButton(onPressed: innerRouting.pop),
            actions: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.edit_note)),
              IconButton(
                  onPressed: () {
                    attachments.removeAt(currentpage);
                    setState(() {});
                  },
                  icon: const Icon(Icons.delete_forever)),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              context
                  .read<InputHandlerBloc>()
                  .add(OnMessageSendHandler(attachments));
              innerRouting.clearAll();
            },
            child: const Icon(Icons.send),
          ),
          body: ListView(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * .7,
                child: PageView.builder(
                  controller: pageController,
                  itemCount: attachments.length,
                  itemBuilder: (context, index) {
                    var attachment = attachments[index];
                    return Image.memory(attachment.bytes!);
                  },
                ),
              ),
              TextField(
                controller: textController,
                decoration: InputDecoration(
                    isDense: true,
                    hintText: 'Captions...',
                    enabledBorder: outlineInputBorder,
                    border: outlineInputBorder,
                    focusedErrorBorder: outlineInputBorder,
                    focusedBorder: outlineInputBorder,
                    disabledBorder: outlineInputBorder,
                    errorBorder: outlineInputBorder),
                onChanged: (text) {
                  attachments[currentpage] = attachments[currentpage]
                      .copyWith(caption: textController.text);
                },
              ).paddingHorizontal(8),
            ],
          )),
    );
  }
}
