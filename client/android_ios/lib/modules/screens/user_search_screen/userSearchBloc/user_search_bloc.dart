// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:reConnect/core/firebase_bloc/primary_user_bloc/primary_user_bloc.dart';
import 'package:reConnect/core/firebase_api/firebase_api.dart';
import 'package:shared/shared.dart';
part 'user_search_event.dart';
part 'user_search_state.dart';

class UserSearchBloc extends Bloc<UserSearchEvent, UserSearchState> {
  final PrimaryUserBloc primaryUserBloc;
  UserSearchBloc({required this.primaryUserBloc})
      : super(USS_Complete(chatRooms: primaryUserBloc.primaryUser!.chatRooms)) {
    on<USE_InputChanged>(_inputChanged);
    on<USE_InputSubmitted>(_inputSubmitted);
  }
  List<User> get contacts => primaryUserBloc.primaryUser!.contacts;
  List<ChatRoomInfo> get chatRooms => primaryUserBloc.primaryUser!.chatRooms;

  _inputChanged(USE_InputChanged event, Emitter<UserSearchState> emit) {
    if (event.input.isEmpty) {
      emit(USS_Complete(chatRooms: chatRooms));
    } else if (_hasInputError(event.input)) {
      emit(USS_ErrorState());
    } else {
      var data = _getFromUsersProfile(event.input);
      emit(USS_Complete(chatRooms: data.$1, contacts: data.$2));
    }
  }

  _inputSubmitted(
      USE_InputSubmitted event, Emitter<UserSearchState> emit) async {
    if (event.input.isEmpty) {
      emit(USS_Complete(chatRooms: chatRooms));
    } else if (_hasInputError(event.input)) {
      emit(USS_ErrorState());
    } else {
      var data = _getFromUsersProfile(event.input);
      if (data.$1.isEmpty && data.$2.isEmpty && event.input.isNotEmpty) {
        var user =
            await UserRepository().fetchUserByPhoneNumberOrEmail(event.input);
        if (user != null) {
          data = ([], [user]);
          primaryUserBloc.add(UpdateContacts.byAdding([user]));
        }
      }
      emit(USS_Complete(chatRooms: data.$1, contacts: data.$2));
    }
  }

  // bool isRoomAlreadyExist(String userId) {
  //   for (var room in primaryUserBloc.primaryUser!.chatRooms) {
  //     if (room.isOneToOne) {
  //       return room.members.contains(userId);
  //     }
  //   }
  //   return false;
  // }

  (List<ChatRoomInfo> cRs, List<User>) _getFromUsersProfile(String input) {
    // chatRooms
    List<ChatRoomInfo> cRs = chatRooms
        .where((room) =>
            (room.name?.toLowerCase() ?? '').contains(input.toLowerCase()))
        .toList();
    List<User> cOs = [];

    // contacts
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
