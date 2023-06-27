part of 'primary_user_bloc.dart';

@immutable
abstract class PrimaryUserBlocEvent {}

class PrimaryUserIntial extends PrimaryUserBlocEvent {
  final PrimaryUser user;
  PrimaryUserIntial(this.user);
}

class PrimaryUserDispose extends PrimaryUserBlocEvent {}

class FetchCompleteProfile extends PrimaryUserBlocEvent {
  final String userId;
  FetchCompleteProfile(this.userId);
}

class UpdateSettings extends PrimaryUserBlocEvent {
  final UserSettings settings;

  UpdateSettings(this.settings);
}

class EditProfileImg extends PrimaryUserBlocEvent {
  final String img;
  EditProfileImg(this.img);
}

class EditName extends PrimaryUserBlocEvent {
  final String name;
  EditName(this.name);
}

class EditPhoneNumber extends PrimaryUserBlocEvent {
  final String phoneNumber;
  EditPhoneNumber(this.phoneNumber);
}
