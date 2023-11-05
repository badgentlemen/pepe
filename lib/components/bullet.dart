import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:pepe/constants.dart';
import 'package:pepe/p2p_game.dart';

/// Общий класс ПУЛЬ
class Bullet extends CircleComponent with CollisionCallbacks, HasGameRef<P2PGame> {
  Bullet({
    required super.position,
    required this.damage,
    required this.color,
    this.speed = defaultSpeed,
  }) : super(radius: bulletRadius);

  final Color color;

  /// Наносимый урон от пули
  final int damage;

  /// Скорость пули
  final double speed;

  Timer? _timer;

  @override
  Future<void> onLoad() async {
    paintLayers = [
      Paint()..color = color,
      Paint()
        ..style = PaintingStyle.stroke
        ..color = Colors.black
        ..strokeWidth = 2,
    ];

    add(RectangleHitbox());

    _timer = Timer(
      speed / bulletFps,
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
    position.x += width / bulletFps;
  }
}
