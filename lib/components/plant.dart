import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:pepe/components/bullet.dart';
import 'package:pepe/models/plant_type.dart';
import 'package:pepe/plants_vs_pests_game.dart';
import 'package:pepe/utils.dart';
import 'package:uuid/uuid.dart';
// import 'package:flame/extensions.dart';

enum PlantAnimationType {
  idle,
  fire,
}

class Plant extends SpriteComponent with HasGameRef<PlantsVsPestsGame>, CollisionCallbacks {
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

  Timer? _interval;

  bool get canFire => true;

  @override
  FutureOr<void> onLoad() async {
    size = type.aspectSize(game.blockSize);
    position = Vector2(width / 2 - size.x / 2, height / 2 - size.y / 2);
    sprite = type.fetchSprite(game.images);

    debugMode = true;

    priority = 1;

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

  void fire() {
    if (isMounted && canFire) {
      final bullet = Bullet(
        position: Vector2(game.blockSize, game.blockSize / 2 - (Bullet.defaultSize.y / 2)),
        damage: damage,
      );
      add(bullet);
    }
  }
}
