import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
        IconButton(
          onPressed: () async {
            await read.submit();
            AppNavigator.pop();
          },
          icon: const Icon(Icons.done_all),
        )
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
                _profileAvatar(),
                const Gap(),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _nameTextField(read.utils.nameController),
                      const Gap(),
                      _participationBadges(read.state)
                    ],
                  ),
                )
              ]),
              _descriptionTextField(read.utils.descriptionController)
            ],
          ),
        ),
      ),
    );
  }

  Widget _participationBadges(state) {
    return BlocBuilder<InputHandlerCubit, InputHandlerCubitState>(
      builder: (c, s) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _customBadge(ChatRoomRole.administrators, s.administrators.length),
          _customBadge(ChatRoomRole.moderators, s.moderators.length),
          _customBadge(ChatRoomRole.members, s.members.length),
          _customBadge(ChatRoomRole.visitor, s.visitors.length),
        ],
      ),
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

  Container _profileAvatar() {
    return Container(
      height: 82,
      width: 82,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Stack(
        fit: StackFit.expand,
        children: [
          FlutterLogo(),
          Positioned(
              bottom: 4,
              right: 4,
              child: Icon(Icons.camera_alt, color: Colors.black38)),
        ],
      ),
    );
  }

  Widget _nameTextField(TextEditingController nameController) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
      child: TextField(
        controller: nameController,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
        maxLines: 1,
        inputFormatters: [LengthLimitingTextInputFormatter(15)],
        decoration: InputDecoration(
          isDense: true,
          suffix: GestureDetector(
            onTap: () => nameController.clear(),
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

  Widget _descriptionTextField(TextEditingController descriptionController) {
    return TextField(
      minLines: 1,
      maxLines: 3,
      controller: descriptionController,
      keyboardType: TextInputType.text,
      inputFormatters: [LengthLimitingTextInputFormatter(120)],
      style: const TextStyle(fontSize: 14, color: Colors.white54),
      decoration: const InputDecoration(
        isDense: true,
        labelText: 'Description',
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: UnderlineInputBorder(),
        contentPadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
        suffixIcon: Icon(Icons.edit_note, color: Colors.white38),
        floatingLabelStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
