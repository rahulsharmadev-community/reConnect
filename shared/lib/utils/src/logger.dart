import 'package:shared/extensions/datetime/datetime.ext.dart';

Object _lastMsg = '';
void logs(Object msg) {
  print(
      '- logs: ${msg == _lastMsg ? '(SAME AS LAST)' : '(NEW)'} [${(DateTime.now().format().hms())}]: $msg');
  _lastMsg = msg;
}
