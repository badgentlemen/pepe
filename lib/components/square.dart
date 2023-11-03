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

  bool get canPlant => _plant == null;

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

  Sprite get potatoSprite => _spriteAt(x: 19, y: 0, size: 3);

  Sprite get wheatSprite => _spriteAt(x: 13, y: 0, size: 3);

  Sprite get buckwheatSprite => _spriteAt(x: 10, y: 0, size: 3);

  Sprite _spriteAt({required int x, required int y, int size = 1,}) {
    final spriteSize = Vector2(16.0, 16.0);
    final spritePosition = Vector2(x * spriteSize.x, y * spriteSize.y);

    return Sprite(
      game.images.fromCache('grass.png'),
      srcPosition: spritePosition,
      srcSize: Vector2(16.0 * size, 16.0 * size),
    );
  }

  @override
  FutureOr<void> onLoad() async {
    size = Vector2(game.blockSize, game.blockSize);

    switch (plantType) {
      case PlantType.watermelon:
        sprite = buckwheatSprite;
        break;
      case PlantType.carrot:
        sprite = potatoSprite;
        break;
      case PlantType.corn:
      default:
        sprite = wheatSprite;
    }


    priority = 1;
    return super.onLoad();
  }
}
