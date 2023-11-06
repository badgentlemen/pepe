import 'package:flame/components.dart';

enum PestType {
  /// Кролик
  bunny,

  /// Слизень
  slime,

  /// Поросенок
  pig,
}

extension PestTypeExt on PestType {
  // Процент здоровья которое теряет вредитель от применения химикатов
  int get chemicalPercentHit {
    switch (this) {
      case PestType.bunny:
        return 20;
      case PestType.slime:
        return 25;
      case PestType.pig:
        return 30;
    }
  }

  /// Вознаграждение за уничтожение
  int get reward {
    switch (this) {
      case PestType.bunny:
        return 85;
      case PestType.slime:
        return 55;
      case PestType.pig:
        return 35;
    }
  }

  /// Наносимый урон
  int get damage {
    switch (this) {
      case PestType.bunny:
        return 20;
      case PestType.slime:
        return 15;
      case PestType.pig:
        return 8;
    }
  }

  /// Длительность анимации получения урона
  int get hitAnimationAmount {
    switch (this) {
      case PestType.bunny:
      case PestType.pig:
      case PestType.slime:
        return 5;
    }
  }

  /// Длительность анимации бега
  int get runAnimationAmount {
    switch (this) {
      case PestType.bunny:
      case PestType.pig:
        return 12;
      case PestType.slime:
        return 10;
    }
  }

  /// Процент уклонения от пули (пока не применяется на химикаты)
  int get dodgePercent {
    switch (this) {
      case PestType.bunny:
        return 12;
      case PestType.slime:
        return 7;
      case PestType.pig:
        return 4;
    }
  }

  /// Название вредителя
  String get title {
    switch (this) {
      case PestType.bunny:
        return 'Bunny';
      case PestType.slime:
        return 'Slime';
      case PestType.pig:
        return 'Pig';
    }
  }

  /// Изначальное здоровье
  int get health {
    switch (this) {
      case PestType.bunny:
        return 154;
      case PestType.slime:
        return 126;
      case PestType.pig:
        return 92;
    }
  }

  /// Размер спрайта вредителя в файлах /assets/images/
  Vector2 get spriteSize {
    switch (this) {
      case PestType.bunny:
        return Vector2(34, 44);
      case PestType.slime:
        return Vector2(44, 30);
      case PestType.pig:
        return Vector2(36, 30);
    }
  }
}
