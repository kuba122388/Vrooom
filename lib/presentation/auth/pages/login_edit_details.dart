import 'package:flutter/material.dart';
import 'package:vrooom/core/common/widgets/custom_app_bar.dart';
import 'package:vrooom/core/common/widgets/settings_widget.dart';

class LoginEditDetails extends StatelessWidget {
  final String route;

  const LoginEditDetails({super.key, required this.route});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Additional information's", showBackButton: false),
      body: SettingsWidget(popScreen: false, route: route)
    );
  }
}