import 'package:flutter/material.dart';
import 'package:vrooom/core/common/widgets/settings_widget.dart';
import 'package:vrooom/presentation/admin/widgets/admin_drawer.dart';

import '../../widgets/admin_app_bar.dart';

class AdminSettingsPage extends StatelessWidget {
  const AdminSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AdminAppBar(title: "Admin Settings"),
      drawer: AdminDrawer(),
      body: SettingsWidget(popScreen: false),
    );
  }
}
