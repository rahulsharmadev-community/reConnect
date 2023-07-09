// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_database/firebase_database.dart';

// const FirebaseOptions android = FirebaseOptions(
//     apiKey: 'AIzaSyAbs-9aqwbw7vHdF8y-aZs6zBtRRRHvmcs',
//     appId: '1:556878679351:android:de1800453c568cc6485eb2',
//     messagingSenderId: '556878679351',
//     projectId: 're--connect',
//     storageBucket: 're--connect.appspot.com',
//     databaseURL:
//         "https://re--connect-default-rtdb.asia-southeast1.firebasedatabase.app");
// void main(List<String> arguments) async {
//   final app = await Firebase.initializeApp(options: android);
//   var url = FirebaseDatabase.instance.databaseURL;
//   print('----> Connected: $url');

//   final ref = FirebaseDatabase.instance.ref('USERS');
//   var list = ['helo', 'd09978df'];

//   // final raw = await ref
//   //     .child('1348ee9c-3144-418f-96eb-1745ad1e5bff/chatRooms')
//   //     .update(Map.fromIterable(list));

//   final raw = await ref.orderByChild("phoneNumber").equalTo('9876543210').get();

//   print('----> Connected:${(raw.value as Map)} ');
// }

import 'package:logging/logging.dart';

final log = Logger('ExampleLogger');

/// Example of configuring a logger to print to stdout.
///
/// This example will print:
///
/// INFO: 2021-09-13 15:35:10.703401: recursion: n = 4
/// INFO: 2021-09-13 15:35:10.707974: recursion: n = 3
/// Fibonacci(4) is: 3
/// Fibonacci(5) is: 5
/// SHOUT: 2021-09-13 15:35:10.708087: Unexpected negative n: -42
/// Fibonacci(-42) is: 1
void main() {
// Black:   \x1B[30m
// Red:     \x1B[31m
// Green:   \x1B[32m
// Yellow:  \x1B[33m
// Blue:    \x1B[34m
// Magenta: \x1B[35m
// Cyan:    \x1B[36m
// White:   \x1B[37m
// Reset:   \x1B[0m

  print('\x1B[Hellos\x1B[0m');
  print('\x1B[32mHellos\x1B[0m');
  print('\x1B[33mHellos\x1B[0m');
  print('\x1B[34mHellos\x1B[0m');
  print('\x1B[35mHellos\x1B[0m');
  print('\x1B[36mHellos\x1B[0m');
  print('\x1B[36mHellosssdsd\x1B[32m');
  print('\x1B[94m' + "hahAHaHA!!!" + '\x1B[0m');

  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });

  print('Fibonacci(4) is: ${fibonacci(4)}');

// skip logs less then severe.
  print('Fibonacci(5) is: ${fibonacci(5)}');

  print('Fibonacci(-42) is: ${fibonacci(-42)}');

  print('END');
}

int fibonacci(int n) {
  if (n <= 2) {
    if (n < 0) log.shout('Unexpected negative n: $n');
    return 1;
  } else {
    log.info('recursion: n = $n');
    return fibonacci(n - 2) + fibonacci(n - 1);
  }
}
