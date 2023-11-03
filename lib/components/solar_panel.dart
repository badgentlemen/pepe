import 'dart:async';

import 'package:flame/components.dart';
import 'package:pepe/components/solar_panel_polygon.dart';
import 'package:pepe/components/sun.dart';
import 'package:pepe/constants.dart';
import 'package:pepe/plants_vs_pests_game.dart';

class SolarPanel extends SpriteComponent with HasGameRef<PlantsVsPestsGame> {
  SolarPanel({
    required this.index,
    required super.position,
    this.frequency = defaultSpeed,
    this.power = defaultPower,
  });

  static Vector2 defaultSize = Vector2(70, 45);

  final int index;

  final double frequency;

  final int power;

  Timer? _timer;

  bool get forwardToSun => game.primarySunPosition.x > position.x;

  SolarPanelPolygon? _checkPolygon;

  int get positionFromSun {
    double margin = 0;

    if (forwardToSun) {
      margin = game.primarySunPosition.x - (position.x + size.x);
    } else {
      margin = game.primarySunPosition.x + Sun.defaultSize.x - position.x;
    }

    return margin.abs().floor();
  }

  @override
  FutureOr<void> onLoad() {
    size = defaultSize;
    sprite = Sprite(
      game.images.fromCache('solar_panel.png'),
    );

    _addHitboxPolygon();
    _runMovingTimer();

    return super.onLoad();
  }

  void _addHitboxPolygon() {
    _checkPolygon = SolarPanelPolygon(
      [
        Vector2(position.x, position.y),
        Vector2(game.primarySunPosition.x, game.primarySunPosition.y),
        Vector2(game.primarySunPosition.x + Sun.defaultSize.x, game.primarySunPosition.y + Sun.defaultSize.y),
        Vector2(position.x + size.x, position.y + size.y),
      ],
    );

    parent?.add(_checkPolygon!);
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
    super.update(dt);
  }

  void _onSave() {

  }
}
