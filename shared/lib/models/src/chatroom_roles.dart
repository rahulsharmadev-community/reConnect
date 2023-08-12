import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:shared/models/src/chatroom_users_permissions.dart';

@immutable
class ChatRoomRoles extends Equatable {
  final ChatRoomPermissions administrators;
  final ChatRoomPermissions members;
  final ChatRoomPermissions moderators;
  final ChatRoomPermissions visitors;

  const ChatRoomRoles(
      {this.administrators = DEFAULT_ADMINISTRATORS,
      this.members = DEFAULT_MEMBERS,
      this.moderators = DEFAULT_MODERATORS,
      this.visitors = DEFAULT_VISITER});

  ChatRoomRoles copyWith(
          {ChatRoomPermissions? administrators,
          ChatRoomPermissions? members,
          ChatRoomPermissions? moderators,
          ChatRoomPermissions? visitors}) =>
      ChatRoomRoles(
          administrators: administrators ?? this.administrators,
          members: members ?? this.members,
          moderators: moderators ?? this.moderators,
          visitors: visitors ?? this.visitors);

  static ChatRoomRoles fromMap(Map<String, dynamic> map) => ChatRoomRoles(
      administrators: ChatRoomPermissions.fromMap(
          DEFAULT_ADMINISTRATORS, map["administrators"]),
      members: ChatRoomPermissions.fromMap(DEFAULT_MEMBERS, map["members"]),
      moderators:
          ChatRoomPermissions.fromMap(DEFAULT_MODERATORS, map["moderators"]),
      visitors: ChatRoomPermissions.fromMap(DEFAULT_VISITER, map["visitors"]));

  Map<String, dynamic> get toMap => {
        if (DEFAULT_ADMINISTRATORS != administrators)
          "administrators": administrators.toMap(DEFAULT_ADMINISTRATORS),
        if (DEFAULT_MEMBERS != administrators)
          "members": members.toMap(DEFAULT_MEMBERS),
        if (DEFAULT_MODERATORS != administrators)
          "moderators": moderators.toMap(DEFAULT_MODERATORS),
        if (DEFAULT_VISITER != administrators)
          "visitors": visitors.toMap(DEFAULT_VISITER)
      };

  static const DEFAULT_VISITER = ChatRoomPermissions(
      canReadMessage: true,
      canSendTextMessage: false,
      canSendVoiceMessage: false,
      canReplyOnMessage: false,
      canReactOnMessage: false,
      canAttachFiles: false,
      canInviteMembers: false,
      canViewMembersList: false,
      canViewMembersProfile: false,
      canPinMessage: false,
      canKickMembers: false,
      canEditChatRoomName: false,
      canEditChatRoomAbout: false,
      canEditChatRoomProfileImg: false,
      canPromoteDemoteVisiter: false,
      canPromoteDemoteMembers: false,
      canPromoteDemoteModerators: false,
      canPromoteDemoteAdministrators: false);
  static const DEFAULT_MEMBERS = ChatRoomPermissions(
      canReadMessage: true,
      canSendTextMessage: true,
      canSendVoiceMessage: true,
      canReplyOnMessage: true,
      canReactOnMessage: true,
      canAttachFiles: true,
      canInviteMembers: false,
      canViewMembersList: true,
      canViewMembersProfile: true,
      canPinMessage: false,
      canKickMembers: false,
      canEditChatRoomName: false,
      canEditChatRoomAbout: false,
      canEditChatRoomProfileImg: false,
      canPromoteDemoteVisiter: true,
      canPromoteDemoteMembers: false,
      canPromoteDemoteModerators: false,
      canPromoteDemoteAdministrators: false);

  static const DEFAULT_MODERATORS = ChatRoomPermissions(
      canReadMessage: true,
      canSendTextMessage: true,
      canSendVoiceMessage: true,
      canReplyOnMessage: true,
      canReactOnMessage: true,
      canAttachFiles: true,
      canInviteMembers: true,
      canViewMembersList: true,
      canViewMembersProfile: true,
      canPinMessage: true,
      canKickMembers: true,
      canEditChatRoomName: true,
      canEditChatRoomAbout: true,
      canEditChatRoomProfileImg: true,
      canPromoteDemoteMembers: true,
      canPromoteDemoteVisiter: true,
      canPromoteDemoteModerators: false,
      canPromoteDemoteAdministrators: false);

  static const DEFAULT_ADMINISTRATORS = ChatRoomPermissions(
      canReadMessage: true,
      canSendTextMessage: true,
      canSendVoiceMessage: true,
      canReplyOnMessage: true,
      canReactOnMessage: true,
      canAttachFiles: true,
      canInviteMembers: true,
      canViewMembersList: true,
      canViewMembersProfile: true,
      canPinMessage: true,
      canKickMembers: true,
      canEditChatRoomName: true,
      canEditChatRoomAbout: true,
      canEditChatRoomProfileImg: true,
      canPromoteDemoteMembers: true,
      canPromoteDemoteVisiter: true,
      canPromoteDemoteModerators: true,
      canPromoteDemoteAdministrators: true);

  @override
  List<Object?> get props => [administrators, members, moderators, visitors];
}
