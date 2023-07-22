// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:reConnect/core/firebase_bloc/primary_user_bloc/primary_user_bloc.dart';
import 'package:reConnect/core/APIs/firebase_api/firebase_api.dart';
import 'package:shared/shared.dart';
part 'user_search_event.dart';
part 'user_search_state.dart';

class UserSearchBloc extends Bloc<UserSearchEvent, UserSearchState> {
  final PrimaryUserBloc primaryUserBloc;
  UserSearchBloc({required this.primaryUserBloc})
      : super(UserSearchCompleted(
            chatRooms: primaryUserBloc.primaryUser!.chatRooms)) {
    on<UserSearchInputChangedEvent>(_inputChanged);
    on<UserSearchInputSubmittedEvent>(_inputSubmitted);
  }

  List<User> get contacts => primaryUserBloc.primaryUser!.contacts;
  List<ChatRoomInfo> get chatRooms => primaryUserBloc.primaryUser!.chatRooms;

  _inputChanged(
      UserSearchInputChangedEvent event, Emitter<UserSearchState> emit) {
    if (event.input.isEmpty) {
      emit(UserSearchCompleted(chatRooms: chatRooms));
    } else if (_hasInputError(event.input)) {
      emit(UserSearchErrorState('${event.input} not found'));
    } else {
      var data = _getFromUsersProfile(event.input);
      emit(UserSearchCompleted(chatRooms: data.$1, contacts: data.$2));
    }
  }

  _inputSubmitted(UserSearchInputSubmittedEvent event,
      Emitter<UserSearchState> emit) async {
    if (event.input.isEmpty) {
      emit(UserSearchCompleted(chatRooms: chatRooms));
    } else if (_hasInputError(event.input)) {
      emit(UserSearchErrorState('${event.input} not found'));
    } else {
      var data = _getFromUsersProfile(event.input);
      if (data.$1.isEmpty && data.$2.isEmpty && event.input.isNotEmpty) {
        var user =
            await UserRepository().fetchUserByPhoneNumberOrEmail(event.input);
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
