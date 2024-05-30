import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../firebase/StorageHelper.dart';

class ImageFirestoredWidget extends StatelessWidget {
  ImageFirestoredWidget(
      {this.uri,
      this.imageBuf,
      this.color,
      this.rounded = false,
      this.radius,
      this.width,
      this.height});

  final String? uri;
  final Uint8List? imageBuf;
  final Color? color;
  final double? radius;
  final bool? rounded;
  final double? width;
  final double? height;

  _imageRender(String? imageUrl) {
    if (imageUrl != null) {
      return rounded! && !kIsWeb
          ? Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.grey[800]!,
                  width: 1.25,
                ),
              ),
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: radius!,
                backgroundImage: NetworkImage(imageUrl),
              ))
          : Image.network(imageUrl,
              width: width, height: height, fit: BoxFit.fill);
    } else if (imageBuf != null) {
      return CircleAvatar(
          radius: radius!, backgroundImage: MemoryImage(imageBuf!));
    } else {
      return CircleAvatar(
        backgroundColor: Colors.transparent,
      );
    }
  }

  Future<String> _imageFetch() {
    return StorageHelper.downloadUrl(uri).then((result) {
      return result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: _imageFetch(),
        builder: (context, AsyncSnapshot<String> snapshot) {
          return Container(color: color, child: _imageRender(snapshot.data));
        });
  }
}
