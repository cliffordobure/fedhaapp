import 'package:url_launcher/url_launcher.dart';

Future<void> launchPrivacyAndPolicy() async {
  final Uri url = Uri.parse('https://fedhatrac.com/privacy-policy/');
  final canLaunch = await canLaunchUrl(url);
  print('Can launch URL: $canLaunch'); // Debug log

  if (canLaunch) {
    await launchUrl(url, mode: LaunchMode.externalApplication);
  } else {
    throw 'Could not launch $url';
  }
}
