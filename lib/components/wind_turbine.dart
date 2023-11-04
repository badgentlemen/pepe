import 'dart:async';

import 'package:flame/components.dart';
import 'package:pepe/components/bolt.dart';
import 'package:pepe/constants.dart';
import 'package:pepe/p2p_game.dart';

class WindTurbine extends SpriteComponent with HasGameRef<P2PGame> {
  WindTurbine({
    this.power = systemPowerPerFrequency,
    this.index = 0,
    super.position,
  });

  /// Сила
  final int power;

  final int index;

  final boltWidth = 20.0;

  Timer? _timer;

  Bolt? _bolt;

  @override
  FutureOr<void> onLoad() {
    size = game.windTurbineSize;
    sprite = Sprite(game.images.fromCache('wind_turbine.png'));

    _addBoltIndicator();

    _timer = Timer(
      1,
      onTick: _saveElectricity,
      repeat: true,
    );

    return super.onLoad();
  }

  void _addBoltIndicator() {
    _bolt = Bolt(
      w: boltWidth,
      position: Vector2(
        width / 2 - boltWidth / 2,
        height / 2,
      ),
    );

    add(_bolt!);
  }

  void _saveElectricity() {
    game.increaseElectricity(power);
  }

  @override
  void update(double dt) {
    _timer?.update(dt);
    _bolt?.setOpacity(game.isSunBlocked ? 1 : 0);

    super.update(dt);
  }
}
