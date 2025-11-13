import 'package:flutter/material.dart';
import 'package:vrooom/core/common/widgets/custom_app_bar.dart';
import 'package:vrooom/core/common/widgets/settings_widget.dart';

class EditProfileDetails extends StatelessWidget {
  const EditProfileDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(title: "Edit Profile Details"),
      body: SettingsWidget(popScreen: true),
    );
  }
}
