import 'package:reConnect/core/APIs/firebase_api/firebase_api.dart';
import 'package:reConnect/core/BLOCs/primary_user_bloc/primary_user_bloc.dart';
import 'package:reConnect/modules/screens/user_search_screen/bloc/chatroom_service_cubit/chatroom_service_cubit.dart';
import 'package:reConnect/modules/widgets/userlisttile.dart';
import 'package:reConnect/utility/routes/app_router.dart';
import 'bloc/user_search_cubit/user_search_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

class UserSearchScreen extends StatelessWidget {
  const UserSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var primaryUserBloc = context.read<PrimaryUserBloc>();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) =>
                UserSearchCubit(primaryUserBloc: primaryUserBloc)),
        BlocProvider(
            create: (context) => ChatroomServiceCubit(
                primaryUserBloc: primaryUserBloc,
                chatRoomsApi: ChatRoomsApi(),
                userApi: UserApi()))
      ],
      child: Scaffold(
        appBar: AppBar(title: const SearchField()),
        body: BlocListener<ChatroomServiceCubit, BlocData>(
          listener: (context, state) {
            if (state.state == BlocDataState.processing) {
              AppNavigator.pushNamed(AppRoutes.LoadingScreen.name);
            }
          },
          child: buildBody(primaryUserBloc.primaryUser!),
        ),
      ),
    );
  }

  Widget buildBody(PrimaryUser primaryUser) {
    return BlocBuilder<UserSearchCubit, UserSearchState>(
        builder: (context, state) {
      if (state is UserSearchCompleted) {
        List<dynamic> list = [...state.chatRooms, ...state.contacts];
        return ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            // May ChatRoomInfo or User
            var user = list[index];
            return UserListTile(
              name: user?.name ?? '',
              profileImg: user?.profileImg,
              subtitle: user.about != null ? Text(user.about!) : null,
              onTap: () async {
                var read = context.read<ChatroomServiceCubit>();
                await read.handleChatroomTap(user, primaryUser);
                if (read.state.hasData) {
                  AppNavigator.on((router) => router.goNamed(
                      AppRoutes.ChatScreen.name,
                      pathParameters: {'id': read.state.data!.chatRoomId}));
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
    var read = context.read<UserSearchCubit>();
    return TextField(
      onChanged: (value) => read.inputChanged(value),
      controller: controller,
      onSubmitted: (value) => read.inputSubmitted(value),
      decoration: InputDecoration(
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          hintText: 'Search...',
          suffix: InkWell(
            onTap: () {
              controller.clear();
              read.inputSubmitted(controller.text);
              setState(() {});
            },
            child: const Icon(Icons.clear_rounded),
          )),
    );
  }
}
