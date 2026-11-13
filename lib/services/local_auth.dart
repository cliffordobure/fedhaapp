import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuth {
  static final _auth = LocalAuthentication();

  // Check if can authenticate
  static Future<bool> _canAuthenticate() async =>
      await _auth.canCheckBiometrics || await _auth.isDeviceSupported();

  static Future<bool> authenticate() async {
    try {
      if (!await _canAuthenticate()) {
        return false;
      }

      return await _auth.authenticate(
          localizedReason: 'Authenticate to continue',
          // authMessages: [IOSAuthMessages(), AndroidAuthMessages()],
          options: const AuthenticationOptions(
              useErrorDialogs: true, stickyAuth: true));
    } catch (e) {
      debugPrint("Error $e");
      return false;
    }
  }
}
