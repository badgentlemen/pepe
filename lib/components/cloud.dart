import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:pepe/plants_vs_pests_game.dart';

const _aspectRatio = 1.54;

class Cloud extends SpriteComponent with HasGameRef<PlantsVsPestsGame> {
  Cloud({
    required super.position,
    this.reversed = false,
    double initWidth = 100,
  }) : super(
          size: Vector2(
            initWidth,
            initWidth / _aspectRatio,
          ),
        );

  final bool reversed;

  Timer? _timer;

  @override
  FutureOr<void> onLoad() {
    add(RectangleHitbox());

    _timer = Timer(
      .5,
      onTick: _move,
      repeat: true,
    );

    sprite = Sprite(
      game.images.fromCache('cloud.png'),
    );

    if (reversed) {
      flipHorizontallyAroundCenter();
    }

    return super.onLoad();
  }

  @override
  void update(double dt) {
    _timer?.update(dt);
    super.update(dt);
  }

  void _move() {
    position.x += 10;

    if (position.x >= game.size.x) {
      removeFromParent();
    }
  }
}
