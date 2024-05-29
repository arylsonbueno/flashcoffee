import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

class DefaultFirebaseOptions {

  static FirebaseOptions get currentPlatform {
    return web;
  }

  static const FirebaseOptions web = FirebaseOptions(
      apiKey: "AIzaSyD2NTWDRf71SPcStWWXIMlQZWGaXizeejc",
      authDomain: "flashcoffee-32259.firebaseapp.com",
      projectId: "flashcoffee-32259",
      storageBucket: "flashcoffee-32259.appspot.com",
      messagingSenderId: "726315864158",
      appId: "1:726315864158:web:4e4679d8641f9640abe4cf",
      measurementId: "G-475PPL19Q7",
      databaseURL: "https://flashcoffee-32259-default-rtdb.firebaseio.com"
  );

}