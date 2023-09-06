part of 'primary_user_bloc.dart';

@immutable
abstract class PrimaryUserEvent {
  static PrimaryUserInitialize initialize(PrimaryUser user) =>
      PrimaryUserInitialize(user);
  static PrimaryUserDispose dispose() => PrimaryUserDispose();

  static FetchCompleteProfile fetchCompleteProfile(String userId) =>
      FetchCompleteProfile(userId);

  static UpdateSettings updateSettings(UserSettings settings) =>
      UpdateSettings(settings);

  static UpdateProfile updateProfile(
          {String? name,
          String? email,
          String? phoneNumber,
          String? about,
          String? profileImg}) =>
      UpdateProfile(
          name: name,
          email: email,
          phoneNumber: phoneNumber,
          about: about,
          profileImg: profileImg);

  static addingChatRoom(ChatRoomInfo room) => UpdateChatRooms.byAdding(room);
  static removingChatRooms(List<ChatRoomInfo> rooms) =>
      UpdateChatRooms.byRemoving(rooms);

  static addingContacts(List<User> contacts) =>
      UpdateContacts.byAdding(contacts);
  static removingContacts(List<User> contacts) =>
      UpdateContacts.byRemoving(contacts);
}

class PrimaryUserInitialize extends PrimaryUserEvent {
  final PrimaryUser user;
  PrimaryUserInitialize(this.user);
}

class PrimaryUserDispose extends PrimaryUserEvent {}

class FetchCompleteProfile extends PrimaryUserEvent {
  final String userId;
  FetchCompleteProfile(this.userId);
}

class UpdateSettings extends PrimaryUserEvent {
  final UserSettings settings;

  UpdateSettings(this.settings);
}

class UpdateProfile extends PrimaryUserEvent {
  final String? name, email, phoneNumber;
  final String? about, profileImg;

  UpdateProfile(
      {this.name, this.email, this.phoneNumber, this.about, this.profileImg});

  PrimaryUser to(PrimaryUser user) => user.copyWith(
      name: name,
      email: email,
      phoneNumber: phoneNumber,
      about: about,
      profileImg: profileImg);
}

class UpdateChatRooms extends PrimaryUserEvent {
  final List<ChatRoomInfo> rooms;
  final bool isRemoveOperation;
  UpdateChatRooms.byAdding(ChatRoomInfo room)
      : rooms = [room],
        isRemoveOperation = false;
  UpdateChatRooms.byRemoving(this.rooms) : isRemoveOperation = true;
}

class UpdateContacts extends PrimaryUserEvent {
  final List<User> contacts;
  final bool isRemoveOperation;
  UpdateContacts.byAdding(this.contacts) : isRemoveOperation = false;
  UpdateContacts.byRemoving(this.contacts) : isRemoveOperation = true;
}
