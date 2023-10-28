import 'dart:async';

import 'package:flame/components.dart';
import 'package:pepe/constants.dart';
import 'package:pepe/workspace.dart';
// import 'package:flame/extensions.dart';

class Plant extends SpriteAnimationComponent with HasGameRef<Workspace> {
  Plant({
    required this.id,
    required double offsetX,
    required double offsetY,
    required this.health,
    this.fireFrequency = 1,
    this.damage = defaultDamage,
  }) : super(
          position: Vector2(offsetX, offsetY),
        );

  /// Идентификатор растения
  final String id;

  /// Уровень жизни растения
  final int health;

  /// Наносимый урон
  final int damage;

  /// Частота удара + стрельбы
  final double fireFrequency;

  Timer? _interval;

  @override
  FutureOr<void> onLoad() async {
    size = blockSize;
    debugMode = true;

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

    // TODO: implement update
    super.update(dt);
  }

  void fire() {

  }
}
