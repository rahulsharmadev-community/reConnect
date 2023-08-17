// ignore_for_file: camel_case_types

part of 'user_search_cubit.dart';

abstract class UserSearchState {}

// Indicates that have some data to show.
class UserSearchCompleted extends UserSearchState {
  final List<User> contacts;
  final List<ChatRoomInfo> chatRooms;
  UserSearchCompleted({this.contacts = const [], this.chatRooms = const []});
}

// Represents an error state, indicating that there is an issue with the user input.
class UserSearchErrorState extends UserSearchState {
  final String msg;
  UserSearchErrorState(this.msg);
}
