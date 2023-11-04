import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:pepe/components/bullet.dart';
import 'package:pepe/components/health_indicator.dart';
import 'package:pepe/constants.dart';
import 'package:pepe/models/pest_animation_type.dart';
import 'package:pepe/models/pest_type.dart';
import 'package:pepe/p2p_game.dart';
import 'package:pepe/utils.dart';

/// Общий класс вредителя
class Pest extends SpriteAnimationGroupComponent with HasGameRef<P2PGame>, CollisionCallbacks {
  Pest({
    required this.id,
    required super.position,
    this.health = defaultHealth,
    this.type = PestType.bunny,
    this.value = defaultPestValue,
    this.delay = 5,
    this.dodgePercent = 0,
  }) {
    _currentHealth = health;
  }

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
  final int health;

  bool isStopped = false;

  bool isSlowDown = false;

  Timer? _timer;

  int _currentHealth = 0;

  late HealthIndicator _healthIndicator;

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
    size = Vector2(game.blockSize, game.blockSize);

    _loadAllAnimations();
    priority = 2;

    _addHitbox();

    _addHealthIndicator();

    _timer = Timer(
      isSlowDown ? delay * 1.5 : delay,
      onTick: _move,
      repeat: true,
    );

    return super.onLoad();
  }

  @override
  void update(double dt) {
    _timer?.update(dt);
    _healthIndicator.updateData(max: health, value: _currentHealth);
    super.update(dt);
  }

  void _addHitbox() {
    add(RectangleHitbox());
  }

  void _addHealthIndicator() {
    final size = Vector2(game.blockSize * .7, 15);

    _healthIndicator = HealthIndicator(
      value: _currentHealth,
      max: health,
      size: size,
      position: Vector2(width / 2 - size.x / 2, -6),
    );

    add(_healthIndicator);
  }

  void _move() {
    if (isStopped) {
      return;
    }

    if (position.x != 0) {
      position.x -= game.blockSize;
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
      _currentHealth -= damage;
      _onHit();
    }

    if (_currentHealth <= 0) {
      _destroy();
    }
  }

  void _destroy() {
    game.onPestKill(this);
    removeFromParent();
  }

  void _loadAllAnimations() {
    _idleAnimation = fetchAmimation(
      game.images,
      of: type.title,
      type: 'Idle',
      size: type.spriteSize,
      amount: PestAnimationType.idle.amount,
    );

    _hitAnimation = fetchAmimation(
      game.images,
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
