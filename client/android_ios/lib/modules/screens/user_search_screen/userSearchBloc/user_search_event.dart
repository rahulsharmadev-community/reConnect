part of 'user_search_bloc.dart';

@immutable
abstract class UserSearchEvent {
  static UserSearchInputChangedEvent inputChange(String input) =>
      UserSearchInputChangedEvent(input);

  static UserSearchInputSubmittedEvent inputSubmitted(String input) =>
      UserSearchInputSubmittedEvent(input);
}

// ignore: camel_case_types
class UserSearchInputChangedEvent extends UserSearchEvent {
  final String input;
  UserSearchInputChangedEvent(this.input);
}

// ignore: camel_case_types
class UserSearchInputSubmittedEvent extends UserSearchEvent {
  final String input;
  UserSearchInputSubmittedEvent(this.input);
}
