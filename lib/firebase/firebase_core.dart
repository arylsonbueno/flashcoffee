import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import '../utils/so.dart';
import 'firebase_options.dart';

class FirebaseCore {
  static FirebaseApp? app;

  static init() async {
    if (kIsWeb) {
      app = await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
    } else {
      app = await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      if (SO.isAndroid()) {
        FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
      }
    }
  }
}
