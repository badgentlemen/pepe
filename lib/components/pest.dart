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
import 'package:uuid/uuid.dart';

/// Общий класс вредителя
class Pest extends SpriteAnimationGroupComponent with HasGameRef<P2PGame>, CollisionCallbacks {
  Pest({
    this.type = PestType.bunny,
    super.position,
    this.delay = 5,
  }) : id = 'pest-${const Uuid().v4()}';

  late SpriteAnimation _runAnimation;

  late SpriteAnimation _hitAnimation;

  late SpriteAnimation _disappearingAnimation;

  /// Тип вредителя
  final PestType type;

  /// Идентификатор
  final String id;

  /// Скорость передвижения (секунды за которые вредитель успевает пройти путь [game.blockSize])
  final double delay;

  /// Цена за уничтожение
  int get reward => type.reward;

  /// Вероятность уклонения от атаки
  int get dodgePercent => type.dodgePercent;

  /// Здоровье
  int get health => type.health;

  /// Наносимый урон
  int get damage => type.damage;

  bool get isStopped => game.level == null ? true : position.x <= 0 || _isEffectWithPlant || game.level!.isCompleted;

  bool _isEffectWithPlant = false;

  Timer? _movingTimer;

  Timer? _plantEffectTimer;

  double _currentHealth = 0.0;

  final List<String> _dodgedBullets = [];

  late HealthIndicator _healthIndicator;

  late RectangleHitbox _hitbox;

  @override
  FutureOr<void> onLoad() {
    _currentHealth = health.toDouble();

    size = Vector2(game.blockSize, game.blockSize);

    _loadAllAnimations();
    priority = 2;

    _addHitbox();

    _addHealthIndicator();

    _movingTimer = Timer(
      pestFps,
      onTick: _move,
      repeat: true,
    );

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (game.level?.isCompleted != true) {
      _movingTimer?.update(dt);
      _plantEffectTimer?.update(dt);
      _healthIndicator.updateData(max: health, value: _currentHealth);
    }

    if (_currentHealth <= 0) {
      _healthIndicator.removeFromParent();
    }

    _healthIndicator.setOpacity(_currentHealth < 1 ? 0 : 1);

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
    _hitbox = RectangleHitbox(
      position: Vector2(0, 0),
      size: Vector2(
        game.blockSize,
        game.blockSize,
      ),
    );

    add(_hitbox);
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

    if (position.x > 0) {
      final next = max(position.x - game.blockSize / (delay / pestFps), 0).toDouble();
      position.x = next;
    }

    if (position.x <= 0) {
      game.level?.onPestReachBorder(this);
    }
  }

  Future<void> _onHit() async {
    if (current == PestAnimationType.hit || current == PestAnimationType.disappearing) {
      return;
    }

    current = PestAnimationType.hit;
    final delayInMs = (((pestFps / (1 / type.hitAnimationAmount)) * 1000)).floor();
    await Future.delayed(Duration(milliseconds: delayInMs));

    current = PestAnimationType.run;
  }

  Future<void> _onDisappearing() async {
    if (current == PestAnimationType.disappearing) {
      return;
    }

    _hitbox.removeFromParent();

    current = PestAnimationType.disappearing;
    final delayInMs = (((pestFps / disappearingStepTime) * 1000)).floor();
    await Future.delayed(Duration(milliseconds: delayInMs));

    _destroy();
  }

  void handleChemicalDamage() {
    final damage = (_currentHealth * type.chemicalPercentHit) / 100;
    _handleDamage(damage);
  }

  void _handleDamage(num damage) {
    if (_currentHealth > 0) {
      _currentHealth = _currentHealth - damage;
      _onHit();
    }

    if (_currentHealth < 0) {
      _currentHealth = 0;
    }

    if (_currentHealth == 0) {
      _onDisappearing();
    }
  }

  void _destroy() {
    game.level?.onPestKill(this);
    removeFromParent();
  }

  void _disposePlantEffectTimer() {
    _plantEffectTimer?.stop();
    _plantEffectTimer = null;
  }

  void _loadAllAnimations() {
    _runAnimation = fetchAmimation(
      game.images,
      of: type.title,
      type: 'Run',
      size: type.spriteSize,
      amount: type.runAnimationAmount,
    );

    _hitAnimation = fetchAmimation(
      game.images,
      of: type.title,
      type: 'Hit',
      size: type.spriteSize,
      amount: type.hitAnimationAmount,
    );

    _disappearingAnimation = SpriteAnimation.fromFrameData(
      game.images.fromCache('disappearing.png'),
      SpriteAnimationData.sequenced(
        amount: disappearingAmount,
        stepTime: disappearingStepTime,
        textureSize: Vector2(96, 96),
      ),
    );

    animations = {
      PestAnimationType.run: _runAnimation,
      PestAnimationType.hit: _hitAnimation,
      PestAnimationType.disappearing: _disappearingAnimation,
    };

    current = PestAnimationType.run;
  }
}
