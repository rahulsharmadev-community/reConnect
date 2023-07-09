part of 'primary_user_bloc.dart';

@immutable
abstract class PrimaryUserEvent {}

class PrimaryUserIntial extends PrimaryUserEvent {
  final PrimaryUser user;
  PrimaryUserIntial(this.user);
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
  final String? name;
  final String? email;
  final String? phoneNumber;
  final String? about;
  final String? profileImg;

  UpdateProfile({
    this.name,
    this.email,
    this.phoneNumber,
    this.about,
    this.profileImg,
  });

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
  UpdateChatRooms.byAdding(this.rooms) : isRemoveOperation = false;
  UpdateChatRooms.byRemoving(this.rooms) : isRemoveOperation = true;
}

class UpdateContacts extends PrimaryUserEvent {
  final List<User> contacts;
  final bool isRemoveOperation;
  UpdateContacts.byAdding(this.contacts) : isRemoveOperation = false;
  UpdateContacts.byRemoving(this.contacts) : isRemoveOperation = true;
}
