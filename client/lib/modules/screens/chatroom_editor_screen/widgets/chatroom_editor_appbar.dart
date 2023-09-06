import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:reConnect/modules/screens/chatroom_editor_screen/widgets/profile_group_avater.dart';
import 'package:reConnect/utility/extensions.dart';
import '../bloc/cubit/input_handler_cubit.dart';
import 'package:shared/shared.dart';

class ChatroomEditorAppBar extends StatelessWidget {
  const ChatroomEditorAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    var height = 250;
    double appbarHeight = MediaQuery.of(context).padding.top + kToolbarHeight;
    var read = context.read<InputHandlerCubit>();
    return SliverAppBar(
      floating: true,
      snap: true,
      pinned: true,
      automaticallyImplyLeading: false,
      expandedHeight: 250,
      actions: [
        Builder(builder: (context) {
          var hasReadyForSubmit = context
              .select((InputHandlerCubit bloc) => bloc.hasReadyForSubmit);
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: OutlinedButton.icon(
                onPressed: hasReadyForSubmit
                    ? () async {
                        await read.submit();
                        AppNavigator.pop();
                      }
                    : null,
                style: OutlinedButton.styleFrom(
                    side: hasReadyForSubmit ? null : BorderSide.none,
                    padding: hasReadyForSubmit ? null : EdgeInsets.zero),
                icon: const Icon(Icons.done_all),
                label: AnimatedCrossFade(
                  crossFadeState:
                      CrossFadeState.values[hasReadyForSubmit ? 0 : 1],
                  duration: 100.milliseconds,
                  firstChild: const Text('Done'),
                  secondChild: const Gap(),
                )),
          );
        })
      ],
      title: Text(read.isEditing ? ' Edit Chatroom' : 'New Chatroom'),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          height: appbarHeight + height,
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(children: [
                const ProfileGroupAvater(),
                const Gap(8),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      NameTextField(inital: read.state.nameText),
                      const Gap(8),
                      _participationBadges(context)
                    ],
                  ),
                )
              ]),
              Builder(builder: (context) {
                var text = context.select(
                    (InputHandlerCubit bloc) => bloc.state.descriptionText);
                return ListTile(
                    contentPadding: EdgeInsets.zero,
                    dense: text.length > 60 ? true : false,
                    trailing:
                        const Icon(Icons.edit_note, color: Colors.white54),
                    title: const Text('Description'),
                    onTap: () => showModalBottomSheet(
                        showDragHandle: true,
                        isScrollControlled: true,
                        context: context,
                        builder: (ctx) => DescriptionTextField(
                              inital: text,
                              bloc: context.read<InputHandlerCubit>(),
                            )),
                    subtitle: Text(
                      text,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ));
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _participationBadges(BuildContext context) {
    var data = context.select((InputHandlerCubit bloc) => (
          bloc.state.administrators,
          bloc.state.moderators,
          bloc.state.members,
          bloc.state.visitors,
        ));
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _customBadge(ChatRoomRole.administrators, data.$1.length),
        _customBadge(ChatRoomRole.moderators, data.$2.length),
        _customBadge(ChatRoomRole.members, data.$3.length),
        _customBadge(ChatRoomRole.visitor, data.$4.length),
      ],
    );
  }

  Column _customBadge(ChatRoomRole role, int text) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          role.svgPath,
          colorFilter: ColorFilter.mode(role.color, BlendMode.srcIn),
          height: 18,
        ),
        const Gap(4),
        Text('$text')
      ],
    );
  }
}

class NameTextField extends StatefulWidget {
  final String inital;
  const NameTextField({super.key, this.inital = ''});

  @override
  State<NameTextField> createState() => _NameTextFieldState();
}

class _NameTextFieldState extends State<NameTextField> {
  late final TextEditingController controller;
  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.inital);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
      child: TextField(
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
        maxLines: 1,
        controller: controller,
        inputFormatters: [LengthLimitingTextInputFormatter(15)],
        onChanged: context.read<InputHandlerCubit>().onNameChange,
        decoration: InputDecoration(
          isDense: true,
          suffix: InkResponse(
            onTap: () {
              controller.clear();
              context.read<InputHandlerCubit>().onNameChange('');
            },
            child: const Icon(Icons.close_rounded),
          ),
          focusedBorder: const UnderlineInputBorder(),
          errorBorder: const UnderlineInputBorder(),
          enabledBorder: InputBorder.none,
          hintText: 'Name',
        ),
      ),
    );
  }
}

class DescriptionTextField extends StatefulWidget {
  final String? inital;
  final InputHandlerCubit bloc;
  const DescriptionTextField({
    super.key,
    required this.bloc,
    this.inital,
  });

  @override
  State<DescriptionTextField> createState() => _DescriptionTextFieldState();
}

class _DescriptionTextFieldState extends State<DescriptionTextField> {
  late final TextEditingController controller;
  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.inital);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          16, 0, 16, MediaQuery.of(context).viewInsets.bottom + 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              titleText(context),
              if (widget.inital != controller.text.trim()) submitButton(context)
            ],
          ),
          const Divider(),
          TextField(
            minLines: 1,
            maxLines: 4,
            maxLength: 120,
            controller: controller,
            onChanged: (_) {
              widget.bloc.onDescriptionChange(controller.text.trim());
              setState(() {});
            },
            // style: const TextStyle(fontSize: 14, color: Colors.white54),
            decoration: InputDecoration(
              isDense: true,
              hintText: 'Write here..',
              border: const UnderlineInputBorder(),
              enabledBorder: const UnderlineInputBorder(),
              focusedBorder: const UnderlineInputBorder(),
              contentPadding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
              suffix: GestureDetector(
                onTap: () {
                  controller.clear();
                  widget.bloc.onDescriptionChange('');
                  setState(() {});
                },
                child: const Icon(Icons.close_rounded),
              ),
              floatingLabelStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget submitButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: InkResponse(
          onTap: context.pop,
          child: Icon(
            Icons.done,
            color: context.theme.themeData.primaryColor,
          )),
    );
  }

  Text titleText(BuildContext context) {
    return Text(
      'Description',
      style: context.theme.textTheme.headlineMedium,
    );
  }
}
