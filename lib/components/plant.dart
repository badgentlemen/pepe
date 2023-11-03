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

class Plant extends SpriteAnimationGroupComponent with HasGameRef<PlantsVsPestsGame>, CollisionCallbacks {
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
    size = Vector2(game.blockSize, game.blockSize);

    priority = 1;

    animations = {
      PlantAnimationType.idle: fetchAmimation(
        images: game.images,
        of: 'Plant',
        type: 'Idle',
        size: Vector2(44, 42),
        amount: 11,
      ),
      PlantAnimationType.fire: fetchAmimation(
        images: game.images,
        of: 'Plant',
        type: 'Attack',
        size: Vector2(44, 42),
        amount: 8,
      ),
    };

    current = PlantAnimationType.idle;

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

    // if (canFire) {
    //   current = PlantAnimationType.fire;
    // } else {
    //   current = PlantAnimationType.idle;
    // }

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
