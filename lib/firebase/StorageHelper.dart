import 'dart:typed_data';
import 'dart:async';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import '../utils/so.dart';
import 'models/FbFile.dart';

class UploadDone {
  bool success;
  UploadDone(this.success);
}

class StorageHelper {

  Future<UploadDone> _upload(String path, Uint8List data) async {
    //custom metadata.
    /*
    SettableMetadata custom_metadata = SettableMetadata(
      customMetadata: metadata.toJson(),
    );
    //METADATA sem funcao por enquanto
    final UploadTask uploadTask = storageReference.putData(data, custom_metadata);
    */

    final Reference storageReference = FirebaseStorage.instance.ref().child(path);
    final UploadTask uploadTask = storageReference.putData(data);

    uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
      print('Task state: ${snapshot.state}');
      print('Progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100} %');
    }, onError: (e) {
      // this can include 2 additional states, `TaskState.error` & `TaskState.canceled`
      print(e);
    });

    bool success = false;
    try {
      await uploadTask;
      print('Upload complete.');
      success = true;
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        print('User does not have permission to upload to this reference.');
      }
    }
    UploadDone upDone = UploadDone(success);
    return upDone;
  }

  Future<UploadDone> upload(FbFile fbFile) async {
    return _upload(fbFile.getUrl()!, fbFile.getData()!)
        .timeout(
          Duration(seconds: 20),
          onTimeout: () { throw ("Sem Internet?"); }
    );
  }

  static Future<dynamic> downloadUrl(String? path) async {
    if (path == null) return null;

    bool connected = await SO.checkInternetConnection();
    if (!connected) return null;

    final Reference storageReference = FirebaseStorage.instance.ref().child(path);
    return storageReference.getDownloadURL();
  }

  static Future<Uint8List?> downloadAsByteAsync(String? path) async {
    try {
      dynamic filePath = await downloadUrl(path);
      Uint8List bytes = await http.readBytes(Uri.parse(filePath));
      return bytes;
    } catch(e) {
      print(e);
    }
    return null;
  }

}