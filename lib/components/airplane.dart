import 'package:flame/components.dart';
import 'package:pepe/components/airplane_sprite.dart';
import 'package:pepe/constants.dart';
import 'package:pepe/models/airplane_type.dart';

class Airplane extends AirplaneSprite {
  Airplane({
    required this.type,
    required super.width,
  });

  final AirplaneType type;

  double get _timeInCloudsSec => 3;

  double get _distance => game.size.x + width;

  @override
  Future<void> onLoad() async {
    position = Vector2(game.dashboardPosition.x, game.skyPosition.y + game.blockSize);
    return super.onLoad();
  }

  @override
  void update(double dt) {
    _fly();
    super.update(dt);
}

  void _fly() {
    if (position.x <= _distance) {
      position.x += 7;
    }

    if (position.x > _distance) {
      removeFromParent();
    }
  }
}
