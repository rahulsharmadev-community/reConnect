import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared/shared.dart';

part 'privacy_handling_event.dart';
part 'privacy_handling_state.dart';

class PrivacyHandlingBloc
    extends Bloc<PrivacyHandlingEvent, PrivacyHandlingState> {
  PrivacyType get activeState {
    switch (state.runtimeType) {
      case PrivacyHandlingNobody:
        return PrivacyType.nobody;
      case PrivacyHandlingOnly:
        return PrivacyType.only;
      case PrivacyHandlingExcept:
        return PrivacyType.except;
      default:
        return PrivacyType.everybody;
    }
  }

  PrivacyHandlingBloc() : super(PrivacyHandlingLoading()) {
    on<SetPrivacyState>((event, emit) {
      switch (event.privacy.type) {
        case PrivacyType.everybody:
          emit(PrivacyHandlingEverybody());
        case PrivacyType.nobody:
          emit(PrivacyHandlingNobody());
        case PrivacyType.only:
          emit(PrivacyHandlingOnly(event.privacy.only));
        case PrivacyType.except:
          emit(PrivacyHandlingExcept(event.privacy.except));
        default:
          emit(PrivacyHandlingLoading());
      }
    });
  }
}
