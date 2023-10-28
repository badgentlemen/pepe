import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:pepe/bullet.dart';
import 'package:pepe/constants.dart';

/// Общий класс вредителя
class Pest extends RectangleComponent with  CollisionCallbacks {
  Pest({
    required double offsetX,
    required double offsetY,
    required this.id,
    required this.health,
    this.value = defaultPestValue,
    this.speed = 1,
    this.dodgePercent = 0,
  }) : super(
          position: Vector2(offsetX, offsetY),
          size: blockSize,
        );

  /// Идентификатор
  final String id;

  /// Скорость передвижения
  final double speed;

  /// Цена за уничтожение
  final int value;

  /// Вероятность уклонения от атаки
  final double dodgePercent;

  /// Здоровье
  int health;

  bool win = false;

  void moveForward() {
    if (win) {
      return;
    }

    if (position.x != 0) {
      position.x -= blockSize.x;
    } else {
      win = true;
    }
  }

  void _handleDamage(int damage) {
    if (health > 0) {
      health -= damage;
    }

    if (health <= 0) {
      removeFromParent();
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {

    if (other is Bullet) {
      _handleDamage(other.damage);
    }

    super.onCollision(intersectionPoints, other);
  }

  @override
  FutureOr<void> onLoad() {
    debugMode = true;
    priority = 2;
    return super.onLoad();
  }
}
