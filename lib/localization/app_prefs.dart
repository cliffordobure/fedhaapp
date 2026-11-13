import 'dart:convert';

import 'package:fedha/data/models/auth/login/login_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  // Onboard use
  void onboard() async {
    var prefs = await SharedPreferences.getInstance();
    // Save boarded
    prefs.setBool("BOARDED", true);
  }

  // Check boarded
  Future<bool> isBoarded() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getBool("BOARDED") ?? false;
  }

  Future<bool> isPlannePaymentsnotifScheduled() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getBool("PaymentsnotifScheduled") ?? false;
  }

  Future<void> setPlannePaymentsnotifScheduled(bool value) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool("PaymentsnotifScheduled", value);
  }

  // Auth data
  Future<void> storeAuthData(LoginResponse data) async {
    await SharedPreferences.getInstance().then(
      (value) => value.setString("USER", jsonEncode(data.toJson())),
    );
  }

  Future<LoginResponse?> getAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString("USER");
    if (data != null) {
      return LoginResponse.fromJson(jsonDecode(data));
    }
    return null;
  }

  Future<bool?> removeUser() async {
    var prefs = await SharedPreferences.getInstance();

    return prefs.remove("USER");
  }

  // Show tutorial
  Future<bool> hasSeenTuitorial() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getBool("TUITORIAL") ?? false;
  }

  void shownTutorial() async {
    var prefs = await SharedPreferences.getInstance();
    // Save tutorial
    prefs.setBool("TUITORIAL", true);
  }

  Future<bool> hasAcceptedReadMessages() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getBool("MESSAGE") ?? false;
  }

  Future<void> rejectReadMessages() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setBool("MESSAGE", false);
  }

  Future<void> acceptReadMessages() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setBool("MESSAGE", true);
  }

  // Supported Banks
  Future<List<String>> getSupportedBanks() async {
    final prefs = await SharedPreferences.getInstance();
    final supportedBanks = prefs.getStringList("SUPPORTED_BANKS") ?? [];
    return supportedBanks;
  }

  Future<void> addSupportedBank(String bankName) async {
    final prefs = await SharedPreferences.getInstance();
    final supportedBanks = await getSupportedBanks();
    final exists = supportedBanks.any(
      (bank) => bank.toLowerCase() == bankName.toLowerCase(),
    );
    if (exists) return;
    supportedBanks.add(bankName);
    await prefs.setStringList("SUPPORTED_BANKS", supportedBanks);
  }

  Future<void> removeSupportedBank(String bankName) async {
    final prefs = await SharedPreferences.getInstance();
    final supportedBanks = await getSupportedBanks();
    final target = bankName.toLowerCase();
    supportedBanks.removeWhere((bank) => bank.toLowerCase() == target);
    await prefs.setStringList("SUPPORTED_BANKS", supportedBanks);
  }

  Future<bool> hasInstallationDate() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.containsKey("INSTALLATION_DATE");
  }

  Future<void> setInstallationDate(int timestamp) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setInt("INSTALLATION_DATE", timestamp);
  }

  Future<int?> getInstallationDate() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getInt("INSTALLATION_DATE");
  }

  Future<void> setLastReadTimestamp(int timestamp) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setInt("LAST_READ_TIMESTAMP", timestamp);
  }

  Future<int?> getLastReadTimestamp() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getInt("LAST_READ_TIMESTAMP");
  }

  /// Pending registration email OTP — survives leaving the OTP screen / app restart.
  static const _pendingOtpEmail = 'PENDING_OTP_EMAIL';
  static const _pendingOtpPhone = 'PENDING_OTP_PHONE';
  static const _pendingOtpName = 'PENDING_OTP_NAME';

  Future<void> savePendingOtpVerification({
    required String email,
    required String phone,
    String? name,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_pendingOtpEmail, email);
    await prefs.setString(_pendingOtpPhone, phone);
    if (name != null && name.isNotEmpty) {
      await prefs.setString(_pendingOtpName, name);
    }
  }

  Future<({String email, String phone, String? name})?>
      getPendingOtpVerification() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString(_pendingOtpEmail);
    final phone = prefs.getString(_pendingOtpPhone);
    if (email == null ||
        email.isEmpty ||
        phone == null ||
        phone.isEmpty) {
      return null;
    }
    return (
      email: email,
      phone: phone,
      name: prefs.getString(_pendingOtpName),
    );
  }

  Future<bool> hasPendingOtpVerification() async {
    return await getPendingOtpVerification() != null;
  }

  Future<void> clearPendingOtpVerification() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_pendingOtpEmail);
    await prefs.remove(_pendingOtpPhone);
    await prefs.remove(_pendingOtpName);
  }
}
