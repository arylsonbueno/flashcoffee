import 'package:flashcoffee/firebase/models/FbKey.dart';

class FbReference {

  final String? url;

  FbReference(this.url);

  String? getUrl() {
    return url;
  }

  String getUrlWithKey(FbKey key) {
    return url! + "/" + key.getKey();
  }

}