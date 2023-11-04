import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:pepe/constants.dart';
import 'package:pepe/plants_vs_pests_game.dart';



class Cloud extends SpriteComponent with HasGameRef<PlantsVsPestsGame> {
  Cloud();

  Timer? _timer;

  double get calculatedHeight => game.cloudWidth / cloudAssetRatio;

  @override
  FutureOr<void> onLoad() {
    position = Vector2(game.skyPosition.x, game.skyPosition.y + 20);
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
    position.x += 1;

    if (position.x >= game.size.x) {
      removeFromParent();
    }
  }
}
