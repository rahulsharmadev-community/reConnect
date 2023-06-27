import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  final bool materialAppWraper;
  const LoadingScreen(
    this.materialAppWraper, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const scaffold = Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
    return materialAppWraper ? const MaterialApp(home: scaffold) : scaffold;
  }
}
