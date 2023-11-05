import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:pepe/components/plant.dart';
import 'package:pepe/models/plant_type.dart';
import 'package:pepe/p2p_game.dart';

class Square extends SpriteComponent with TapCallbacks, HasGameRef<P2PGame> {
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

  bool get canBuy => game.sunPower > plantType.price;

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

    _plant = Plant(plantType);

    game.reduceSunPower(_plant!.price);

    add(_plant!);
  }

  @override
  FutureOr<void> onLoad() async {

    size = Vector2(game.blockSize, game.blockSize);
    sprite = plantType.fetchGrassSprite(game.images);

    priority = 1;
    return super.onLoad();
  }
}
