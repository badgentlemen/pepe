import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:pepe/components/cloud.dart';
import 'package:pepe/components/sun.dart';

class PrimarySun extends Sun with CollisionCallbacks {
  PrimarySun() : super(position: Vector2.zero(), size: Vector2.zero());

  static const double delay = 4.5;
  static const double fps = 0.05;

  bool _isLeftVelocity = true;

  Timer? _timer;

  @override
  FutureOr<void> onLoad() {
    position = game.primarySunPosition;
    size = game.primarySunSize;

    add(CircleHitbox());

    _timer = Timer(
      fps,
      onTick: _move,
      repeat: true,
    );

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (game.level?.isCompleted != true) {
      _timer?.update(dt);
    }

    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Cloud) {
      game.level?.isSunBlocked = true;
    }

    super.onCollision(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    if (other is Cloud) {
      game.level?.isSunBlocked = false;
    }

    super.onCollisionEnd(other);
  }

  void _move() {
    if (game.level?.isCompleted == true) {
      return;
    }

    final step = (game.blockSize * 2) / (delay / fps);

    if (_isLeftVelocity) {
      position.x -= step;
    } else {
      position.x += step;
    }

    if (position.x < game.dashboardPosition.x) {
      _isLeftVelocity = false;
      flipHorizontallyAroundCenter();
    } else if (position.x >= game.size.x) {
      _isLeftVelocity = true;
      flipHorizontallyAroundCenter();
    }
  }
}
