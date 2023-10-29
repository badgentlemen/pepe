import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:pepe/constants.dart';

/// Общий класс ПУЛЬ
class Bullet extends RectangleComponent with CollisionCallbacks {
  Bullet({
    required super.position,
    required double width,
    required double height,
    required this.damage,
    this.speed = defaultSpeed,
  }) : super(
          size: Vector2(
            width,
            height,
          ),
        );

  /// Наносимый урон от пули
  final int damage;

  /// Скорость пули
  final double speed;

  Timer? _timer;

  @override
  FutureOr<void> onLoad() {
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
