part of 'realtime_repository/primary_user_repository.dart';

final logs = Logs('Firebase Exception Handler');
mixin FirebaseExceptionHandler {
  Future<T?> errorHandler<T>(Future<T?> Function() callback) async {
    try {
      return await callback();
    } on FirebaseException catch (ferror) {
      logs.severeError(ferror.message);
    } catch (error) {
      logs.severeError('$error');
    }
    return null;
  }
}
