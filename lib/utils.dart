import 'dart:math';

import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:pepe/models/pest_type.dart';
import 'package:pepe/models/plant_type.dart';

extension DoubleExt on double {
  double toPrecision(int n) => double.parse(toStringAsFixed(n));
}

SpriteAnimation fetchAmimation(
  Images images, {
  required String of,
  required String type,
  required Vector2 size,
  required int amount,
}) {
  final path = '$of/$type (${size.x.toInt()}x${size.y.toInt()}).png';

  return SpriteAnimation.fromFrameData(
    images.fromCache(path),
    SpriteAnimationData.sequenced(
      amount: amount,
      stepTime: 1 / amount,
      textureSize: size,
    ),
  );
}

Sprite fetchGrassAt(
  Images images, {
  required int x,
  required int y,
  int size = 1,
}) {
  final spriteSize = Vector2(16.0, 16.0);
  final spritePosition = Vector2(x * spriteSize.x, y * spriteSize.y);

  return Sprite(
    images.fromCache('grass.png'),
    srcPosition: spritePosition,
    srcSize: Vector2(16.0 * size, 16.0 * size),
  );
}


int random(int min, int max) {
  return min + Random().nextInt(max - min);
}

PestType randomPestType() => PestType.values[Random().nextInt(PestType.values.length)];

PlantType randomPlantType() => PlantType.values[Random().nextInt(PlantType.values.length)];

Size fetchTextSizeByStyle(
  String text,
  TextStyle style, {
  double minWidth = 0,
  double maxWidth = double.infinity,
  int maxLines = 1,
}) {
  final textPainter = TextPainter(
    text: TextSpan(
      text: text,
      style: style,
    ),
    textDirection: TextDirection.ltr,
    maxLines: maxLines,
  )..layout(maxWidth: maxWidth, minWidth: minWidth);

  return textPainter.size;
}
