import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reConnect/core/firebase_bloc/primary_user_bloc/primary_user_bloc.dart';
import 'package:reConnect/modules/widgets/userlisttile.dart';
import 'package:reConnect/utility/navigation/app_navigator.dart';
import 'package:reConnect/utility/routes/app_router.dart';
import 'package:shared/firebase_api/firebase_api.dart';
import 'package:shared/shared.dart';
import 'userSearchBloc/user_search_bloc.dart';

class UserSearchScreen extends StatelessWidget {
  const UserSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var primaryUserBloc = context.read<PrimaryUserBloc>();
    return BlocProvider(
      create: (context) {
        return UserSearchBloc( primaryUserBloc: primaryUserBloc);
      },
      child: Scaffold(
        appBar: AppBar(title: const SearchField()),
        body: buildBody(primaryUserBloc.primaryUser!),
      ),
    );
  }

  Widget buildBody(PrimaryUser primaryUser) {
    return BlocBuilder<UserSearchBloc, UserSearchState>(
        builder: (context, state) {
      return state is USS_Complete
          ? ListView.builder(
              itemCount: state.list.length,
              itemBuilder: (context, index) {
                var user = state.list[index];
                return UserListTile(
                  name: user.name,
                  profileImg: user.profileImg,
                  subtitle: user.about != null ? Text(user.about!) : null,
                  onTap: () {
                    AppNavigator.on((router) => router.pushNamed(
                        AppRoutes.StartNewConversationScreen.name,
                        extra: ChatRoomInfo(
                            createdBy: primaryUser.userId,
                            members: [primaryUser.userId, user.userId])));
                  },
                );
              },
            )
          : const Placeholder();
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
      onChanged: (value) => read.add(USE_InputChanged(value)),
      controller: controller,
      onSubmitted: (value) => read.add(USE_InputSubmitted(value)),
      decoration: InputDecoration(
          border: InputBorder.none,
          helperText: 'Search...',
          suffix: InkWell(
            onTap: () {
              controller.clear();
              read.add(USE_InputSubmitted(controller.text));
              setState(() {});
            },
            child: const Icon(Icons.clear_rounded),
          )),
    );
  }
}
