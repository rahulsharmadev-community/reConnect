import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:reConnect/core/APIs/firebase_api/firebase_api.dart';
import 'package:shared/models/models.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:shared/shared.dart';
part 'primary_user_event.dart';
part 'primary_user_state.dart';

class PrimaryUserBloc extends Bloc<PrimaryUserEvent, PrimaryUserState> {
  final PrimaryUserApi _primaryUserApi;

  PrimaryUser? get primaryUser => state is PrimaryUserLoaded
      ? (state as PrimaryUserLoaded).primaryUser
      : null;

  PrimaryUserBloc(this._primaryUserApi) : super(PrimaryUserLoading()) {
    on<PrimaryUserInitialize>(
        (event, emit) => emit(PrimaryUserLoaded(event.user)));
    on<PrimaryUserDispose>(
        (event, emit) => emit(PrimaryUserError('Unauthorised')));
    on<UpdateSettings>(onUpdateSettings);
    on<UpdateProfile>(onUpdateProfile);
    on<UpdateChatRooms>(onUpdateChatRoomIds);
    on<UpdateContacts>(onUpdateContacts);
  }

  FutureOr<void> onUpdateSettings(
      UpdateSettings event, Emitter<PrimaryUserState> emit) async {
    final oldValue = primaryUser!;
    var newValue = oldValue.copyWith(settings: event.settings);
    await _primaryUserApi.updateSettings(event.settings, oldValue.settings);
    emit(PrimaryUserLoaded(newValue));
  }

  /// This Values NOT change \
  /// [settings, chatRooms, contacts, deviceInfo]
  FutureOr<void> onUpdateProfile(UpdateProfile event, emit) async {
    final newUser = event.to(primaryUser!);
    await _primaryUserApi.updateProfile(newUser, primaryUser!);
    emit(PrimaryUserLoaded(newUser));
  }

  onUpdateChatRoomIds(UpdateChatRooms event, emit) async {
    Map<String, ChatRoomInfo> existingRooms = primaryUser!.chatRooms;
    List<String> ids = event.rooms.map((e) => e.chatRoomId).toList();

    /// Checking Operation
    if (event.isRemoveOperation) {
      for (var e in ids) {
        existingRooms.remove(e);
      }
      await _primaryUserApi.removeExistingChatRoomIds(ids);
    } else {
      existingRooms.addAll({event.rooms.first.chatRoomId: event.rooms.first});
      await _primaryUserApi.addNewChatRoomIds(ids);
    }
    emit(PrimaryUserLoaded(primaryUser!.copyWith(chatRooms: existingRooms)));
  }

  onUpdateContacts(UpdateContacts event, emit) async {
    var existingContacts = primaryUser!.contacts;
    var ids = event.contacts.map((e) => e.userId).toList();

    /// Checking Operation
    if (event.isRemoveOperation) {
      for (var e in ids) {
        existingContacts.remove(e);
      }
      await _primaryUserApi.removeExistingChatRoomIds(ids);
    } else {
      existingContacts
          .addAll({event.contacts.first.userId: event.contacts.first});
      await _primaryUserApi.addNewChatRoomIds(ids);
    }
    emit(PrimaryUserLoaded(primaryUser!.copyWith(contacts: existingContacts)));
  }

  // @override
  // PrimaryUserState? fromJson(Map<String, dynamic> json) =>
  //     PrimaryUserState.fromMap(json);

  // @override
  // Map<String, dynamic>? toJson(PrimaryUserState state) => state.toMap;
}
