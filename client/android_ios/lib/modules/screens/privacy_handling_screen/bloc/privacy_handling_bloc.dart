import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared/shared.dart';

part 'privacy_handling_event.dart';
part 'privacy_handling_state.dart';

class PrivacyHandlingBloc
    extends Bloc<PrivacyHandlingEvent, PrivacyHandlingState> {
  PrivacyType get activeState {
    switch (state.runtimeType) {
      case PHS_Nobody:
        return PrivacyType.nobody;
      case PHS_Only:
        return PrivacyType.only;
      case PHS_Except:
        return PrivacyType.except;
      default:
        return PrivacyType.everybody;
    }
  }

  PrivacyHandlingBloc() : super(PHS_Loading()) {
    on<SetPrivacyState>((event, emit) {
      switch (event.privacy.type) {
        case PrivacyType.everybody:
          emit(PHS_Everybody());
        case PrivacyType.nobody:
          emit(PHS_Nobody());
        case PrivacyType.only:
          emit(PHS_Only(event.privacy.only));
        case PrivacyType.except:
          emit(PHS_Except(event.privacy.except));
        default:
          emit(PHS_Loading());
      }
    });
  }
}
