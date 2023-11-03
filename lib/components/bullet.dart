import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:pepe/constants.dart';
import 'package:pepe/plants_vs_pests_game.dart';

/// Общий класс ПУЛЬ
class Bullet extends SpriteComponent with CollisionCallbacks, HasGameRef<PlantsVsPestsGame> {
  Bullet({
    required super.position,
    required this.damage,
    this.speed = defaultSpeed,
  }) : super(
          size: defaultSize,
        );

  static Vector2 defaultSize = Vector2(28, 28);

  /// Наносимый урон от пули
  final int damage;

  /// Скорость пули
  final double speed;

  Timer? _timer;

  @override
  FutureOr<void> onLoad() {
    sprite = Sprite(
      game.images.fromCache('Bullet.png'),
    );

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

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    // TODO: implement onCollision
    super.onCollision(intersectionPoints, other);
  }

  void _move() {
    position.x += size.x;
  }
}
