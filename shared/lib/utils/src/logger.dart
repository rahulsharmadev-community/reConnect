import 'package:shared/extensions/datetime/datetime.ext.dart';

Object _lastMsg = '';
void logs(Object msg) {
  print(
      '\n_________________________________________________________________________________________________________\n'
      '    - logs: ${msg == _lastMsg ? '(SAME AS LAST)' : '(NEW)'} [${(DateTime.now().format().hms())}]: \n      $msg'
      '\n￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣\n');
  _lastMsg = msg;
}
