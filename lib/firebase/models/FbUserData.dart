import 'package:flashcoffee/firebase/models/FbKey.dart';
import 'package:flashcoffee/firebase/models/FbReference.dart';
import 'package:sprintf/sprintf.dart';

import 'FbCreditCard.dart';

class FbUserData {
  static final String _refBase = "users/";
  static final String _photoUri = "/users/%s/profile/rosto01.jpeg";

  late FbKey key;

  FbCreditCard? creditCard;

  static FbReference refBuilderToLoad(String userUid) {
    return FbReference(_refBase + userUid);
  }

  String? getPhotoUri() {
    return sprintf(_photoUri, [key.getKey()]);
  }
}
