import 'package:url_launcher/url_launcher.dart';

class EmailLauncher {
  static Future<void> open(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw Exception('Error occured while opening mail app.');
    }
  }
}
