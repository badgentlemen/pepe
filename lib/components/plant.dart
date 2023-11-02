import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:pepe/components/bullet.dart';
import 'package:pepe/constants.dart';
import 'package:pepe/components/pest.dart';
import 'package:pepe/plants_vs_pests_game.dart';
// import 'package:flame/extensions.dart';

class Plant extends SpriteAnimationComponent with HasGameRef<PlantsVsPestsGame>, CollisionCallbacks {
  Plant({
    required super.position,
    required this.id,
    required this.health,
    this.fireFrequency = defaultSpeed,
    this.damage = defaultDamage,
  });

  /// Идентификатор растения
  final String id;

  /// Уровень жизни растения
  final int health;

  /// Наносимый урон
  final int damage;

  /// Частота удара + стрельбы
  final double fireFrequency;

  Timer? _interval;

  bool get canHit => game.power >= damage;

  @override
  FutureOr<void> onLoad() async {
    size = blockSize;
    priority = 1;
    debugMode = true;

    _interval = Timer(
      fireFrequency,
      onTick: fire,
      repeat: true,
    );

    return super.onLoad();
  }

  @override
  void update(double dt) {
    _interval?.update(dt);
    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Pest) {
      print('pest');
    }

    // TODO: implement onCollision
    super.onCollision(intersectionPoints, other);
  }

  void fire() {
    if (isMounted && canHit) {
      game.power -= damage;

      final bullet = Bullet(
        position: Vector2(
          blockSize.x,
          blockSize.y / 2,
        ),
        width: 20,
        height: 20,
        damage: damage,
      );

      add(bullet);
    }
  }
}
