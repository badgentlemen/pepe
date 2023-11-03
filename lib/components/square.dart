import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:pepe/components/plant.dart';
import 'package:pepe/models/plant_type.dart';
import 'package:pepe/models/square_type.dart';
import 'package:pepe/plants_vs_pests_game.dart';

class Square extends SpriteComponent with TapCallbacks, HasGameRef<PlantsVsPestsGame> {
  Square({
    required super.position,
    required this.type,
    required this.column,
    required this.row,
  });

  Plant? plant;

  final SquareType type;

  final int row;

  final int column;

  List<Square> get beforeItems {
    final columns = game.fieldSquares[row];

    try {
      return columns.sublist(0, column);
    } catch (e) {
      return columns;
    }
  }

  bool get enemiesPassedPlace => false;

  bool canPlant() => plant == null && (column == 0 ? true : beforeItems.every((element) => element.plant != null));

  @override
  void onTapUp(TapUpEvent event) {
    if (plant == null) {
      _addPlant();
    }

    super.onTapUp(event);
  }

  void _addPlant() {
    if (!canPlant()) {
      return;
    }

    plant = Plant(PlantType.pepper);

    game.reduceSunPower(plant!.costs);

    add(plant!);
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

    switch (type) {
      case SquareType.buckwheat:
        sprite = buckwheatSprite;
        break;
      case SquareType.potato:
        sprite = potatoSprite;
        break;
      case SquareType.wheat:
      default:
        sprite = wheatSprite;
    }


    priority = 1;
    return super.onLoad();
  }
}
