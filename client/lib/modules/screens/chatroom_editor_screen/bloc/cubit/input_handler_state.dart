part of 'input_handler_cubit.dart';

@immutable
class InputHandlerCubitState {
  final String? profileImg;
  final String searchText;
  final String nameText;
  final String descriptionText;
  final List<String> administrators;
  final List<String> members;
  final List<String> moderators;
  final List<String> visitors;
  final int total;

  const InputHandlerCubitState({
    this.profileImg,
    this.searchText = '',
    this.nameText = '',
    this.descriptionText = '',
    this.administrators = const [],
    this.members = const [],
    this.moderators = const [],
    this.visitors = const [],
  }) : total = administrators.length +
            members.length +
            moderators.length +
            visitors.length;

  InputHandlerCubitState copyWith({
    List<String>? administrators,
    List<String>? members,
    List<String>? moderators,
    List<String>? visitors,
    String? profileImg,
    String? searchText,
    String? nameText,
    String? descriptionText,
  }) =>
      InputHandlerCubitState(
        nameText: nameText ?? this.nameText,
        descriptionText: descriptionText ?? this.descriptionText,
        searchText: searchText ?? this.searchText,
        profileImg: profileImg ?? this.profileImg,
        administrators: administrators ?? this.administrators,
        members: members ?? this.members,
        moderators: moderators ?? this.moderators,
        visitors: visitors ?? this.visitors,
      );
}
