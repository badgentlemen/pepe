import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:pepe/constants.dart';
import 'package:pepe/plant.dart';
import 'package:pepe/plants_vs_pests_game.dart';
import 'package:uuid/uuid.dart';

class Square extends RectangleComponent with TapCallbacks, HasGameRef<PlantsVsPestsGame> {
  Square({
    required super.position,
    required this.column,
    required this.row,
  }) : super(size: blockSize);

  Plant? plant;

  final int row;

  final int column;

  List<Square> get beforeItems {
    final columns = game.squares[row];

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
    if (plant != null) {
    } else {
      if (!canPlant()) {
        return;
      }

      plant = Plant(
        id: const Uuid().v4(),
        position: Vector2(0, 0),
        health: 100,
        fireFrequency: 1,
        damage: 90,
      );

      add(plant!);
    }
  }

  @override
  FutureOr<void> onLoad() {
    // debugMode = true;
    priority = 1;
    return super.onLoad();
  }
}
