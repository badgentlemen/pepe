import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:pepe/components/cloud.dart';

class SolarPanelPolygon extends PolygonComponent with CollisionCallbacks {
  SolarPanelPolygon(
    super.vertices,
  );

  bool isBlocked = false;

  @override
  FutureOr<void> onLoad() {
    add(PolygonHitbox(vertices));
    return super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Cloud) {
      isBlocked = true;
    }

    super.onCollision(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    if (other is Cloud) {
      isBlocked = false;
    }

    super.onCollisionEnd(other);
  }
}
