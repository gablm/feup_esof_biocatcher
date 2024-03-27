import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapIndicator {
  MapIndicator({required this.text, required this.offset,
    required this.x, required this.y, required this.zoom, this.fontSize,
    this.color});
  String text;
  Offset offset;
  int x;
  int y;
  int zoom;
  double? fontSize;
  Color? color;
}

class MapTileProvider implements TileProvider {
  MapTileProvider({this.mapPlaces = const {}, this.showBorder = false}) {
    boxPaint.isAntiAlias = true;
    boxPaint.color = Colors.blue;
    boxPaint.strokeWidth = 2.0;
    boxPaint.style = PaintingStyle.stroke;
  }

  Set<MapIndicator> mapPlaces = {};
  bool showBorder = false;
  static const int width = 500;
  static const int height = 500;
  static final Paint boxPaint = Paint();

  @override
  Future<Tile> getTile(int x, int y, int? zoom) async {
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);

    var filteredPlaces = mapPlaces.where(
            (element) => element.x == x && element.y == y && element.zoom == zoom);
    for (MapIndicator indicator in filteredPlaces)
    {
      final TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: indicator.text,
          style: TextStyle(
            color: indicator.color,
            fontSize: indicator.fontSize,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout(
        minWidth: 0.0,
        maxWidth: width.toDouble(),
      );
      textPainter.paint(canvas, indicator.offset);
    }

    if (showBorder) {
      canvas.drawRect(Rect.fromLTRB(0, 0, width.toDouble(), width.toDouble()), boxPaint);
    }

    final ui.Picture picture = recorder.endRecording();
    final Uint8List byteData = await picture
        .toImage(width, height)
        .then((ui.Image image) =>
        image.toByteData(format: ui.ImageByteFormat.png))
        .then((ByteData? byteData) => byteData!.buffer.asUint8List());
    return Tile(width, height, byteData);
  }
}