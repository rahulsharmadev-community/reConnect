// ignore_for_file: camel_case_types

part of 'user_search_bloc.dart';

class UserSearchState extends Equatable {
  @override
  List<Object> get props => [];
}

// Indicates that have some data to show.
class USS_Complete extends UserSearchState {
  final List<User> list;
  USS_Complete([this.list = const []]);
  @override
  List<Object> get props => [list];
}

// Represents an error state, indicating that there is an issue with the user input.
class USS_ErrorState extends UserSearchState {}
