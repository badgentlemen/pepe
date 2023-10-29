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

  @override
  FutureOr<void> onLoad() {

    final topRightPosition = Vector2(size.x - blockSize.x, 0);

    final pest = Pest(
      id: const Uuid().v4(),
      position: topRightPosition,
    );

    final pest2 = Pest(
      id: const Uuid().v4(),
      position: topRightPosition,
    );

    add(pest);

    Future.delayed(Duration(seconds: 3, milliseconds: 200), () => add(pest2));

    _buildNet();
    return super.onLoad();
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
