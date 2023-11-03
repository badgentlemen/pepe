import 'package:pepe/constants.dart';

enum PlantType {
  /// арбуз
  watermelon,

  /// морковь
  carrot,

  /// кукуруза
  corn,
}

extension PlantTypeExt on PlantType {
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

