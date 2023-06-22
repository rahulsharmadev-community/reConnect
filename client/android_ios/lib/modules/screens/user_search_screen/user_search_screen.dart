import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'userSearchBloc/user_search_bloc.dart';

class UserSearchScreen extends StatelessWidget {
  const UserSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserSearchBloc([]),
      child: Scaffold(
        appBar: AppBar(title: const SearchField()),
        body: BlocBuilder<UserSearchBloc, UserSearchState>(
            builder: (context, state) {
          return state is USS_Complete
              ? ListView.builder(
                  itemCount: state.list.length,
                  itemBuilder: (context, index) {
                    var user = state.list[index];
                    return ListTile(
                      title: Text(user.name),
                      leading: ImageIcon(
                        Image.memory(base64.decode(user.profileImg!
                                .replaceFirst('data:image/png;base64,', '')))
                            .image,
                        size: 32,
                      ),
                    );
                  },
                )
              : const Placeholder();
        }),
      ),
    );
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
      onChanged: (value) {
        return read.add(USE_InputChanged(value));
      },
      controller: controller,
      onSubmitted: (value) => read.add(USE_InputSubmitted(value)),
      decoration: InputDecoration(
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
