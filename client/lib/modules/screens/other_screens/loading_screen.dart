import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  final bool materialAppWraper;
  final bool canPop;
  const LoadingScreen({
    this.materialAppWraper = false,
    this.canPop = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final scaffold = WillPopScope(
      onWillPop: () async => canPop,
      child: const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
    );
    return materialAppWraper ? MaterialApp(home: scaffold) : scaffold;
  }
}
