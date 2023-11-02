import 'package:pepe/constants.dart';

enum PlantType {
  peas,
  sunflower,
  rose,
}

extension PlantTypeExt on PlantType {
  int get health => defaultHealth;

  /// Наносимый урон
  int get damage => defaultDamage;

  /// Стоимость
  int get costs => defaultPlantCosts;

  /// Частота удара + стрельбы
  double get fireFrequency => 2;
}

