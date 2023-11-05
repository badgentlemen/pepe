import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:pepe/components/field_border.dart';
import 'package:pepe/constants.dart';
import 'package:pepe/models/plant_type.dart';
import 'package:pepe/p2p_game.dart';
import 'package:uuid/uuid.dart';

/// Общий класс ПУЛЬ
class Bullet extends CircleComponent with CollisionCallbacks, HasGameRef<P2PGame> {
  Bullet({
    required super.position,
    required this.damage,
    required this.plantType,
    this.speed = defaultSpeed,
  }) : id = const Uuid().v4(), super(radius: bulletRadius,);

  final PlantType plantType;

  final String id;

  /// Наносимый урон от пули
  final int damage;

  /// Скорость пули
  final double speed;

  Timer? _timer;

  @override
  Future<void> onLoad() async {
    paintLayers = [
      Paint()..color = plantType.bulletColor,
      Paint()
        ..style = PaintingStyle.stroke
        ..color = Colors.black
        ..strokeWidth = 2,
    ];

    add(CircleHitbox());

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
