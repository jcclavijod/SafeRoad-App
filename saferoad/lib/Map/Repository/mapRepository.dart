import 'dart:async';
import 'dart:ui' as ui;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart';

class MapRepository {
  Future<BitmapDescriptor> getMarkerIcon(String assetName, int size) async {
    final ByteData imageData = await rootBundle.load(assetName);
    final Uint8List bytes = imageData.buffer.asUint8List();
    final ui.Codec codec =
        await ui.instantiateImageCodec(bytes, targetWidth: 150);
    final ui.FrameInfo frameInfo = await codec.getNextFrame();
    final ByteData? resizedImage =
        await frameInfo.image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List markerBytes = resizedImage!.buffer.asUint8List();
    return BitmapDescriptor.fromBytes(markerBytes);
  }


  
}
