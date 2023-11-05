import 'dart:async';
import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:pepe/components/bullet.dart';
import 'package:pepe/components/field_border.dart';
import 'package:pepe/components/pest.dart';
import 'package:pepe/constants.dart';
import 'package:pepe/p2p_game.dart';
import 'package:pepe/components/square.dart';
import 'package:pepe/utils.dart';
import 'package:uuid/uuid.dart';

class Field extends RectangleComponent with HasGameRef<P2PGame>, CollisionCallbacks {
  Field();

  Timer? _timer;

  @override
  FutureOr<void> onLoad() {
    size = Vector2(fieldColumns * game.blockSize, fieldRows * game.blockSize);
    position = Vector2(game.dashboardPosition.x, game.size.y - (game.blockSize * 2.2) - size.y);

    _buildNet();
    _addBorders();

    _timer = Timer(
      1,
      onTick: () {

      },
      repeat: true,
    );

    return super.onLoad();
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Bullet) {
      other.removeFromParent();
    }

    super.onCollisionStart(intersectionPoints, other);
  }


  @override
  void update(double dt) {
    _timer?.update(dt);
    super.update(dt);
  }

  void _addBorders() {
    add(
      FieldBorder(
        position: Vector2(0, 0),
        size: Vector2(2, height),
      ),
    );
    add(
      FieldBorder(
        position: Vector2(0, 0),
        size: Vector2(width, 2),
      ),
    );
    add(
      FieldBorder(
        position: Vector2(width, 0),
        size: Vector2(
          2,
          height,
        ),
      ),
    );
    add(
      FieldBorder(
        position: Vector2(0, height),
        size: Vector2(width, 2),
      ),
    );
  }

  void _buildNet() {
    for (var row = 0; row < fieldRows; row++) {
      List<Square> list = [];

      for (var column = 0; column < fieldColumns; column++) {
        final offsetY = row * game.blockSize;
        final offsetX = column * game.blockSize;

        final square = Square(
          position: Vector2(offsetX, offsetY),
          plantType: randomPlantType(),
          column: column,
          row: row,
        );

        add(square);

        list.add(square);
      }

      game.level?.fieldSquares.add(list);
    }
  }
}
