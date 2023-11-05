import 'dart:async';
import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:pepe/components/bullet.dart';
import 'package:pepe/components/health_indicator.dart';
import 'package:pepe/components/plant.dart';
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
    this.type = PestType.bunny,
    this.value = defaultPestValue,
    this.delay = 5,
  });

  late SpriteAnimation _idleAnimation;

  late SpriteAnimation _hitAnimation;

  SpriteAnimation? _runAnimtion;

  /// Тип вредителя
  final PestType type;

  /// Идентификатор
  final String id;

  /// Скорость передвижения
  final double delay;

  /// Цена за уничтожение
  final int value;

  /// Вероятность уклонения от атаки
  int get dodgePercent => type.dodgePercent;

  /// Здоровье
  int get health => type.health;

  /// Наносимый урон
  int get damage => type.damage;

  bool get isStopped => position.x <= 0 || _isEffectWithPlant;

  bool _isEffectWithPlant = false;

  Timer? _movingTimer;

  Timer? _plantEffectTimer;

  int _currentHealth = 0;

  final List<String> _dodgedBullets = [];

  late HealthIndicator _healthIndicator;

  @override
  FutureOr<void> onLoad() {
    _currentHealth = health;

    size = Vector2(game.blockSize, game.blockSize);

    _loadAllAnimations();
    priority = 2;

    _addHitbox();

    _addHealthIndicator();

    _movingTimer = Timer(
      stepTime,
      onTick: _move,
      repeat: true,
    );

    return super.onLoad();
  }

  @override
  void update(double dt) {
    _movingTimer?.update(dt);
    _plantEffectTimer?.update(dt);
    _healthIndicator.updateData(max: health, value: _currentHealth);
    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Bullet) {
      if (_dodgedBullets.contains(other.id)) {
        return;
      }

      final isDodged = dodgePercent > 0 ? Random().nextInt(100) <= dodgePercent : false;

      if (isDodged) {
        _dodgedBullets.add(other.id);
        return;
      }

      _handleDamage(other.damage);
      other.removeFromParent();
    }

    if (other is Plant) {
      _isEffectWithPlant = true;

      _plantEffectTimer ??= Timer(
        other.fireFrequency,
        onTick: () => _handleDamage(other.damage),
        repeat: true,
      );
    }

    super.onCollision(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    if (other is Plant) {
      _isEffectWithPlant = false;
      _disposePlantEffectTimer();
    }

    super.onCollisionEnd(other);
  }

  void _addHitbox() {
    add(
      RectangleHitbox(
        position: Vector2(0, 0),
        size: Vector2(
          game.blockSize,
          game.blockSize,
        ),
      ),
    );
  }

  void _addHealthIndicator() {
    final size = Vector2(game.blockSize * .7, 15);

    _healthIndicator = HealthIndicator(
      currentValue: _currentHealth,
      maxValue: health,
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
      position.x -= game.blockSize / (delay / stepTime);
    }
  }

  Future<void> _onHit() async {
    current = PestAnimationType.hit;

    await Future.delayed(Duration(seconds: (1 / PestAnimationType.hit.amount).floor()));

    current = _runAnimtion != null ? PestAnimationType.run : PestAnimationType.idle;
  }

  void _handleDamage(int damage) {
    if (health > 0) {
      _currentHealth = _currentHealth - damage;
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

  void _disposePlantEffectTimer() {
    _plantEffectTimer?.stop();
    _plantEffectTimer = null;
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

    if (type == PestType.bunny) {
      _runAnimtion = fetchAmimation(
        game.images,
        of: type.title,
        type: 'Run',
        size: type.spriteSize,
        amount: PestAnimationType.run.amount,
      );
    }

    animations = {
      PestAnimationType.idle: _idleAnimation,
      PestAnimationType.hit: _hitAnimation,
      if (_runAnimtion != null) PestAnimationType.run: _runAnimtion!,
    };

    current = _runAnimtion != null ? PestAnimationType.run : PestAnimationType.idle;
  }
}
