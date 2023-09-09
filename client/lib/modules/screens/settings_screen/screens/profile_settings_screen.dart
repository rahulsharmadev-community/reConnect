import 'package:cached_image/cached_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jars/jars.dart';
import 'package:reConnect/core/BLOCs/primary_user_bloc/primary_user_bloc.dart';
import 'package:reConnect/utility/extensions.dart';

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  late String name;
  late String phone;
  late String email;
  late String about;
  @override
  void initState() {
    super.initState();
    name = context.primaryUser.name;
    phone = context.primaryUser.phoneNumber ?? '';
    email = context.primaryUser.email ?? '';
    about = context.primaryUser.about;
  }

  updatePrimaryUser() {
    final bloc = context.read<PrimaryUserBloc>();
    bloc.add(PrimaryUserEvent.updateProfile(
      name: name,
      email: email,
      phoneNumber: phone,
      about: about,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        children: [
          const Gap(32),
          profileImage(context),
          const Gap(16),
          tile(
              title: 'Name',
              subtitle: name,
              subtitle2: 'This is not your username or pin. This name will '
                  'be visible to your reConnect contacts.',
              initalText: name,
              maxLength: 26,
              keyboardType: TextInputType.name,
              onSubmit: (value) {
                setState(() => name = value);
                updatePrimaryUser();
              }),
          tile(
            title: 'About',
            subtitle: about,
            initalText: about,
            keyboardType: TextInputType.text,
            onSubmit: (value) {
              setState(() => about = value);
              updatePrimaryUser();
            },
          ),
          tile(
              title: 'Phone Number',
              prefix: '91+ ',
              subtitle: '91+ $phone',
              initalText: phone,
              maxLength: 10,
              keyboardType: TextInputType.phone,
              onSubmit: (value) {
                setState(() => phone = value);
                updatePrimaryUser();
              }),
          if (email.isNotEmpty)
            tile(
                title: 'Email',
                subtitle: email,
                initalText: email,
                keyboardType: TextInputType.emailAddress,
                onSubmit: (value) {
                  setState(() => email = value);
                  updatePrimaryUser();
                }),
        ],
      ),
    );
  }

  Row profileImage(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 150,
              height: 150,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1000),
                  color: Colors.grey),
              child: context.primaryUser.profileImg == null
                  ? Text(context.primaryUser.name[0],
                      style: Theme.of(context).primaryTextTheme.displayLarge)
                  : CachedImage(context.primaryUser.profileImg!),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(1000),
                    color: Colors.blue),
                child: const Icon(Icons.camera_alt),
              ),
            ),
          ],
        ),
      ],
    );
  }

  ListTile tile(
      {required String title,
      required String initalText,
      required String subtitle,
      Widget? leading,
      String? prefix,
      String? subtitle2,
      TextInputType? keyboardType,
      int minLines = 1,
      int maxLines = 1,
      int maxLength = 120,
      required Function(String) onSubmit}) {
    return ListTile(
      trailing: const Icon(Icons.edit, color: Colors.white54),
      leading: leading,
      title: Opacity(
        opacity: 0.7,
        child: Text(
          title,
          style: const TextStyle(fontSize: 14),
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            subtitle,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: const TextStyle(fontSize: 17),
          ),
          if (subtitle2 != null)
            Opacity(
                opacity: 0.7,
                child: Text(
                  subtitle2,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                )),
        ],
      ),
      onTap: () async {
        final string = await showModalBottomSheet(
            showDragHandle: true,
            isScrollControlled: true,
            context: context,
            builder: (ctx) => _BottomSheetBuilder(
                title: title,
                inital: initalText,
                minLines: minLines,
                maxLines: maxLines,
                maxLength: maxLength,
                prefix: prefix,
                keyboardType: keyboardType ?? TextInputType.text));
        onSubmit(string);
      },
    );
  }
}

class _BottomSheetBuilder extends StatefulWidget {
  final String inital, title;
  final String? prefix;
  final int minLines, maxLines, maxLength;
  final TextInputType keyboardType;
  const _BottomSheetBuilder(
      {this.prefix,
      required this.inital,
      required this.keyboardType,
      required this.title,
      required this.minLines,
      required this.maxLines,
      required this.maxLength});

  @override
  State<_BottomSheetBuilder> createState() => _BottomSheetBuilderState();
}

class _BottomSheetBuilderState extends State<_BottomSheetBuilder> {
  late final TextEditingController controller;
  late final FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.inital);
    focusNode = FocusNode()..requestFocus();
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  Text titleText() {
    return Text(
      widget.title,
      style: context.textTheme.headlineMedium,
    );
  }

  Widget submitButton() {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: InkResponse(
          onTap: () => context.pop(controller.text),
          child: Icon(
            Icons.done,
            color: context.colorScheme.primary,
          )),
    );
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
              titleText(),
              if (widget.inital != controller.text.trim()) submitButton()
            ],
          ),
          const Divider(),
          TextField(
            minLines: widget.minLines,
            maxLines: widget.maxLines,
            maxLength: widget.maxLength,
            controller: controller,
            keyboardType: widget.keyboardType,
            focusNode: focusNode,

            onChanged: (_) => setState(() {}),
            // style: const TextStyle(fontSize: 14, color: Colors.white54),
            decoration: InputDecoration(
              isDense: true,
              hintText: 'Write here..',
              prefixText: widget.prefix,
              border: const UnderlineInputBorder(),
              enabledBorder: const UnderlineInputBorder(),
              focusedBorder: const UnderlineInputBorder(),
              contentPadding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
              suffix: GestureDetector(
                onTap: () {
                  controller.clear();
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
}
