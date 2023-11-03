import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:pepe/plants_vs_pests_game.dart';

const _aspectRatio = 1.54;

class Cloud extends SpriteComponent with HasGameRef<PlantsVsPestsGame> {
  Cloud();

  Timer? _timer;

  @override
  FutureOr<void> onLoad() {
    position = game.skyPosition;
    size = Vector2(game.cloudWidth, game.cloudWidth / _aspectRatio);

    add(RectangleHitbox());

    _timer = Timer(
      0.05,
      onTick: _move,
      repeat: true,
    );

    sprite = Sprite(
      game.images.fromCache('cloud.png'),
    );

    return super.onLoad();
  }

  @override
  void update(double dt) {
    _timer?.update(dt);
    super.update(dt);
  }

  void _move() {
    position.x += 1;

    if (position.x >= game.size.x) {
      removeFromParent();
    }
  }
}
