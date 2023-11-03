import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:pepe/constants.dart';
import 'package:pepe/utils.dart';

enum PlantType {
  /// арбуз
  watermelon,

  /// морковь
  carrot,

  /// кукуруза
  corn,
}

extension PlantTypeExt on PlantType {
  Sprite fetchSprite(Images gameImages) {
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

  /// Частота удара + стрельбы
  double get fireFrequency => 4;

  /// Время перехода из зерна в полноценное растение
  int get growingUpTimeSec => 3;
}

