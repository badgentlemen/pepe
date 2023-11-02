import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:pepe/components/cloud.dart';
import 'package:pepe/components/sun.dart';

class PrimarySun extends Sun with CollisionCallbacks {
  PrimarySun() : super(position: Vector2.zero());

  @override
  FutureOr<void> onLoad() {
    position = game.primarySunPosition;

    add(RectangleHitbox());
    return super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Cloud) {
      game.primarySunBlocked = true;
    }

    super.onCollision(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    if (other is Cloud) {
      game.primarySunBlocked = false;
    }

    super.onCollisionEnd(other);
  }
}
