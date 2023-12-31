import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:pepe/constants.dart';
import 'package:pepe/p2p_game.dart';
import 'package:pepe/utils.dart';

class Cloud extends SpriteComponent with HasGameRef<P2PGame> {
  Cloud();

  Timer? _timer;

  double get calculatedHeight => game.cloudWidth / cloudAssetRatio;

  @override
  FutureOr<void> onLoad() {
    final randomOffset = random(20, 80);

    position = Vector2(game.skyPosition.x, game.skyPosition.y + randomOffset);
    size = Vector2(game.cloudWidth, calculatedHeight);

    add(RectangleHitbox());

    _timer = Timer(
      0.03,
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
    if (game.level?.isCompleted == true) {
      return;
    }

    position.x += 1;

    if (position.x >= game.size.x) {
      _timer?.stop();
      _timer = null;
      removeFromParent();
    }
  }
}
