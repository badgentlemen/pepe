import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:pepe/constants.dart';

/// Общий класс ПУЛЬ
class Bullet extends RectangleComponent with CollisionCallbacks {
  Bullet({
    required super.position,
    required this.damage,
    this.speed = defaultSpeed,
  }) : super(
          size: defaultSize,
        );

  static Vector2 defaultSize = Vector2(14, 14);

  /// Наносимый урон от пули
  final int damage;

  /// Скорость пули
  final double speed;

  Timer? _timer;

  @override
  FutureOr<void> onLoad() {
    add(RectangleHitbox());

    _timer = Timer(
      speed,
      onTick: _move,
      repeat: true,
    );

    _move();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    _timer?.update(dt);
    super.update(dt);
  }

  void _move() {
    position.x += size.x;
  }
}
