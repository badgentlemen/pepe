import 'dart:async';

import 'package:flame/components.dart';
import 'package:pepe/constants.dart';
import 'package:pepe/pest.dart';
import 'package:pepe/plants_vs_pests_game.dart';
import 'package:pepe/square.dart';
import 'package:uuid/uuid.dart';

class Field extends RectangleComponent with HasGameRef<PlantsVsPestsGame> {
  Field({
    required super.position,
    required this.rows,
    required this.columns,
  }) : super(
          size: Vector2(
            columns * blockSize.x,
            rows * blockSize.y,
          ),
        );

  final int rows;

  final int columns;

  Timer? timer;

  @override
  FutureOr<void> onLoad() {
    final pest = Pest(
      id: const Uuid().v4(),
      health: 120,
      offsetX: size.x + blockSize.x,
      offsetY: 0,
    );

    add(pest);

    timer = Timer(
      1,
      onTick: () {},
      repeat: true,
    );

    _buildNet();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    timer?.update(dt);
    super.update(dt);
  }

  void _buildNet() {
    for (var row = 0; row < rows; row++) {
      List<Square> list = [];

      for (var column = 0; column < columns; column++) {
        final offsetY = row * blockSize.y;
        final offsetX = column * blockSize.x;

        final square = Square(
          position: Vector2(offsetX, offsetY),
          column: column,
          row: row,
        );

        add(square);

        list.add(square);
      }

      game.squares.add(list);
    }
  }
}
