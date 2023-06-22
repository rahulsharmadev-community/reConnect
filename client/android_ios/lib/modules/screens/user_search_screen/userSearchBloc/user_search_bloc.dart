// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:shared/shared.dart';

import '../service.dart';
part 'user_search_event.dart';
part 'user_search_state.dart';

class UserSearchBloc extends Bloc<UserSearchEvent, UserSearchState> {
  final List<User> existingUsers;
  UserSearchBloc(this.existingUsers) : super(USS_Complete()) {
    on<USE_InputChanged>(_inputChanged);
    on<USE_InputSubmitted>(_inputSubmitted);
  }

  _inputChanged(USE_InputChanged event, Emitter<UserSearchState> emit) {
    if (event.input.isEmpty) {
      emit(USS_Complete(existingUsers));
    } else if (_isErrorInput(event.input)) {
      emit(USS_ErrorState());
    } else {
      var list = existingUsers
          .where((element) =>
              element.name.contains(event.input) ||
              (element.phoneNumber ?? '').contains(event.input) ||
              (element.email ?? '').contains(event.input))
          .toList();
      emit(USS_Complete(list));
    }
  }

  _inputSubmitted(
      USE_InputSubmitted event, Emitter<UserSearchState> emit) async {
    if (event.input.isEmpty) {
      emit(USS_Complete(existingUsers));
    } else if (_isErrorInput(event.input)) {
      emit(USS_ErrorState());
    } else {
      var list = existingUsers
          .where((element) =>
              element.name.contains(event.input) ||
              (element.phoneNumber ?? '').contains(event.input) ||
              (element.email ?? '').contains(event.input))
          .toList();
      if (list.isEmpty && event.input.isNotEmpty) {
        if (!event.input.contains(RegExp(r'[^0-9]+'))) {
          list = await Service.findByPhoneNumber(event.input);
        } else {
          list = await Service.findByEmail(event.input);
        }
      }
      emit(USS_Complete(list));
    }
  }

  _isErrorInput(String text) => text.contains(RegExp(r"[^0-9a-zA-Z@.]+"));
}
