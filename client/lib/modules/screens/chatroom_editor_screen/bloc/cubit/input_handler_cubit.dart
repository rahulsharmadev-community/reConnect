import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:reConnect/core/APIs/firebase_api/src/firestore_api/chatrooms_api.dart';
import 'package:reConnect/core/APIs/github_api/github_repository_api.dart';
import 'package:reConnect/core/BLOCs/primary_user_bloc/primary_user_bloc.dart';
import 'package:shared/fcm_service/fcm_service.dart';
import 'package:shared/shared.dart';
import 'package:uuid/uuid.dart';

part 'input_handler_state.dart';

class InputHandlerCubit extends Cubit<InputHandlerCubitState> {
  final PrimaryUserBloc primaryUserBloc;
  final ChatRoomsApi chatRoomsApi;
  final GitHubRepositoryService gitHubpVault;
  final bool isEditing;

  bool get hasReadyForSubmit => state.nameText.length > 2 && state.total > 2;

  InputHandlerCubit(
      {required this.primaryUserBloc,
      required this.chatRoomsApi,
      required this.isEditing,
      required this.gitHubpVault})
      : super(InputHandlerCubitState());

  Future<void> submit() async {
    try {
      if (hasReadyForSubmit) {
        final room = ChatRoomInfo(
            createdBy: primaryUserBloc.primaryUser!.userId,
            about: state.descriptionText,
            profileImg: state.profileImg,
            name: state.nameText,
            administrators: state.administrators,
            members: state.members,
            moderators: state.moderators,
            visitor: state.visitors);

        await Future.wait([
          chatRoomsApi.createNewChatRoom(room, false),
          FCMs.subscribeToTopic(room.chatRoomId)
        ]);
        primaryUserBloc.add(PrimaryUserEvent.addingChatRoom(room));
      }
    } catch (e) {
      throw '$e';
    }
  }

  Future<void> uploadProfileToServer(
      {required Uint8List bytes, required String extension}) async {
    var filePath = '$extension/${const Uuid().v4()}.$extension';
    var url = await gitHubpVault.uploadBytes(filePath, bytes);
    emit(state.copyWith(profileImg: url));
  }

  void addTo({required ChatRoomRole role, required String userId}) {
    removeFrom(userId: userId);
    emit(state.copyWith(
      administrators: [
        ...state.administrators,
        if (role == ChatRoomRole.administrators) userId
      ],
      moderators: [
        ...state.moderators,
        if (role == ChatRoomRole.moderators) userId
      ],
      members: [...state.members, if (role == ChatRoomRole.members) userId],
      visitors: [...state.visitors, if (role == ChatRoomRole.visitor) userId],
    ));
  }

  void removeFrom({required String userId}) {
    var admins = List<String>.from(state.administrators)..remove(userId);
    var moderators = List<String>.from(state.moderators)..remove(userId);
    var members = List<String>.from(state.members)..remove(userId);
    var visitors = List<String>.from(state.visitors)..remove(userId);
    emit(state.copyWith(
      administrators: admins,
      members: members,
      moderators: moderators,
      visitors: visitors,
    ));
  }

  void onSearchChange(String input) => emit(state.copyWith(searchText: input));
  void onNameChange(String input) => emit(state.copyWith(nameText: input));
  void onDescriptionChange(String input) =>
      emit(state.copyWith(descriptionText: input));
}
