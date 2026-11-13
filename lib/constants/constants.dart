import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

const BASE_URL = "https://app.fedhatrac.com/api/";
// const BASE_URL = "http://10.0.2.2:8000/api/";

// const BASE_URL = "https://fedhatrac.awasam.site/";

const TIMEOUT = 30000;

// String TOKEN = "TOKEN";
// String USER_DATA_KEY = "USER_DATA_KEY";

enum SpanDuration {
  weekly,
  monthly,
  yearly,
}

// Zoom drawer controller
final ZoomDrawerController zoomDrawerController = ZoomDrawerController();

List<String> supportedBanks = [
  "MPESA",
  "CoopBank",
  "NCBA_BANK",
  "StanChart",
  "Stanbic",
  "Equity Bank",
  "I&M Bank",
];
