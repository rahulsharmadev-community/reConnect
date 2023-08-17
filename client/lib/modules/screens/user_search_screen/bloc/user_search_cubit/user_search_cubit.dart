// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:reConnect/core/BLOCs/primary_user_bloc/primary_user_bloc.dart';
import 'package:reConnect/core/APIs/firebase_api/firebase_api.dart';
import 'package:shared/shared.dart';
part 'user_search_state.dart';

class UserSearchCubit extends Cubit<UserSearchState> {
  final PrimaryUserBloc primaryUserBloc;
  UserSearchCubit({required this.primaryUserBloc})
      : super(UserSearchCompleted(
            chatRooms: primaryUserBloc.primaryUser!.chatRooms.values.toList()));

  List<User> get contacts =>
      primaryUserBloc.primaryUser!.contacts.values.toList();

  List<ChatRoomInfo> get chatRooms =>
      primaryUserBloc.primaryUser!.chatRooms.values.toList();

  void inputChanged(String input) {
    if (input.isEmpty) {
      emit(UserSearchCompleted(chatRooms: chatRooms));
    } else if (_hasInputError(input)) {
      emit(UserSearchErrorState('$input not found'));
    } else {
      var data = _getFromUsersProfile(input);
      emit(UserSearchCompleted(chatRooms: data.$1, contacts: data.$2));
    }
  }

  void inputSubmitted(String input) async {
    if (input.isEmpty) {
      emit(UserSearchCompleted(chatRooms: chatRooms));
    } else if (_hasInputError(input)) {
      emit(UserSearchErrorState('$input not found'));
    } else {
      var data = _getFromUsersProfile(input);
      if (data.$1.isEmpty && data.$2.isEmpty && input.isNotEmpty) {
        var user = await UserApi().fetchUserByPhoneNumberOrEmail(input);
        if (user != null) {
          data = ([], [user]);
          primaryUserBloc.add(PrimaryUserEvent.addingContacts([user]));
        }
      }
      emit(UserSearchCompleted(contacts: data.$2, chatRooms: data.$1));
    }
  }

  (List<ChatRoomInfo> cRs, List<User>) _getFromUsersProfile(String input) {
    // searching chatRooms
    List<ChatRoomInfo> cRs = chatRooms
        .where((room) =>
            (room.name?.toLowerCase() ?? '').contains(input.toLowerCase()))
        .toList();

    List<User> cOs = [];
    // searching contacts
    if (cRs.isEmpty) {
      cOs = contacts
          .where((element) =>
              element.name.toLowerCase().contains(input.toLowerCase()) ||
              (element.phoneNumber ?? '').contains(input) ||
              (element.email ?? '').contains(input))
          .toList();
    }
    return (cRs, cOs);
  }

  _hasInputError(String text) => text.contains(RegExp(r"[^0-9a-zA-Z@.]+"));
}
