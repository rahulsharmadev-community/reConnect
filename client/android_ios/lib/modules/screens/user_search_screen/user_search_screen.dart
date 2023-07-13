import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reConnect/core/firebase_api/firebase_api.dart';
import 'package:reConnect/core/firebase_bloc/primary_user_bloc/primary_user_bloc.dart';
import 'package:reConnect/modules/widgets/userlisttile.dart';
import 'package:reConnect/utility/routes/app_router.dart';
import 'package:shared/shared.dart';
import 'userSearchBloc/user_search_bloc.dart';

class UserSearchScreen extends StatelessWidget {
  const UserSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var primaryUserBloc = context.read<PrimaryUserBloc>();
    return BlocProvider(
      create: (context) => UserSearchBloc(primaryUserBloc: primaryUserBloc),
      child: Scaffold(
        appBar: AppBar(title: const SearchField()),
        body: buildBody(primaryUserBloc.primaryUser!),
      ),
    );
  }

  Widget buildBody(PrimaryUser primaryUser) {
    return BlocBuilder<UserSearchBloc, UserSearchState>(
        builder: (context, state) {
      if (state is UserSearchCompleted) {
        List<dynamic> list = [...state.chatRooms, ...state.contacts];
        logs.shout('Run ${list.length}');
        return ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            var user = list[index];
            logs.shout('Run ${user.runtimeType}');
            return UserListTile(
              name: user?.name ?? '',
              profileImg: user?.profileImg,
              subtitle: user.about != null ? Text(user.about!) : null,
              onTap: () async {
                if (user is ChatRoomInfo) {
                  await AppNavigator.on((router) => router.pushNamed(
                      AppRoutes.ChatScreen.name,
                      extra: user.chatRoomId));
                } else {
                  await AppNavigator.on((router) => router.pushNamed(
                      AppRoutes.StartNewConversationScreen.name,
                      extra: ChatRoomInfo(
                          name: user.name,
                          about: user.about,
                          profileImg: user.profileImg,
                          createdBy: primaryUser.userId,
                          members: [primaryUser.userId, user.userId])));
                  AppNavigator.pop();
                }
              },
            );
          },
        );
      } else {
        return const Placeholder();
      }
    });
  }
}

class SearchField extends StatefulWidget {
  const SearchField({
    super.key,
  });

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    var read = context.read<UserSearchBloc>();
    return TextField(
      onChanged: (value) => read.add(UserSearchEvent.inputChange(value)),
      controller: controller,
      onSubmitted: (value) => read.add(UserSearchEvent.inputSubmitted(value)),
      decoration: InputDecoration(
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          hintText: 'Search...',
          suffix: InkWell(
            onTap: () {
              controller.clear();
              read.add(UserSearchInputSubmittedEvent(controller.text));
              setState(() {});
            },
            child: const Icon(Icons.clear_rounded),
          )),
    );
  }
}
