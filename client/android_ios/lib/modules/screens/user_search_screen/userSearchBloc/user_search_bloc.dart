// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:reConnect/core/firebase_bloc/primary_user_bloc/primary_user_bloc.dart';
import 'package:shared/firebase_api/firebase_api.dart';
import 'package:shared/shared.dart';
part 'user_search_event.dart';
part 'user_search_state.dart';

class UserSearchBloc extends Bloc<UserSearchEvent, UserSearchState> {
  final PrimaryUserBloc primaryUserBloc;
  late final List<User> contacts;
  UserSearchBloc({required this.primaryUserBloc}) : super(USS_Complete()) {
    contacts = primaryUserBloc.primaryUser!.contacts;
    on<USE_InputChanged>(_inputChanged);
    on<USE_InputSubmitted>(_inputSubmitted);
  }

  _inputChanged(USE_InputChanged event, Emitter<UserSearchState> emit) {
    if (event.input.isEmpty) {
      emit(USS_Complete(contacts));
    } else if (_hasInputError(event.input)) {
      emit(USS_ErrorState());
    } else {
      final list = _getFromUsersProfile(event);
      emit(USS_Complete(list));
    }
  }

  _inputSubmitted(
      USE_InputSubmitted event, Emitter<UserSearchState> emit) async {
    if (event.input.isEmpty) {
      emit(USS_Complete(contacts));
    } else if (_hasInputError(event.input)) {
      emit(USS_ErrorState());
    } else {
      var list = _getFromUsersProfile(event);
      if (list.isEmpty && event.input.isNotEmpty) {
        var user =
            await UserRepository().fetchUserByPhoneNumberOrEmail(event.input);
        if (user != null) {
          list = [user];
          primaryUserBloc.add(UpdateContacts.byAdding(list));
        } else {
          list = [];
        }
      }
      emit(USS_Complete(list));
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

  List<User> _getFromUsersProfile(event) {
    return contacts.where((element) {
      return element.name.contains(event.input) ||
          (element.phoneNumber ?? '').contains(event.input) ||
          (element.email ?? '').contains(event.input);
    }).toList();
  }

  _hasInputError(String text) => text.contains(RegExp(r"[^0-9a-zA-Z@.]+"));
}
