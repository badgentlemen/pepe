import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:pepe/constants.dart';
import 'package:pepe/components/plant.dart';
import 'package:pepe/models/plant_type.dart';
import 'package:pepe/plants_vs_pests_game.dart';
import 'package:uuid/uuid.dart';

class Square extends SpriteComponent with TapCallbacks, HasGameRef<PlantsVsPestsGame> {
  Square({
    required super.position,
    required this.column,
    required this.row,
  }) : super(size: blockSize);

  Plant? plant;

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

    addPlant();

    super.onTapUp(event);
  }

  void addPlant() {
    if (!canPlant()) {
      return;
    }

    plant = Plant(PlantType.peas);

    game.reducePower(plant!.costs);

    add(plant!);
  }

  Sprite get row1Sprite => _spriteAt(x: 6, y: 10);

  Sprite get row0Sprite => _spriteAt(x: 7, y: 3);

  Sprite _spriteAt({required int x, required int y}) {
    final spriteSize = Vector2(16, 16);
    final spritePosition = Vector2(x * spriteSize.x, y * spriteSize.y);

    return Sprite(
      game.images.fromCache('grass.png'),
      srcPosition: spritePosition,
      srcSize: Vector2(16, 16),
    );
  }

  @override
  FutureOr<void> onLoad() async {
    sprite = row.isOdd ? row1Sprite : row0Sprite;

    priority = 1;
    return super.onLoad();
  }
}
