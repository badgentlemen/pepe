import 'dart:math';

import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:pepe/components/solar_panel.dart';
import 'package:pepe/models/plant_type.dart';
import 'package:uuid/uuid.dart';

import 'components/plant.dart';

SpriteAnimation fetchAmimation({
  required Images images,
  required String of,
  required String type,
  required Vector2 size,
  required int amount,
}) {
  final path = '$of/$type (${size.x.toInt()}x${size.y.toInt()}).png';

  print(path);

  return SpriteAnimation.fromFrameData(
    images.fromCache(path),
    SpriteAnimationData.sequenced(
      amount: amount,
      stepTime: 1 / amount,
      textureSize: size,
    ),
  );
}

int random(int min, int max) {
  return min + Random().nextInt(max - min);
}
