import 'package:firebase_analytics/firebase_analytics.dart';

class Analytics {
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  static addEventLogin() async {
    await analytics.logLogin();
  }

  static setCurrentScreen(String screenName) async {
    await analytics.logScreenView(screenName: screenName);
  }

  static addEvent(String eventName,
      {String? valueString, int? valueInt}) async {
    Map<String, dynamic> params = Map();
    if (valueString != null && valueString.length <= 100)
      params.putIfAbsent('string', () => valueString);
    if (valueInt != null) params.putIfAbsent('int', () => valueInt);

    await analytics.logEvent(name: eventName, parameters: params);
    print('Event sent: ${eventName}');
  }
}
