part of 'user_search_bloc.dart';

@immutable
abstract class UserSearchEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// ignore: camel_case_types
class USE_InputChanged extends UserSearchEvent {
  final String input;
  USE_InputChanged(this.input);

  @override
  List<Object?> get props => [input];
}

// ignore: camel_case_types
class USE_InputSubmitted extends UserSearchEvent {
  final String input;
  USE_InputSubmitted(this.input);

  @override
  List<Object?> get props => [input];
}
