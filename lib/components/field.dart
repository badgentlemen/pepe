import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:pepe/constants.dart';
import 'package:pepe/components/pest.dart';
import 'package:pepe/plants_vs_pests_game.dart';
import 'package:pepe/components/square.dart';
import 'package:pepe/utils.dart';
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

  Timer? _timer;

  @override
  FutureOr<void> onLoad() {
    _buildNet();

    _timer = Timer(
      1,
      onTick: _someRandom,
      repeat: true,
    );

    _sendPestAt(0);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    _timer?.update(dt);
    super.update(dt);
  }

  void _sendPestAt(
    int row, {
    double delay = 1,
  }) {
    final position = Vector2(size.x - blockSize.x, row * blockSize.y);
    final health = random(70, 120);
    final pest = Pest(
      id: const Uuid().v4(),
      position: position,
      delay: 6,
      health: health,
    );

    game.pests.add(pest);
    add(pest);
  }

  void _someRandom() {
    final next = Random().nextDouble();

    if (next > .95) {
      final randomRow = Random().nextInt(rows);
      _sendPestAt(randomRow,);
    }
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

      game.fieldSquares.add(list);
    }
  }
}
