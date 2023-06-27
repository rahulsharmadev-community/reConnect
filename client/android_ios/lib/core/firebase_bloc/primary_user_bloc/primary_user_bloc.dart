import 'dart:async';
import 'package:meta/meta.dart';
import 'package:shared/firebase_api/firebase_api.dart';
import 'package:shared/models/_models.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:shared/models/bloc_utils/basic_bloc_data.dart';
import 'package:shared/shared.dart';
part 'primary_user_event.dart';
part 'primary_user_state.dart';

class PrimaryUserBloc
    extends HydratedBloc<PrimaryUserBlocEvent, PrimaryUserState> {
  final UserRepository userRepository;
  PrimaryUser? get primaryUser => state is PrimaryUserLoaded
      ? (state as PrimaryUserLoaded).primaryUser
      : null;

  PrimaryUserBloc(this.userRepository) : super(PrimaryUserLoading()) {
    on<PrimaryUserIntial>((event, emit) => emit(PrimaryUserLoaded(event.user)));
    on<PrimaryUserDispose>(
        (event, emit) => emit(PrimaryUserError('Unauthorised')));
    on<FetchCompleteProfile>(onFetchCompleteProfile);
    on<UpdateSettings>(onUpdateSettings);
    on<EditProfileImg>(onEditProfileImg);
    on<EditName>(onEditName);
    on<EditPhoneNumber>(onEditPhoneNumber);
  }

  FutureOr<void> onFetchCompleteProfile(
      FetchCompleteProfile event, Emitter<PrimaryUserState> emit) async {
    final PrimaryUser primaryUser;

    /// Fetch primary From Server
    /// ///
    // emit(primary(primary));
  }

  FutureOr<void> onUpdateSettings(
      UpdateSettings event, Emitter<PrimaryUserState> emit) async {
    /// Sending Data to Server
    ///
    emit(PrimaryUserLoaded(primaryUser!.copyWith(settings: event.settings)));
  }

  FutureOr<void> onEditProfileImg(
      EditProfileImg event, Emitter<PrimaryUserState> emit) async {
    final user = (state as PrimaryUserLoaded).primaryUser;

    emit(PrimaryUserLoaded(user.copyWith(
      profileImg: const BlocData.updating(),
    )));

    /// After Updating to Data to Server Update
    /// ///

    emit(PrimaryUserLoaded(user.copyWith(
      profileImg: BlocData.finished(event.img),
    )));
  }

  FutureOr<void> onEditName(EditName event, Emitter<PrimaryUserState> emit) {
    final user = (state as PrimaryUserLoaded).primaryUser;

    emit(PrimaryUserLoaded(user.copyWith(
      name: const BlocData.updating(),
    )));

    /// After Updating to Data to Server Update
    /// ///

    emit(PrimaryUserLoaded(user.copyWith(
      name: BlocData.finished(event.name),
    )));
  }

  FutureOr<void> onEditPhoneNumber(
      EditPhoneNumber event, Emitter<PrimaryUserState> emit) {
    final user = (state as PrimaryUserLoaded).primaryUser;

    emit(PrimaryUserLoaded(user.copyWith(
      phoneNumber: const BlocData.updating(),
    )));

    /// After Updating to Data to Server Update
    /// ///

    emit(PrimaryUserLoaded(user.copyWith(
      phoneNumber: BlocData.finished(event.phoneNumber),
    )));
  }

  @override
  PrimaryUserState? fromJson(Map<String, dynamic> json) =>
      PrimaryUserState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(PrimaryUserState state) => state.toJson;
}
