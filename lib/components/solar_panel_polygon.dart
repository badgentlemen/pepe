import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:pepe/components/cloud.dart';
import 'package:uuid/uuid.dart';

class SolarPanelPolygon extends PolygonComponent with CollisionCallbacks {
  SolarPanelPolygon(
    super.vertices,
  ) : id = const Uuid().v4();

  final String id;

  bool sunBlocked = false;

  @override
  FutureOr<void> onLoad() {
    add(PolygonHitbox(vertices));
    setColor(Colors.transparent);
    return super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Cloud) {
      sunBlocked = true;
    }

    super.onCollision(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    if (other is Cloud) {
      sunBlocked = false;
    }

    super.onCollisionEnd(other);
  }
}
