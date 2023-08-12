import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  final bool materialAppWraper;
  final bool canPop;
  const ErrorScreen(
 {
       this.materialAppWraper = false,
    this.canPop = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final scaffold = WillPopScope(
        onWillPop: () async => canPop,
        child: const Scaffold(
          body: Center(child: Text('Ooops... Error Occor!')),
        ));
    return materialAppWraper ? MaterialApp(home: scaffold) : scaffold;
  }
}
