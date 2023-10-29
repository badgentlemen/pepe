import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:pepe/bullet.dart';
import 'package:pepe/constants.dart';
import 'package:pepe/models/pest_animation_type.dart';
import 'package:pepe/models/pest_type.dart';
import 'package:pepe/plants_vs_pests_game.dart';

/// Общий класс вредителя
class Pest extends SpriteAnimationGroupComponent with HasGameRef<PlantsVsPestsGame>, CollisionCallbacks {
  Pest({
    required this.id,
    required super.position,
    this.health = defaultHealth,
    this.type = PestType.bunny,
    this.value = defaultPestValue,
    this.speed = 1,
    this.dodgePercent = 0,
  }) : super(
          size: blockSize,
        );

  /// Тип вредителя
  final PestType type;

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

  bool stoped = false;

  Timer? _timer;

  late SpriteAnimation idleAnimation;

  bool win = false;

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    print('коллизим');

    if (other is Bullet) {
      print('дамажем');
      _handleDamage(other.damage);
    }

    super.onCollision(intersectionPoints, other);
  }

  @override
  FutureOr<void> onLoad() {
    _loadAllAnimations();

    debugMode = true;
    priority = 1;

    _timer = Timer(
      speed,
      onTick: move,
      repeat: true,
    );

    return super.onLoad();
  }

  @override
  void update(double dt) {
    _timer?.update(dt);
    super.update(dt);
  }

  void move() {
    if (win || stoped) {
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

  void _loadAllAnimations() {
    idleAnimation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Bunny/Idle (34x44).png'),
      SpriteAnimationData.sequenced(
        amount: PestAnimationType.idle.amount,
        stepTime: speed / PestAnimationType.idle.amount,
        textureSize: Vector2(34, 44),
      ),
    );

    animations = {
      PestAnimationType.idle: idleAnimation,
    };

    current = PestAnimationType.idle;
  }
}
