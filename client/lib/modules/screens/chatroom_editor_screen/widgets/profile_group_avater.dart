import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:jars/widgets/gap.dart';
import 'package:logs/logs.dart';
import 'package:reConnect/modules/screens/camera_screen/camera_screen.dart';
import 'package:reConnect/modules/screens/chatroom_editor_screen/bloc/cubit/input_handler_cubit.dart';
import 'package:reConnect/modules/screens/other_screens/image_preview_screen.dart';
import 'package:reConnect/modules/widgets/profile_avatar.dart';
import 'package:reConnect/utility/extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/utility/src/inner_routing.dart';

class ProfileGroupAvater extends StatelessWidget {
  const ProfileGroupAvater({super.key});

  @override
  Widget build(BuildContext context) {
    context = context;
    return Stack(
      children: [
        Builder(builder: (context) {
          var profileImg =
              context.select((InputHandlerCubit bloc) => bloc.state.profileImg);
          return ProfileAvatar(
            name: 'Group',
            borderRadius: 16,
            size: 82,
            profileImg: profileImg,
            onTap: () {
              if (profileImg != null) {
                var read = context.read<InnerRouting>();
                read.push(ImagePreviewScreen(
                  title: 'Group Avater',
                  url: profileImg,
                  onBack: read.pop,
                ));
              }
            },
          );
        }),
        Positioned(
          bottom: 0,
          right: 0,
          child: IconButton(
              icon: const Icon(Icons.camera_alt, color: Colors.black38),
              onPressed: () => showModalBottomSheet(
                    showDragHandle: true,
                    context: context,
                    builder: (ctx) => _bottomSheet(context, ctx),
                  )),
        )
      ],
    );
  }

  Widget _bottomSheet(BuildContext context, BuildContext ctx) {
    var color = ctx.appTheme.themeData.primaryColor;
    Widget iconButton(IconData icon, String label, {VoidCallback? onTap}) =>
        InkResponse(
          onTap: onTap,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  border: Border.all(color: color),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Icon(icon, color: color),
              ),
              const Gap(8),
              Text(label),
            ],
          ),
        );
    var innerRouting = context.read<InnerRouting>();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Group icon',
                style: context.appTheme.textTheme.headlineMedium,
              ),
              IconButton(onPressed: () {}, icon: const Icon(Icons.delete))
            ],
          ),
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 16, 0, 32),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              iconButton(
                Icons.camera_alt,
                'Camera',
                onTap: () {
                  ctx.pop();

                  innerRouting.push(CameraScreen(
                      onPreview: (images) {
                        context.read<InnerRouting>().push(ImagePreviewScreen(
                            title: 'Group Avater',
                            bytes: images.first.$2,
                            onBack: innerRouting.clearAll,
                            onDone: () async {
                              await context
                                  .read<InputHandlerCubit>()
                                  .uploadProfileToServer(
                                      bytes: images.first.$2,
                                      extension: images.first.$1);
                              innerRouting.clearAll();
                            }));
                      },
                      forceOnlyOneClick: true,
                      onPop: innerRouting.clearAll));
                },
              ),
              iconButton(Icons.filter, 'Gallery', onTap: () async {
                ctx.pop();
                final images = await pickFiles(FileType.image, false);
                if (images != null && images.isNotEmpty) {
                  innerRouting.push(ImagePreviewScreen(
                      title: 'Group Avater',
                      onDone: () async {
                        await context
                            .read<InputHandlerCubit>()
                            .uploadProfileToServer(
                                bytes: images[0].bytes!,
                                extension: images[0].extension!.toLowerCase());
                        innerRouting.clearAll();
                      },
                      onBack: innerRouting.clearAll,
                      bytes: images.first.bytes));
                }
              }),
              iconButton(Icons.emoji_emotions, 'Emoji'),
            ],
          ),
        )
      ],
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
      logs.error(e.message, 'Code: ${e.code}');
    } catch (e) {
      logs.error(e.toString());
    }
    return result;
  }
}
