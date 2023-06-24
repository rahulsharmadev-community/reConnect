import 'dart:async';
import 'package:meta/meta.dart';
import 'package:shared/firebase_api/firebase_api.dart';
import 'package:shared/models/_models.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:shared/models/bloc_utils/basic_bloc_data.dart';
import 'package:shared/shared.dart';
part 'login_user_event.dart';
part 'login_user_state.dart';

class LoginUserBloc extends HydratedBloc<LoginUserBlocEvent, LoginUserState> {
  final UserRepository userRepository;
  LogInUser? get logInUser =>
      state is LoginUserLoaded ? (state as LoginUserLoaded).logInUser : null;

  LoginUserBloc(this.userRepository) : super(LoginUserLoading()) {
    on<LoginUserIntial>((event, emit) => emit(LoginUserLoaded(event.user)));
    on<LoginUserDispose>((event, emit) => emit(LoginUserError('Unauthorised')));
    on<FetchCompleteProfile>(onFetchCompleteProfile);
    on<UpdateSettings>(onUpdateSettings);
    on<EditProfileImg>(onEditProfileImg);
    on<EditName>(onEditName);
    on<EditPhoneNumber>(onEditPhoneNumber);
  }

  FutureOr<void> onFetchCompleteProfile(
      FetchCompleteProfile event, Emitter<LoginUserState> emit) async {
    final LogInUser logInUser;

    /// Fetch loginUserData From Server
    /// ///
    // emit(LoginUserLoaded(logInUser));
  }

  FutureOr<void> onUpdateSettings(
      UpdateSettings event, Emitter<LoginUserState> emit) async {
    /// Sending Data to Server
    ///
    emit(LoginUserLoaded(logInUser!.copyWith(settings: event.settings)));
  }

  FutureOr<void> onEditProfileImg(
      EditProfileImg event, Emitter<LoginUserState> emit) async {
    final user = (state as LoginUserLoaded).logInUser;

    emit(LoginUserLoaded(user.copyWith(
      profileImg: const BlocData.updating(),
    )));

    /// After Updating to Data to Server Update
    /// ///

    emit(LoginUserLoaded(user.copyWith(
      profileImg: BlocData.finished(event.img),
    )));
  }

  FutureOr<void> onEditName(EditName event, Emitter<LoginUserState> emit) {
    final user = (state as LoginUserLoaded).logInUser;

    emit(LoginUserLoaded(user.copyWith(
      name: const BlocData.updating(),
    )));

    /// After Updating to Data to Server Update
    /// ///

    emit(LoginUserLoaded(user.copyWith(
      name: BlocData.finished(event.name),
    )));
  }

  FutureOr<void> onEditPhoneNumber(
      EditPhoneNumber event, Emitter<LoginUserState> emit) {
    final user = (state as LoginUserLoaded).logInUser;

    emit(LoginUserLoaded(user.copyWith(
      phoneNumber: const BlocData.updating(),
    )));

    /// After Updating to Data to Server Update
    /// ///

    emit(LoginUserLoaded(user.copyWith(
      phoneNumber: BlocData.finished(event.phoneNumber),
    )));
  }

  @override
  LoginUserState? fromJson(Map<String, dynamic> json) =>
      LoginUserState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(LoginUserState state) => state.toJson;
}
