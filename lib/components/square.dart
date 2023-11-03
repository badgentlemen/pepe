import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:pepe/components/plant.dart';
import 'package:pepe/models/plant_type.dart';
import 'package:pepe/plants_vs_pests_game.dart';

class Square extends SpriteComponent with TapCallbacks, HasGameRef<PlantsVsPestsGame> {
  Square({
    required super.position,
    required this.plantType,
    required this.column,
    required this.row,
  });

  Plant? _plant;

  final PlantType plantType;

  final int row;

  final int column;

  bool get canBuy => game.sunPower > plantType.costs;

  bool get canPlant => _plant == null && canBuy;

  @override
  void onTapUp(TapUpEvent event) {
    if (_plant == null) {
      _addPlant();
    }

    super.onTapUp(event);
  }

  void _addPlant() {
    if (!canPlant) {
      return;
    }

    _plant = Plant(PlantType.corn);

    game.reduceSunPower(_plant!.costs);

    add(_plant!);
  }

  @override
  FutureOr<void> onLoad() async {
    size = Vector2(game.blockSize, game.blockSize);

    sprite = plantType.fetchSprite(game.images);

    priority = 1;
    return super.onLoad();
  }
}
