import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:pepe/bullet.dart';
import 'package:pepe/constants.dart';
import 'package:pepe/models/pest_animation_type.dart';
import 'package:pepe/models/pest_type.dart';
import 'package:pepe/plants_vs_pests_game.dart';
import 'package:pepe/utils.dart';

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

  late SpriteAnimation _idleAnimation;

  late SpriteAnimation _hitAnimation;

  bool win = false;

  int step = 0;

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

    if (step.isOdd) {
      _handleDamage(30);
    }

    if (position.x != 0) {
      position.x -= blockSize.x;
      step += 1;
    } else {
      win = true;
    }
  }

  Future<void> _handleDamage(int damage) async {
    if (health > 0) {
      _timer?.pause();
      current = PestAnimationType.hit;
      health -= damage;
      await Future.delayed(Duration(milliseconds: 200));

      _timer?.resume();
      current = PestAnimationType.idle;
    }

    if (health <= 0) {
      // TODO: we killed the enemy
      game.sunPower += value;

      removeFromParent();
    }
  }

  void _loadAllAnimations() {
    _idleAnimation = fetchAmimation(
      images: game.images,
      of: type.title,
      type: 'Idle',
      size: type.spriteSize,
      amount: PestAnimationType.idle.amount,
      speed: speed,
    );

    _hitAnimation = fetchAmimation(
      images: game.images,
      of: type.title,
      type: 'Hit',
      size: type.spriteSize,
      amount: PestAnimationType.hit.amount,
      speed: speed,
    );

    animations = {
      PestAnimationType.idle: _idleAnimation,
      PestAnimationType.hit: _hitAnimation,
    };

    current = PestAnimationType.idle;
  }
}
