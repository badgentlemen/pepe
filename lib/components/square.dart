import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:pepe/components/plant.dart';
import 'package:pepe/models/plant_type.dart';
import 'package:pepe/p2p_game.dart';

class Square extends SpriteComponent with TapCallbacks, HasGameRef<P2PGame> {
  Square({
    required super.position,
    required this.plantType,
    required this.column,
    required this.row,
  });

  Plant? _plant;

  final PlantType plantType;

  final int row;

  final int column;

  bool get canBuy => game.level == null ? false : game.level!.sunPower >= plantType.price;

  bool get canPlant => _plant == null && canBuy;

  @override
  void onTapUp(TapUpEvent event) {
    if (_plant == null) {
      _addPlant();
    } else {
      _handleRemovePlant();
    }

    super.onTapUp(event);
  }

  Future<void> _handleRemovePlant() async {
    if (isMounted && game.buildContext != null && _plant != null) {
      final result = await FlutterPlatformAlert.showAlert(
        windowTitle: 'Удалить растение?',
        text: 'Стоимость растения вернется, но снаряды исчезнут',
        alertStyle: AlertButtonStyle.okCancel,
      );

      if (result == AlertButton.okButton) {
        _removePlant();
      }
    }
  }

  void _addPlant() {
    if (game.level == null) {
      return;
    }

    if (!canPlant) {
      return;
    }

    _plant = Plant(plantType);

    game.level!.reduceSunPower(_plant!.price);

    add(_plant!);
  }

  void _removePlant() {
    if (_plant == null || game.level == null) {
      return;
    }

    game.level!.increaseSunPower(_plant!.price);
    _plant!.removeFromParent();
    _plant = null;
  }

  @override
  FutureOr<void> onLoad() async {
    size = Vector2(game.blockSize, game.blockSize);
    sprite = plantType.fetchGrassSprite(game.images);

    priority = 1;
    return super.onLoad();
  }
}
