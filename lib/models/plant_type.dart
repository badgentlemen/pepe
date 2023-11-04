import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:pepe/constants.dart';
import 'package:pepe/utils.dart';

enum PlantType {
  /// арбуз
  watermelon,

  /// кукуруза
  corn,

  /// морковь
  carrot,
}

extension PlantTypeExt on PlantType {
  Color get color {
    switch (this) {
      case PlantType.carrot:
        return Colors.orange.shade400;
      case PlantType.corn:
        return Colors.yellow.shade400;
      case PlantType.watermelon:
        return Colors.red.shade600;
    }
  }

  double get spiteAspectRatio {
    switch (this) {
      case PlantType.carrot:
        return carrotAssetRatio;
      case PlantType.corn:
        return cornAssetRatio;
      case PlantType.watermelon:
        return watermelonAssetRatio;
    }
  }

  Vector2 aspectSize(double width) => Vector2(width, width * spiteAspectRatio);

  Sprite fetchGrassSprite(Images gameImages) {
    switch (this) {
      case PlantType.watermelon:
        return fetchGrassAt(gameImages, x: 10, y: 0, size: 3);
      case PlantType.carrot:
        return fetchGrassAt(gameImages, x: 19, y: 0, size: 3);
      case PlantType.corn:
      default:
        return fetchGrassAt(gameImages, x: 13, y: 0, size: 3);
    }
  }

  Sprite fetchSprite(Images gameImages) {
    switch (this) {
      case PlantType.corn:
        return Sprite(gameImages.fromCache('corn.png'));
      case PlantType.carrot:
        return Sprite(gameImages.fromCache('carrot.png'));
      case PlantType.watermelon:
        return Sprite(gameImages.fromCache('watermelon.png'));
    }
  }

  int get health => defaultHealth;

  /// Наносимый урон
  int get damage => defaultDamage;

  /// Стоимость
  int get costs {
    switch (this) {
      case PlantType.watermelon:
        return 100;
      case PlantType.corn:
        return 150;
      case PlantType.carrot:
        return 200;
    }
  }

  /// Время от зерна до растения в миллисекундах
  int get growingTimeInMs {
    switch (this) {
      case PlantType.watermelon:
        return 500;
      case PlantType.corn:
        return 1500;
      case PlantType.carrot:
        return 2800;
    }
  }

  /// Частота удара + стрельбы
  double get fireFrequency => 4;
}
