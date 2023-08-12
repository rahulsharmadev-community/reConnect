import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class ChatRoomPermissions extends Equatable {
  final bool canReadMessage;
  final bool canSendTextMessage;
  final bool canSendVoiceMessage;
  final bool canReplyOnMessage;
  final bool canReactOnMessage;
  final bool canAttachFiles;
  final bool canInviteMembers;
  final bool canViewMembersList;
  final bool canViewMembersProfile;
  final bool canPinMessage;
  final bool canKickMembers;
  final bool canEditChatRoomName;
  final bool canEditChatRoomAbout;
  final bool canEditChatRoomProfileImg;
  final bool canPromoteDemoteVisiter;
  final bool canPromoteDemoteMembers;
  final bool canPromoteDemoteModerators;
  final bool canPromoteDemoteAdministrators;

  const ChatRoomPermissions({
    required this.canReadMessage,
    required this.canSendTextMessage,
    required this.canSendVoiceMessage,
    required this.canReplyOnMessage,
    required this.canReactOnMessage,
    required this.canAttachFiles,
    required this.canInviteMembers,
    required this.canViewMembersList,
    required this.canViewMembersProfile,
    required this.canPinMessage,
    required this.canKickMembers,
    required this.canEditChatRoomName,
    required this.canEditChatRoomAbout,
    required this.canEditChatRoomProfileImg,
    required this.canPromoteDemoteVisiter,
    required this.canPromoteDemoteMembers,
    required this.canPromoteDemoteModerators,
    required this.canPromoteDemoteAdministrators,
  });

  ChatRoomPermissions copyWith({
    bool? canReadMessage,
    bool? canSendTextMessage,
    bool? canSendVoiceMessage,
    bool? canReplyOnMessage,
    bool? canReactOnMessage,
    bool? canAttachFiles,
    bool? canInviteMembers,
    bool? canViewMembersList,
    bool? canViewMembersProfile,
    bool? canPinMessage,
    bool? canKickMembers,
    bool? canEditChatRoomName,
    bool? canEditChatRoomAbout,
    bool? canEditChatRoomProfileImg,
    bool? canPromoteDemoteVisiter,
    bool? canPromoteDemoteMembers,
    bool? canPromoteDemoteModerators,
    bool? canPromoteDemoteAdministrators,
  }) =>
      ChatRoomPermissions(
        canReadMessage: canReadMessage ?? this.canReadMessage,
        canSendTextMessage: canSendTextMessage ?? this.canSendTextMessage,
        canSendVoiceMessage: canSendVoiceMessage ?? this.canSendVoiceMessage,
        canReplyOnMessage: canReplyOnMessage ?? this.canReplyOnMessage,
        canReactOnMessage: canReactOnMessage ?? this.canReactOnMessage,
        canAttachFiles: canAttachFiles ?? this.canAttachFiles,
        canInviteMembers: canInviteMembers ?? this.canInviteMembers,
        canViewMembersList: canViewMembersList ?? this.canViewMembersList,
        canViewMembersProfile:
            canViewMembersProfile ?? this.canViewMembersProfile,
        canPinMessage: canPinMessage ?? this.canPinMessage,
        canKickMembers: canKickMembers ?? this.canKickMembers,
        canEditChatRoomName: canEditChatRoomName ?? this.canEditChatRoomName,
        canEditChatRoomAbout: canEditChatRoomAbout ?? this.canEditChatRoomAbout,
        canEditChatRoomProfileImg:
            canEditChatRoomProfileImg ?? this.canEditChatRoomProfileImg,
        canPromoteDemoteVisiter:
            canPromoteDemoteVisiter ?? this.canPromoteDemoteVisiter,
        canPromoteDemoteMembers:
            canPromoteDemoteMembers ?? this.canPromoteDemoteMembers,
        canPromoteDemoteModerators:
            canPromoteDemoteModerators ?? this.canPromoteDemoteModerators,
        canPromoteDemoteAdministrators: canPromoteDemoteAdministrators ??
            this.canPromoteDemoteAdministrators,
      );

  factory ChatRoomPermissions.fromMap(
          ChatRoomPermissions DEFAULT, Map<String, dynamic>? map) =>
      map == null
          ? DEFAULT
          : ChatRoomPermissions(
              canReadMessage: map["canReadMessage"] ?? DEFAULT.canReadMessage,
              canSendTextMessage:
                  map["canSendTextMessage"] ?? DEFAULT.canSendTextMessage,
              canSendVoiceMessage:
                  map["canSendVoiceMessage"] ?? DEFAULT.canSendVoiceMessage,
              canReplyOnMessage:
                  map["canReplyOnMessage"] ?? DEFAULT.canReplyOnMessage,
              canReactOnMessage:
                  map["canReactOnMessage"] ?? DEFAULT.canReactOnMessage,
              canAttachFiles: map["canAttachFiles"] ?? DEFAULT.canAttachFiles,
              canInviteMembers:
                  map["canInviteMembers"] ?? DEFAULT.canInviteMembers,
              canViewMembersList:
                  map["canViewMembersList"] ?? DEFAULT.canViewMembersList,
              canViewMembersProfile:
                  map["canViewMembersProfile"] ?? DEFAULT.canViewMembersProfile,
              canPinMessage: map["canPinMessage"] ?? DEFAULT.canPinMessage,
              canKickMembers: map["canKickMembers"] ?? DEFAULT.canKickMembers,
              canEditChatRoomName:
                  map["canEditChatRoomName"] ?? DEFAULT.canEditChatRoomName,
              canEditChatRoomAbout:
                  map["canEditChatRoomAbout"] ?? DEFAULT.canEditChatRoomAbout,
              canEditChatRoomProfileImg: map["canEditChatRoomProfileImg"] ??
                  DEFAULT.canEditChatRoomProfileImg,
              canPromoteDemoteVisiter: map["canPromoteDemoteVisiter"] ??
                  DEFAULT.canPromoteDemoteVisiter,
              canPromoteDemoteMembers: map["canPromoteDemoteMembers"] ??
                  DEFAULT.canPromoteDemoteMembers,
              canPromoteDemoteModerators: map["canPromoteDemoteModerators"] ??
                  DEFAULT.canPromoteDemoteModerators,
              canPromoteDemoteAdministrators:
                  map["canPromoteDemoteAdministrators"] ??
                      DEFAULT.canPromoteDemoteAdministrators,
            );

  Map<String, dynamic> toMap(ChatRoomPermissions DEFAULT) => {
        if (DEFAULT.canReadMessage != canReadMessage)
          "canReadMessage": canReadMessage,
        if (DEFAULT.canSendTextMessage != canSendTextMessage)
          "canSendTextMessage": canSendTextMessage,
        if (DEFAULT.canSendVoiceMessage != canSendVoiceMessage)
          "canSendVoiceMessage": canSendVoiceMessage,
        if (DEFAULT.canReplyOnMessage != canReplyOnMessage)
          "canReplyOnMessage": canReplyOnMessage,
        if (DEFAULT.canReactOnMessage != canReactOnMessage)
          "canReactOnMessage": canReactOnMessage,
        if (DEFAULT.canAttachFiles != canAttachFiles)
          "canAttachFiles": canAttachFiles,
        if (DEFAULT.canInviteMembers != canInviteMembers)
          "canInviteMembers": canInviteMembers,
        if (DEFAULT.canViewMembersList != canViewMembersList)
          "canViewMembersList": canViewMembersList,
        if (DEFAULT.canViewMembersProfile != canViewMembersProfile)
          "canViewMembersProfile": canViewMembersProfile,
        if (DEFAULT.canPinMessage != canPinMessage)
          "canPinMessage": canPinMessage,
        if (DEFAULT.canKickMembers != canKickMembers)
          "canKickMembers": canKickMembers,
        if (DEFAULT.canEditChatRoomName != canEditChatRoomName)
          "canEditChatRoomName": canEditChatRoomName,
        if (DEFAULT.canEditChatRoomAbout != canEditChatRoomAbout)
          "canEditChatRoomAbout": canEditChatRoomAbout,
        if (DEFAULT.canEditChatRoomProfileImg != canEditChatRoomProfileImg)
          "canEditChatRoomProfileImg": canEditChatRoomProfileImg,
        if (DEFAULT.canPromoteDemoteVisiter != canPromoteDemoteVisiter)
          "canPromoteDemoteVisiter": canPromoteDemoteVisiter,
        if (DEFAULT.canPromoteDemoteMembers != canPromoteDemoteMembers)
          "canPromoteDemoteMembers": canPromoteDemoteMembers,
        if (DEFAULT.canPromoteDemoteModerators != canPromoteDemoteModerators)
          "canPromoteDemoteModerators": canPromoteDemoteModerators,
        if (DEFAULT.canPromoteDemoteAdministrators !=
            canPromoteDemoteAdministrators)
          "canPromoteDemoteAdministrators": canPromoteDemoteAdministrators,
      };

  @override
  List<Object?> get props => [
        canReadMessage,
        canSendTextMessage,
        canSendVoiceMessage,
        canReplyOnMessage,
        canReactOnMessage,
        canAttachFiles,
        canInviteMembers,
        canViewMembersList,
        canViewMembersProfile,
        canPinMessage,
        canKickMembers,
        canEditChatRoomName,
        canEditChatRoomAbout,
        canEditChatRoomProfileImg,
        canPromoteDemoteVisiter,
        canPromoteDemoteMembers,
        canPromoteDemoteModerators,
        canPromoteDemoteAdministrators
      ];
}
