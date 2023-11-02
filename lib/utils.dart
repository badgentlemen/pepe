import 'dart:math';

import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:pepe/models/plant_type.dart';
import 'package:uuid/uuid.dart';

import 'components/plant.dart';

SpriteAnimation fetchAmimation({
  required Images images,
  required String of,
  required String type,
  required Vector2 size,
  required int amount,
  required double speed,
}) =>
    SpriteAnimation.fromFrameData(
      images.fromCache('$of/$type (${size.x.toInt()}x${size.y.toInt()}).png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: 1 / amount,
        textureSize: size,
      ),
    );

int random(int min, int max) {
  return min + Random().nextInt(max - min);
}
