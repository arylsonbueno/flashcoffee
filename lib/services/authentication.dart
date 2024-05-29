import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flashcoffee/firebase/FirebaseHelper.dart';
import 'package:flashcoffee/firebase/models/FbCreditCard.dart';

import '../firebase/models/FbFcmToken.dart';
import '../firebase/models/FbKey.dart';
import '../firebase/models/FbUserData.dart';
import '../utils/so.dart';
import 'analytics.dart';

abstract class BaseAuth {
  Future<String?> signIn(String? email, String? password);

  Future<User?> getCurrentUser();

  Future<void> signOut();

//Future<String> signUp(String email, String password);
  Future<bool> isEmailVerified();

  Future<void> sendEmailVerification();
}

class Auth implements BaseAuth {
  static FirebaseAuth _auth = FirebaseAuth.instance;
  static User? _userSession;

  static Future<FbUserData> _readUserData(String userUid,
      {required Duration timeout}) {
    return FirebaseHelper.readNode(FbUserData.refBuilderToLoad(userUid),
            timeout: timeout)
        .then((event) {
      DataSnapshot dataSnap = event.snapshot;
      FbUserData userData = FbUserData();
      userData.key = FbKey(userUid);
      String? name = dataSnap.child('creditCard').child('name').value as String?;
      String? number = dataSnap.child('creditCard').child('number').value as String?;
      int? securityCode = dataSnap.child('creditCard').child('securityCode').value as int?;
      userData.creditCard = FbCreditCard(name, number, securityCode);
      return userData;
    });
  }

  static Future<void> _writeUserMessagingToken(
      String userUid, String? fcmToken) async {
    FbFcmToken msg = FbFcmToken(userUid, fcmToken);
    FirebaseHelper.findNode(msg.getRef(), "fcmToken", fcmToken)
        .then((DatabaseEvent value) => {
              if (value.snapshot.exists)
                {
                  FirebaseHelper.update(
                          '${msg.getRef()}/${value.snapshot.children.first.key}',
                          msg.toMap())
                      .then((success) {
                    print(success
                        ? 'Messaging Token updated! $fcmToken'
                        : 'FAIL Write Messaging Token');
                  })
                }
              else
                {
                  FirebaseHelper.insert(msg.getRef(), msg.toMap())
                      .then((success) {
                    print(success
                        ? 'Messaging Token inserted! $fcmToken'
                        : 'FAIL Write Messaging Token');
                  })
                }
            });
  }

  _messagingRegistration(String userUid) async {
    FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
      //necessary send token to application server.
      _writeUserMessagingToken(userUid, fcmToken);
    }).onError((err) {
      print(err);
    });
    //check if need gentoken
    FirebaseMessaging.instance
        .getToken()
        .then((fcmToken) => _writeUserMessagingToken(userUid, fcmToken));
  }

  _loadSessionData(User user) async {
    try {
      if (await SO.checkInternetConnection()) {
        Duration timeout = Duration(seconds: 10);
        print('loading ${user.uid}');
        await _readUserData(user.uid, timeout: timeout)
            .then((FbUserData userData) async {
          _userSession = user;
          await _messagingRegistration(user.uid);
          Analytics.addEventLogin();
        });
      }
    } catch (e) {
      print("Error in _loadSessionData: " + e.toString());
    }
  }

  _loadSession(User user) async {
    await _loadSessionData(user);
  }

  Future<String?> signIn(String? email, String? password) async {
    UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email!, password: password!);
    User? user = result.user;
    if (user != null) await _loadSession(user);
    if (_userSession != null) return _userSession!.uid;
    return null;
  }

  Future<String> signUp(String email, String password) async {
    UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    User? user = result.user;
    return user!.uid;
  }

  Future<void> sendEmailVerification() async {
    _auth.setLanguageCode(SO.getLocale());
    User user = await _auth.currentUser!;
    user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    User user = await _auth.currentUser!;
    return user.emailVerified;
  }

  Future<User?> getCurrentUser() async {
    User? user = await _auth.currentUser;
    return user;
  }

  Future<String?> getBearerToken() async {
    String? idToken = await _auth.currentUser!.getIdToken();
    return idToken;
  }

  Future<void> signOut() async {
    _userSession = null;
    return _auth.signOut();
  }

}
