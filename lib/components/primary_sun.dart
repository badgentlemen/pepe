import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:pepe/components/cloud.dart';
import 'package:pepe/components/sun.dart';

class PrimarySun extends Sun with CollisionCallbacks {
  PrimarySun() : super(position: Vector2.zero(), size: Vector2.zero());

  static const double delay = 7;

  Timer? _timer;

  @override
  FutureOr<void> onLoad() {
    position = game.primarySunPosition;
    size = game.primarySunSize;

    add(CircleHitbox());
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
}
