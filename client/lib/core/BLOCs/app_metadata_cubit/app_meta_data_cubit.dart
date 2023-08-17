import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:reConnect/core/APIs/firebase_api/firebase_api.dart';
import 'package:shared/shared.dart';

@immutable
class AppMetaData {
  final BlocData<ChatRoomRoles> chatRoomRoles;
  final BlocData<String> aboutUs;
  final BlocData<String> contactUs;
  final BlocData<String> privacyPolicy;
  final BlocData<String> termsOfService;

  const AppMetaData.idle()
      : chatRoomRoles = const BlocData.idle(),
        aboutUs = const BlocData.idle(),
        contactUs = const BlocData.idle(),
        privacyPolicy = const BlocData.idle(),
        termsOfService = const BlocData.idle();

  const AppMetaData({
    required this.chatRoomRoles,
    required this.aboutUs,
    required this.contactUs,
    required this.privacyPolicy,
    required this.termsOfService,
  });

  AppMetaData copyWith({
    BlocData<ChatRoomRoles>? chatRoomRoles,
    BlocData<String>? aboutUs,
    BlocData<String>? contactUs,
    BlocData<String>? privacyPolicy,
    BlocData<String>? termsOfService,
  }) =>
      AppMetaData(
          chatRoomRoles: chatRoomRoles ?? this.chatRoomRoles,
          aboutUs: aboutUs ?? this.aboutUs,
          contactUs: contactUs ?? this.contactUs,
          privacyPolicy: privacyPolicy ?? this.privacyPolicy,
          termsOfService: termsOfService ?? this.termsOfService);
}

class AppMetaDataCubit extends Cubit<AppMetaData> {
  final AppMetaDataApi api;
  AppMetaDataCubit({required this.api}) : super(const AppMetaData.idle());

  Future<void> fetchChatRoomDefaultPermissions() async {
    if (state.chatRoomRoles.hasData) return;

    emit(state.copyWith(chatRoomRoles: const BlocData.processing()));
    final roles = await api.chatRoomDefaultPermissions();
    emit(state.copyWith(chatRoomRoles: BlocData.finished(roles)));
  }

  Future<void> fetchAboutUs() async {
    if (state.aboutUs.hasData) return;

    emit(state.copyWith(aboutUs: const BlocData.processing()));
    final aboutUs = await api.aboutUs();
    emit(state.copyWith(aboutUs: BlocData.finished(aboutUs)));
  }

  Future<void> fetchContactUs() async {
    if (state.contactUs.hasData) return;

    emit(state.copyWith(contactUs: const BlocData.processing()));
    final contactUs = await api.contactUs();
    emit(state.copyWith(contactUs: BlocData.finished(contactUs)));
  }

  Future<void> fetchPrivacyPolicy() async {
    if (state.privacyPolicy.hasData) return;

    emit(state.copyWith(privacyPolicy: const BlocData.processing()));
    final privacyPolicy = await api.privacyPolicy();
    emit(state.copyWith(privacyPolicy: BlocData.finished(privacyPolicy)));
  }

  Future<void> fetchTermsOfService() async {
    if (state.termsOfService.hasData) return;

    emit(state.copyWith(termsOfService: const BlocData.processing()));
    final termsOfService = await api.termsOfService();
    emit(state.copyWith(termsOfService: BlocData.finished(termsOfService)));
  }
}
