import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';

class SO {

  static Future<bool> checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.wifi
        || connectivityResult == ConnectivityResult.ethernet
        || connectivityResult == ConnectivityResult.mobile) {
      return true;
    }
    if (isTest()) return true;
    return false;
  }

  /***
   * Get Device Connection Status
   * @param context Calling Context.
   * @return Connectivity signal status value which is based on Network Info

  public static String getConnectionStatus(Context context) {
    NetworkInfo info = Connectivity.getNetworkInfo(context);
    if (info == null || !info.isConnected()) {
      return Constants.ConnectionSignalStatus.NO_CONNECTIVITY;
    } else if (Connectivity.getInternetStatus(info.getType(), info.getSubtype(), context) == 3
        && Utils.getBatteryPercentageDouble(context) > 20) {
      return Constants.ConnectionSignalStatus.GOOD_STRENGTH;
    } else if (Connectivity.getInternetStatus(info.getType(), info.getSubtype(), context) >= 2
        && Utils.getBatteryPercentageDouble(context) > 20) {
      return Constants.ConnectionSignalStatus.FAIR_STRENGTH;
    } else if (Connectivity.getInternetStatus(info.getType(), info.getSubtype(), context) >= 2
        && Utils.getBatteryPercentageDouble(context) <= 20) {
      return Constants.ConnectionSignalStatus.BATTERY_LOW;
    } else {
      return Constants.ConnectionSignalStatus.POOR_STRENGTH;
    }
  }
   */
  static String generateMd5(String data) {
    return crypto.md5.convert(utf8.encode(data)).toString();
  }

  static String getLocale() {
    //TODO: get location via web
    if (kIsWeb) return "pt_BR";
    List<String> itens = Platform.localeName.split('_');
    String countryCode = itens[0];
    String languageCode = itens.length > 1 ? itens[1] : countryCode;
    return countryCode + "_" + languageCode;
  }

  static bool isAndroid() {
    if (kIsWeb) return false;
    return Platform.isAndroid;
  }

  static bool isIos() {
    if (kIsWeb) return false;
    return Platform.isIOS;
  }

  static bool isTest() {
    return Platform.environment.containsKey('FLUTTER_TEST');
  }

  static bool inDebugMode() {
    return kDebugMode;
  }
}