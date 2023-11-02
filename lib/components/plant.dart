import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:pepe/components/bullet.dart';
import 'package:pepe/constants.dart';
import 'package:pepe/components/pest.dart';
import 'package:pepe/models/plant_type.dart';
import 'package:pepe/plants_vs_pests_game.dart';
import 'package:pepe/utils.dart';
import 'package:uuid/uuid.dart';
// import 'package:flame/extensions.dart';

enum PlantAnimationType {
  idle,
}

class Plant extends SpriteAnimationGroupComponent with HasGameRef<PlantsVsPestsGame>, CollisionCallbacks {
  Plant(this.type) : id = const Uuid().v4();

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

  bool get canFire => game.power >= damage;

  @override
  FutureOr<void> onLoad() async {
    size = blockSize;
    priority = 1;

    animations = {
      PlantAnimationType.idle: fetchAmimation(
        images: game.images,
        of: 'Plant',
        type: 'Idle',
        size: Vector2(44, 42),
        amount: 11,
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
    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Pest) {
      print('pest');
    }

    // TODO: implement onCollision
    super.onCollision(intersectionPoints, other);
  }

  void fire() {
    if (isMounted && canFire) {
      final bullet = Bullet(
        position: Vector2(blockSize.x, blockSize.y / 2 - (Bullet.defaultSize.y / 2)),
        damage: damage,
      );

      game.reducePower(bullet.damage);

      add(bullet);
    }
  }
}
