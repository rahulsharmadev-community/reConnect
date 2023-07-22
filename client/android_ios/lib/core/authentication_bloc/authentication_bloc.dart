import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:reConnect/core/firebase_bloc/primary_user_bloc/primary_user_bloc.dart';
import 'package:reConnect/core/APIs/firebase_api/firebase_api.dart';
import 'package:shared/shared.dart';
part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final DeviceInfo deviceInfo;
  final PrimaryUserRepository userRepo;
  final PrimaryUserBloc primaryUserBloc;
  AuthenticationBloc(
      {required this.deviceInfo,
      required this.userRepo,
      required this.primaryUserBloc})
      : super(AuthenticatingState()) {
    on<CheckDeviceRegistered>(onCheckDeviceRegistered);
    on<DeviceRegistration>(onDeviceRegistration);
  }

  FutureOr<void> onCheckDeviceRegistered(
      CheckDeviceRegistered event, Emitter<AuthenticationState> emit) async {
    final primaryUser = await userRepo.fetchPrimaryUser();

    if (primaryUser != null) {
      emit(Authorized(primaryUser));
      primaryUserBloc.add(PrimaryUserEvent.initialize(primaryUser));
    } else {
      emit(Unauthorized());
      primaryUserBloc.add(PrimaryUserEvent.dispose());
    }
  }

  FutureOr<void> onDeviceRegistration(
      DeviceRegistration event, Emitter<AuthenticationState> emit) async {
    var newUser = PrimaryUser(
      deviceInfo: deviceInfo,
      name: event.name,
      email: event.email,
      phoneNumber: event.phoneNumber,
    );
    await userRepo.CreatePrimaryUserAccount(newUser);
    emit(Authorized(newUser));
    primaryUserBloc.add(PrimaryUserEvent.initialize(newUser));
  }
}
