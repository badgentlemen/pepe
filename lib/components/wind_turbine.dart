import 'dart:async';

import 'package:flame/components.dart';
import 'package:pepe/components/bolt.dart';
import 'package:pepe/p2p_game.dart';

class WindTurbine extends SpriteComponent with HasGameRef<P2PGame> {
  WindTurbine({
    required this.frequency,
    required this.power,
    super.position,
  });

  /// Частота срабатывания
  final double frequency;

  /// Сила
  final int power;

  final boltWidth = 20.0;

  Timer? _timer;

  Bolt? _bolt;

  @override
  FutureOr<void> onLoad() {
    size = game.windTurbineSize;
    sprite = Sprite(game.images.fromCache('wind_turbine.png'));

    _addBoltIndicator();

    _timer = Timer(
      frequency,
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

  void _saveElectricity() {}

  @override
  void update(double dt) {
    _timer?.update(dt);
    _bolt?.setOpacity(game.isSunBlocked ? 1 : 0);

    super.update(dt);
  }
}
