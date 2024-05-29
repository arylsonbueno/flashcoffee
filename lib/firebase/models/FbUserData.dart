import 'package:flashcoffee/firebase/models/FbKey.dart';
import 'package:flashcoffee/firebase/models/FbReference.dart';
import 'package:sprintf/sprintf.dart';

import 'FbCreditCard.dart';

class FbUserData {
  static final String _refBase = "users/";

  late FbKey key;

  FbCreditCard? creditCard;

  static FbReference refBuilderToLoad(String userUid) {
    return FbReference(_refBase + userUid);
  }

}
