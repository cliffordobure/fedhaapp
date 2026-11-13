// ignore_for_file: unrelated_type_equality_checks

import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

/// Provide the instance of InternetConnectionObserver
final isInternetConnectedProvider = InternetConnectionObserver(Connectivity());

class InternetConnectionObserver {
  final Connectivity _connectivity;
  StreamController<bool> hasConnection = StreamController<bool>.broadcast();

  InternetConnectionObserver(this._connectivity) {
    _init();
  }

  // Start listening to network state change
  void _init() {
    _connectivity.onConnectivityChanged.listen((event) async {
      if (event == ConnectivityResult.wifi ||
          event == ConnectivityResult.mobile) {
        final isDeviceConnected = await _checkInternetConnection();
        hasConnection.sink.add(isDeviceConnected);
      } else {
        hasConnection.sink.add(false);
      }
    });
  }

  // Get the current state of network
  Future<bool> isNetConnected() async {
    return _checkInternetConnection();
  }

  // Check if there's an actual internet connection
  Future<bool> _checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  void dispose() {
    hasConnection.close();
  }
}
