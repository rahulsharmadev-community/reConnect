part of 'login_user_bloc_bloc.dart';

@immutable
abstract class LoginUserBlocEvent {}


class FetchCompleteProfile extends LoginUserBlocEvent {
  final String userId;
  FetchCompleteProfile(this.userId);
}

class UpdateCompleteProfile extends LoginUserBlocEvent {
  final LogInUser user;

  UpdateCompleteProfile(this.user);
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
