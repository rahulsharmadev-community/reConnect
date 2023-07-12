// ignore_for_file: camel_case_types

part of 'user_search_bloc.dart';

abstract class UserSearchState {}

// Indicates that have some data to show.
class USS_Complete extends UserSearchState {
  final List<User> contacts;
  final List<ChatRoomInfo> chatRooms;
  USS_Complete({this.contacts = const [], this.chatRooms = const []});
}

// Represents an error state, indicating that there is an issue with the user input.
class USS_ErrorState extends UserSearchState {}
