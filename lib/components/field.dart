import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:pepe/components/bullet.dart';
import 'package:pepe/components/field_border.dart';
import 'package:pepe/components/pest.dart';
import 'package:pepe/constants.dart';
import 'package:pepe/models/pest_type.dart';
import 'package:pepe/models/scripted_pest.dart';
import 'package:pepe/p2p_game.dart';
import 'package:pepe/components/square.dart';
import 'package:pepe/utils.dart';

class Field extends RectangleComponent with HasGameRef<P2PGame>, CollisionCallbacks {
  Field({this.sciptedPests = const []});

  List<ScriptedPest> sciptedPests;

  Timer? _timer;

  List<ScriptedPest> get _pestsForNow =>
      sciptedPests.where((sciptedPest) => sciptedPest.delayDurationSec == game.level?.startedDateTimeSec).toList();

  @override
  FutureOr<void> onLoad() {
    size = Vector2(fieldColumns * game.blockSize, fieldRows * game.blockSize);
    position = Vector2(game.dashboardPosition.x, game.size.y - (game.blockSize * 2.2) - size.y);

    _buildNet();
    _addBorders();

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
    _handlePestSending();
    super.update(dt);
  }

  void _handlePestSending() {
    if (game.level == null) {
      return;
    }

    if (_pestsForNow.isNotEmpty) {
      List<ScriptedPest> copied = [..._pestsForNow];

      sciptedPests.removeWhere((element) => copied.map((e) => e.pest.id).contains(element.pest.id));

      for (var scriptedPest in copied) {
        _sendPestAtRow(
          pest: scriptedPest.pest,
          row: scriptedPest.row,
        );
      }
    }
  }

  void _sendPestAtRow({required Pest pest, required int row}) {
    pest.position = Vector2(size.x - game.blockSize, row * game.blockSize);

    game.level?.pests.add(pest);
    add(pest);
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
