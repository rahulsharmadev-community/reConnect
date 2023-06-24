part of 'login_user_bloc.dart';

@immutable
abstract class LoginUserBlocEvent {}

class LoginUserIntial extends LoginUserBlocEvent {
  final LogInUser user;
  LoginUserIntial(this.user);
}

class LoginUserDispose extends LoginUserBlocEvent {}

class FetchCompleteProfile extends LoginUserBlocEvent {
  final String userId;
  FetchCompleteProfile(this.userId);
}

class UpdateSettings extends LoginUserBlocEvent {
  final UserSettings settings;

  UpdateSettings(this.settings);
}

class EditProfileImg extends LoginUserBlocEvent {
  final String img;
  EditProfileImg(this.img);
}

class EditName extends LoginUserBlocEvent {
  final String name;
  EditName(this.name);
}

class EditPhoneNumber extends LoginUserBlocEvent {
  final String phoneNumber;
  EditPhoneNumber(this.phoneNumber);
}
