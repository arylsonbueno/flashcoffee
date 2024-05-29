class FbFcmToken {

  static final String _refBase = "messaging/";
  final String userUid;
  final String? fcmToken;
  //https://firebase.google.com/docs/cloud-messaging/manage-tokens
  final String valid = DateTime.now().add(Duration(days: 60)).toIso8601String();

  FbFcmToken(this.userUid, this.fcmToken);

  String getRef() {
    return '$_refBase$userUid';
  }

  Map<String, dynamic> toMap() {
    return {
      'fcmToken': fcmToken,
      'valid': valid
    };
  }

}