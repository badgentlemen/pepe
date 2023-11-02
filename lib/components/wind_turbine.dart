import 'dart:async';

import 'package:flame/components.dart';
import 'package:pepe/plants_vs_pests_game.dart';

class WindTurbine extends SpriteComponent with HasGameRef<PlantsVsPestsGame> {
  WindTurbine({
    required this.frequency,
    required this.power,
  });

  /// Частота срабатывания
  final double frequency;

  /// Сила
  final int power;


  Timer? _timer;

  @override
  FutureOr<void> onLoad() {
    // sprite = Sprite(game.images.fromCache('turbine.jpeg'));

    _timer = Timer(
      frequency,
      onTick: _savePower,
      repeat: true,
    );

    return super.onLoad();
  }

  void _savePower() {

  }

  @override
  void update(double dt) {
    _timer?.update(dt);
    super.update(dt);
  }
}