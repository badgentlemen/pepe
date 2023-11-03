import 'dart:async';

import 'package:flame/components.dart';
import 'package:pepe/components/sun.dart';
import 'package:pepe/constants.dart';
import 'package:pepe/plants_vs_pests_game.dart';

class SolarPanel extends SpriteComponent with HasGameRef<PlantsVsPestsGame> {
  SolarPanel({
    required this.index,
    required super.position,
    this.frequency = defaultSolarPanelFrequency,
    this.power = defaultSolarPanelPower,
  });

  static const aspectRatio = 70 / 45;

  final int index;

  final double frequency;

  final int power;

  Timer? _timer;

  Sun? _sun;

  bool get forwardToSun => game.primarySunPosition.x > position.x;

  @override
  FutureOr<void> onLoad() {
    size = game.solarPanelSize;

    sprite = Sprite(
      game.images.fromCache('solar_panel.png'),
    );

    _runMovingTimer();

    _addSun();

    return super.onLoad();
  }

  void _addSun() {
    final sunSize = Vector2(size.x / 2.5, size.x / 2.5);
    final sunPosition = Vector2(
      size.x / 2 - sunSize.x / 2,
      size.y / 2 - sunSize.y / 2,
    );

    _sun = Sun(
      position: sunPosition,
      size: sunSize,
      reversed: true,
    );

    add(_sun!);
  }

  void _runMovingTimer() {
    _timer = Timer(
      frequency,
      onTick: _onSave,
      repeat: true,
    );
  }

  @override
  void update(double dt) {
    _timer?.update(dt);
    _sun?.setOpacity(game.isSunBlocked ? 0 : 1);

    super.update(dt);
  }

  void _onSave() {
    if (!game.isSunBlocked) {
      game.increaseSunPower(power);
    }
  }
}
