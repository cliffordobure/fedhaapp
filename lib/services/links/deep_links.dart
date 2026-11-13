import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:fedha/data/services/service.dart';
import 'package:flutter/foundation.dart';

class AppLinksDeepLink {
  AppLinksDeepLink._privateConstructor();

  static final AppLinksDeepLink _instance =
      AppLinksDeepLink._privateConstructor();

  static AppLinksDeepLink get instance => _instance;

  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  Future<void> initialize() async {
    _appLinks = AppLinks();
    await initDeepLinks();
  }

  Future<void> initDeepLinks() async {
    // Check initial link if app was in cold state (terminated)
    try {
      final appLink = await _appLinks.getInitialLink();
      if (appLink != null) {
        _handleAppLink(appLink);
      }
    } on Exception catch (e) {
      debugPrint('Error getting initial app link: $e');
    }

    // Handle link when app is in warm state (front or background)
    _linkSubscription = _appLinks.uriLinkStream.listen(
      _handleAppLink,
      onError: (err) {
        debugPrint('Error in app link stream: $err');
      },
    );
  }

  void _handleAppLink(Uri uri) {
    debugPrint('Received app link: $uri');
    // Here you can implement your logic to handle the deep link
    // For example, navigate to a specific screen based on the URI
  }

  void dispose() {
    _linkSubscription?.cancel();
  }
}
