import 'dart:async';

import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:pepe/components/level.dart';
import 'package:pepe/components/solar_panel.dart';
import 'package:pepe/constants.dart';
import 'package:pepe/mock_level_scripts.dart';
import 'package:pepe/models/level_script.dart';

class P2PGame extends FlameGame with TapCallbacks, HasCollisionDetection, HasDraggablesBridge {
  double get blockSize => size.x / blockSizeImpl;

  double get fenceWidth => blockSize * .45;

  Vector2 get generatorSize => Vector2(blockSize, blockSize * generatorAssetRatio);
  Vector2 get generatorPosition => Vector2(size.x - blockSize - generatorSize.x, powerSunPosition.y);

  Vector2 get labelsSize => Vector2(60, 20);

  Vector2 get powerLabelPosition =>
      Vector2(dashboardPosition.x / 2 - labelsSize.x / 2, powerSunPosition.y + powerSunSize.y + 10);

  Vector2 get electricityLabelPosition => Vector2(generatorPosition.x, generatorPosition.y + generatorSize.x + 5);

  Vector2 get powerSunSize => Vector2(blockSize * 1.4, blockSize * 1.4);
  Vector2 get powerSunPosition => Vector2(dashboardPosition.x / 2 - powerSunSize.x / 2, 10);

  Vector2 get dashboardPosition => Vector2(blockSize * 2.7, 5);

  Vector2 get skyPosition => Vector2(dashboardPosition.x, blockSize * 2);

  Vector2 get primarySunPosition => Vector2(size.x - primarySunSize.x - blockSize, skyPosition.y);
  Vector2 get primarySunSize => Vector2(blockSize * 2.2, blockSize * 2.2);

  Vector2 get solarPanelSize => Vector2(blockSize * 1.5, (blockSize * 1.5) / SolarPanel.aspectRatio);
  Vector2 get solarPanelPosition => Vector2(dashboardPosition.x, size.y - blockSize - solarPanelSize.y);

  double get windTurbineHeight => blockSize * 1.2;
  double get windTurbineSpace => blockSize * .5;
  Vector2 get windTurbineSize => Vector2(windTurbineHeight * windTurbineAssetRatio, windTurbineHeight);
  Vector2 get windTurbinePosition => Vector2(size.x * .48, solarPanelPosition.y);

  double get cloudWidth => blockSize * 1.6;

  double get cardsWidth => blockSize * 1.6;
  double get cardsHeight => cardsWidth / cardsRatio;

  double get timingWidth => size.x / 4;

  final List<Level> _presetLevels = [
    Level(script: firstLevelScript),
    Level(script: secondLevelScript),
  ];

  String? loadImagesError;

  Level? level;

  @override
  Color backgroundColor() => Colors.transparent;

  @override
  FutureOr<void> onLoad() async {
    try {
      await images.loadAllImages();
    } catch (e) {
      loadImagesError = e.toString();
    }

    _runLevelAt(0);

    return super.onLoad();
  }

  void _runLevelAt(int index) {
    level?.removeFromParent();

    try {
      level = _presetLevels[index];
      add(level!);
    } catch (e) {}
  }
}
