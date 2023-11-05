import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:pepe/components/bullet.dart';
import 'package:pepe/components/health_indicator.dart';
import 'package:pepe/components/pest.dart';
import 'package:pepe/constants.dart';
import 'package:pepe/models/plant_type.dart';
import 'package:pepe/p2p_game.dart';
import 'package:uuid/uuid.dart';

class Plant extends SpriteComponent with HasGameRef<P2PGame>, CollisionCallbacks {
  Plant(this.type) : id = const Uuid().v4();

  /// Тип растения
  final PlantType type;

  /// Идентификатор растения
  final String id;

  /// Уровень жизни растения
  int get health => type.health;

  /// Наносимый урон
  int get damage => type.damage;

  /// Стоимость
  int get price => type.price;

  /// Частота удара + стрельбы
  double get fireFrequency => type.fireFrequencySec;

  /// Интервал для стрельбы
  Timer? _movingTimer;

  Timer? _pestEffectTimer;

  /// Выросло ли растение
  bool _hasGrown = false;

  int _currentHealth = 0;

  /// Имеет возможность стрелять
  bool get canFire => _hasGrown;

  HealthIndicator? _healthIndicator;

  @override
  FutureOr<void> onLoad() async {
    _addHitbox();
    _setSprout();

    Future.delayed(Duration(milliseconds: type.growingTimeInMs), () => _initAfterGrown());

    return super.onLoad();
  }

  @override
  void update(double dt) {
    _movingTimer?.update(dt);
    _healthIndicator?.updateData(max: health, value: _currentHealth);
    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Pest) {
      _pestEffectTimer ??= Timer(
        1,
        onTick: () => _hitFromPest(other),
        repeat: true,
      );
    }

    super.onCollision(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    if (other is Pest) {
      _disposePestEffectTimer();
    }

    super.onCollisionEnd(other);
  }

  void _disposePestEffectTimer() {
    _pestEffectTimer?.stop();
    _pestEffectTimer = null;
  }

  void _hitFromPest(Pest pest) {
    if (health > 0) {
      _currentHealth = _currentHealth - pest.damage;
    }

    if (health <= 0) {
      removeFromParent();
    }
  }

  void _addHitbox() {
    add(
      RectangleHitbox(
        size: Vector2(game.blockSize, game.blockSize),
        position: Vector2(0, 0),
      ),
    );
  }

  void _setSprout() {
    _hasGrown = false;

    size = Vector2(game.blockSize, game.blockSize);

    sprite = Sprite(game.images.fromCache('sprout.png'));
  }

  void _initAfterGrown() {
    _hasGrown = true;
    _currentHealth = type.health;

    size = type.aspectSize(game.blockSize);
    position = Vector2(width / 2 - size.x / 2, height / 2 - size.y / 2);

    _addHealthIndicator();

    sprite = type.fetchSprite(game.images);


    _initFireTimer();
  }

  void _addHealthIndicator() {
    final indicatorSize = Vector2(game.blockSize * .7, 15);

    _healthIndicator = HealthIndicator(
      maxValue: health,
      currentValue: _currentHealth,
      size: indicatorSize,
      priority: 10,
      position: Vector2(width / 2 - indicatorSize.x / 2, -6),
    );

    add(_healthIndicator!);
  }

  void _initFireTimer() {
    _movingTimer = Timer(
      fireFrequency,
      onTick: _fire,
      repeat: true,
    );
  }

  void _fire() {
    if (isMounted && canFire) {
      final bullet = Bullet(
        position: Vector2(game.blockSize, game.blockSize / 2 - bulletRadius),
        damage: damage,
        color: type.color,
      );
      add(bullet);
    }
  }
}
