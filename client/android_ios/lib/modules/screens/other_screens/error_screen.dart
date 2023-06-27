import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  final bool materialAppWraper;
  const ErrorScreen(
    this.materialAppWraper, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const scaffold = Scaffold(
      body: Center(child: Text('Ooops... Error Occor!')),
    );
    return materialAppWraper ? const MaterialApp(home: scaffold) : scaffold;
  }
}
