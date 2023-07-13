import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:reConnect/core/firebase_api/firebase_api.dart';
import 'package:shared/models/models.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:shared/shared.dart';
part 'primary_user_event.dart';
part 'primary_user_state.dart';

class PrimaryUserBloc extends HydratedBloc<PrimaryUserEvent, PrimaryUserState> {
  final PrimaryUserRepository _userRepository;

  PrimaryUser? get primaryUser => state is PrimaryUserLoaded
      ? (state as PrimaryUserLoaded).primaryUser
      : null;

  PrimaryUserBloc(this._userRepository) : super(PrimaryUserLoading()) {
    on<PrimaryUserInitialize>(
        (event, emit) => emit(PrimaryUserLoaded(event.user)));
    on<PrimaryUserDispose>(
        (event, emit) => emit(PrimaryUserError('Unauthorised')));
    on<UpdateSettings>(onUpdateSettings);
    on<UpdateProfile>(onUpdateProfile);
    on<UpdateChatRooms>(onUpdateChatRooms);
    on<UpdateContacts>(onUpdateContacts);
  }

  FutureOr<void> onUpdateSettings(
      UpdateSettings event, Emitter<PrimaryUserState> emit) async {
    final oldValue = primaryUser!;
    var newValue = oldValue.copyWith(settings: event.settings);
    await _userRepository.updateSettings(event.settings, oldValue.settings);
    emit(PrimaryUserLoaded(newValue));
  }

  /// This Values NOT change \
  /// [settings, chatRooms, contacts, deviceInfo]
  FutureOr<void> onUpdateProfile(UpdateProfile event, emit) async {
    final newUser = event.to(primaryUser!);
    await _userRepository.updateProfile(newUser, primaryUser!);
    emit(PrimaryUserLoaded(newUser));
  }

  onUpdateChatRooms(UpdateChatRooms event, emit) async {
    var rooms = primaryUser!.chatRooms;
    var ids = event.rooms.map((e) => e.chatRoomId).toList();

    /// Checking Operation
    if (event.isRemoveOperation) {
      rooms.removeWhere((element) => event.rooms.contains(element));
      await _userRepository.removeExistingChatRoomIds(ids);
      emit(PrimaryUserLoaded(primaryUser!.copyWith(chatRooms: rooms)));
    } else {
      rooms += event.rooms;
      await _userRepository.addNewChatRoomIds(ids);
      emit(PrimaryUserLoaded(primaryUser!.copyWith(chatRooms: rooms)));
    }
  }

  onUpdateContacts(UpdateContacts event, emit) async {
    var contact = primaryUser!.contacts;
    var ids = event.contacts.map((e) => e.userId).toList();

    /// Checking Operation
    if (event.isRemoveOperation) {
      contact.removeWhere((element) => event.contacts.contains(element));
      await _userRepository.removeExistingContactsIds(ids);
      emit(PrimaryUserLoaded(primaryUser!.copyWith(contacts: contact)));
    } else {
      contact += event.contacts;
      await _userRepository.addNewContactsIds(ids);
      emit(PrimaryUserLoaded(primaryUser!.copyWith(contacts: contact)));
    }
  }

  @override
  PrimaryUserState? fromJson(Map<String, dynamic> json) =>
      PrimaryUserState.fromMap(json);

  @override
  Map<String, dynamic>? toJson(PrimaryUserState state) => state.toMap;
}
