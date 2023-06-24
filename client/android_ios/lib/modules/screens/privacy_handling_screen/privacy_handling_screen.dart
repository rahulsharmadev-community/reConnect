import 'package:flutter/material.dart';
import 'package:reConnect/utility/navigation/app_navigator.dart';
import 'package:shared/models/user.dart';

class PrivacyHandlingScreen extends StatelessWidget {
  final Privacy privacy;
  final String? title, subtitle;
  PrivacyHandlingScreen(this.privacy, {super.key, this.title, this.subtitle});

  back() => AppNavigator.on((router) => router.pop<Privacy>(privacy));

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
