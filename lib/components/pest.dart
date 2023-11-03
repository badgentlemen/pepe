import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:pepe/components/bullet.dart';
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
    this.delay = 5,
    this.dodgePercent = 0,
  }) : super(
          size: blockSize,
        );

  late SpriteAnimation _idleAnimation;

  late SpriteAnimation _hitAnimation;

  /// Тип вредителя
  final PestType type;

  /// Идентификатор
  final String id;

  /// Скорость передвижения
  final double delay;

  /// Цена за уничтожение
  final int value;

  /// Вероятность уклонения от атаки
  final double dodgePercent;

  /// Здоровье
  int health;

  bool isStopped = false;

  bool isSlowDown = false;

  Timer? _timer;

  int step = 0;

  int get xIndex => ((position.x - blockSize.x) / blockSize.x).floor();

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Bullet) {
      _handleDamage(other.damage);
      other.removeFromParent();
    }

    super.onCollision(intersectionPoints, other);
  }

  @override
  FutureOr<void> onLoad() {
    _loadAllAnimations();
    priority = 2;

    add(RectangleHitbox());

    _timer = Timer(
      isSlowDown ? delay * 1.5 : delay,
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
    if (isStopped) {
      return;
    }

    if (position.x != 0) {
      step += 1;
      position.x -= blockSize.x;
    }

    if (position.x <= 0) {
      isStopped = true;
    }
  }

  Future<void> _onHit() async {
    current = PestAnimationType.hit;

    await Future.delayed(Duration(seconds: (1 / PestAnimationType.hit.amount).floor()));

    current = PestAnimationType.idle;
  }

  Future<void> _handleDamage(int damage) async {
    if (health > 0) {
      health -= damage;
      _onHit();
    }

    if (health <= 0) {
      _destroy();
    }
  }

  void _destroy() {
    game.onPestKill(this);
    removeFromParent();
  }

  void _loadAllAnimations() {
    _idleAnimation = fetchAmimation(
      images: game.images,
      of: type.title,
      type: 'Idle',
      size: type.spriteSize,
      amount: PestAnimationType.idle.amount,
    );

    _hitAnimation = fetchAmimation(
      images: game.images,
      of: type.title,
      type: 'Hit',
      size: type.spriteSize,
      amount: PestAnimationType.hit.amount,
    );

    animations = {
      PestAnimationType.idle: _idleAnimation,
      PestAnimationType.hit: _hitAnimation,
    };

    current = PestAnimationType.idle;
  }
}
