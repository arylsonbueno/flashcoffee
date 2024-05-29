import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flashcoffee/firebase/models/FbReference.dart';

typedef FirebaseOnAdded = void Function(DataSnapshot dataSnapshot);
typedef FirebaseOnChanged = void Function(DataSnapshot dataSnapshot);

class FirebaseHelper {

  static final bool _nonPersistOff = false;
  static FirebaseDatabase? _instance;

  static FirebaseDatabase? _getInstance() {
    if (_instance == null) {
      _instance = FirebaseDatabase.instance;
      if (!kIsWeb)
        _instance!.setPersistenceEnabled(_nonPersistOff);
    }
    return _instance;
  }

  static Future<bool> insert(String path, dynamic map,
      {FirebaseOnAdded? confirmation}) async {
    FirebaseDatabase fbdb = _getInstance()!;
    final fbdbRef = fbdb.ref();
    final dataRef = fbdbRef.child(path);
    DatabaseReference dbRef = dataRef.push();
    dbRef.set(map).timeout(
        Duration(seconds: 10),
        onTimeout: () { throw ("Sem Internet?"); }
    );

    //link confirmation event
    if (confirmation != null)
      dbRef.once().then((ds) {
        confirmation(ds.snapshot);
      });

    return true;
  }

  static Future<bool> update(String path, dynamic map) async {
    FirebaseDatabase fbdb = _getInstance()!;
    final fbdbRef = fbdb.ref();
    final dataRef = fbdbRef.child(path);
    dataRef.set(map).timeout(
        Duration(seconds: 10),
        onTimeout: () { throw ("Sem Internet?"); }
    );
    return true;
  }

  static Future<DatabaseEvent> findNode(String path,
      String attribute, dynamic value) {
    FirebaseDatabase fbdb = _getInstance()!;
    return fbdb
        .ref()
        .child(path)
        .orderByChild(attribute)
        .equalTo(value)
        .once();
  }

  static Future<DatabaseEvent> readNode(FbReference path, {required Duration timeout}) {
    FirebaseDatabase fbdb = _getInstance()!;
    return fbdb
        .ref()
        .child(path.url!)
        .once()
        .timeout(timeout);
  }

  static void readNodeOnAdd(FbReference path, FirebaseOnAdded added) {
    FirebaseDatabase fbdb = _getInstance()!;
    fbdb.ref()
        .child(path.url!)
        .once().then((event) => added(event.snapshot)
    );
  }

}