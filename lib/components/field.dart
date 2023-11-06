import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:pepe/components/bullet.dart';
import 'package:pepe/components/fence.dart';
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
      sciptedPests.where((sciptedPest) => sciptedPest.delayDurationSec == game.level?.completedDurationSec).toList();

  @override
  FutureOr<void> onLoad() {
    size = game.fieldSize;
    position = game.fieldPosition;

    _buildNet();
    _addBorders();
    _addFences();

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
    if (game.level == null) {
      return;
    }

    if (game.level!.isCompleted) {
      return;
    }

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

      sciptedPests.removeWhere((element) => copied.map((e) => e.id).contains(element.id));

      for (var scriptedPest in copied) {
        _sendPestAtRow(
          pestType: scriptedPest.type,
          row: scriptedPest.row,
        );
      }
    }
  }

  void _sendPestAtRow({required PestType pestType, required int row}) {
    if (!isMounted) {
      return;
    }

    if (game.level == null) {
      return;
    }

    if (game.level!.isCompleted) {
      return;
    }

    final pest = Pest(
      type: pestType,
      position: Vector2(
        size.x - game.blockSize,
        row * game.blockSize,
      ),
    );

    add(pest);

    game.level?.onPestAdd(pest);
  }

  void _addFences() {
    final fencesPerRow = width / game.fenceWidth;
    final fencesPerColumn = height / game.fenceWidth;

    for (var i = 0; i < fencesPerRow; i++) {
      final positionX = i * game.fenceWidth;
      add(
        Fence(
          position: Vector2(
            positionX,
            -game.fenceHeight + 8,
          ),
          priority: 2,
        ),
      );

      add(
        Fence(
          position: Vector2(
            positionX,
            height - game.fenceHeight,
          ),
          priority: 3,
        ),
      );

      for (var i = 0; i < fencesPerColumn; i++) {
        final positionY = i * game.fenceWidth - 10;

        void addFence(double positionX) {
          add(
            Fence(
              position: Vector2(
                positionX,
                positionY,
              ),
              priority: 3,
              angle: 1.55,
            ),
          );
        }

        addFence(game.fenceHeight / 2.3);
        addFence(width + game.fenceHeight / 1.3);
      }
    }
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
