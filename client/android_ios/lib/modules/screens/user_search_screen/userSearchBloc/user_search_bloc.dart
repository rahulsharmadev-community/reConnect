// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:shared/firebase_api/firebase_api.dart';
import 'package:shared/shared.dart';
part 'user_search_event.dart';
part 'user_search_state.dart';

class UserSearchBloc extends Bloc<UserSearchEvent, UserSearchState> {
  final UserRepository userRepo;
  final List<User> existingUsers;
  UserSearchBloc({required this.userRepo, this.existingUsers = const []})
      : super(USS_Complete()) {
    on<USE_InputChanged>(_inputChanged);
    on<USE_InputSubmitted>(_inputSubmitted);
  }

  _inputChanged(USE_InputChanged event, Emitter<UserSearchState> emit) {
    if (event.input.isEmpty) {
      emit(USS_Complete(existingUsers));
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
      emit(USS_Complete(existingUsers));
    } else if (_hasInputError(event.input)) {
      emit(USS_ErrorState());
    } else {
      var list = _getFromUsersProfile(event);
      if (list.isEmpty && event.input.isNotEmpty) {
        var user = await userRepo.fetchUserByPhoneNumberOrEmail(event.input);
        list = user != null ? [user] : [];
      }
      emit(USS_Complete(list));
    }
  }

  List<User> _getFromUsersProfile(event) {
    return existingUsers.where((element) {
      return element.name.contains(event.input) ||
          (element.phoneNumber ?? '').contains(event.input) ||
          (element.email ?? '').contains(event.input);
    }).toList();
  }

  _hasInputError(String text) => text.contains(RegExp(r"[^0-9a-zA-Z@.]+"));
}
