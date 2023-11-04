import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:pepe/components/bullet.dart';
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
  int get costs => type.costs;

  /// Частота удара + стрельбы
  double get fireFrequency => type.fireFrequency;

  /// Интервал для стрельбы
  Timer? _interval;

  /// Выросло ли растение
  bool _hasGrown = false;

  /// Имеет возможность стрелять
  bool get canFire => _hasGrown;

  @override
  FutureOr<void> onLoad() async {
    _setSprout();

    Future.delayed(Duration(milliseconds: type.growingTimeInMs), () => _initAfterGrown());

    return super.onLoad();
  }

  void _setSprout() {
    _hasGrown = false;

    size = Vector2(game.blockSize, game.blockSize);

    sprite = Sprite(game.images.fromCache('sprout.png'));
  }

  void _initAfterGrown() {
    _hasGrown = true;

    size = type.aspectSize(game.blockSize);
    position = Vector2(width / 2 - size.x / 2, height / 2 - size.y / 2);

    sprite = type.fetchSprite(game.images);

    _initFireTimer();
  }

  void _initFireTimer() {
    _interval = Timer(
      fireFrequency,
      onTick: fire,
      repeat: true,
    );
  }

  @override
  void update(double dt) {
    _interval?.update(dt);
    super.update(dt);
  }

  void fire() {
    if (isMounted && canFire) {
      final bullet = Bullet(
        position: Vector2(game.blockSize, game.blockSize / 2 - (bulletRadius / 2)),
        damage: damage,
        color: type.color,
      );
      add(bullet);
    }
  }
}
