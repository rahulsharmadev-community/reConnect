import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reConnect/core/authentication_bloc/authentication_bloc.dart';

import 'widgets/aggrement_text.dart';
part 'widgets/registeration_form.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var remaningHeight = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).padding.top + kToolbarHeight);
    return MaterialApp(
      theme: ThemeData.dark(useMaterial3: true),
      home: Scaffold(
        appBar: buildAppBar(),
        body: SingleChildScrollView(
          child: SizedBox(
            height: remaningHeight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _RegisterationForm(
                  onRegister: (name, email, phoneNo) => context
                      .read<AuthenticationBloc>()
                      .add(DeviceRegistration(
                          name: name, email: email, phoneNumber: phoneNo)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    var expanded = Expanded(
      child: Container(
        height: 3,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(3)),
      ),
    );
    return AppBar(
        title: Row(
      children: [
        expanded,
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.0),
          child: Text(
            "Registration",
            style: TextStyle(
                fontSize: 26, fontWeight: FontWeight.w500, color: Colors.white),
          ),
        ),
        expanded
      ],
    ));
  }
}
