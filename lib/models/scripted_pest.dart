import 'package:pepe/models/pest_type.dart';
import 'package:uuid/uuid.dart';

class ScriptedPest {
  ScriptedPest({
    required this.type,
    required this.onTime,
    required this.row,
  }) : id = const Uuid().v4();

  final String id;

  /// delay после которого вредитель вступает в игру
  final Duration onTime;

  /// Строка поля по которому пойдет вредитель
  final int row;

  /// Тип вредителя
  final PestType type;

  int get delayDurationSec => onTime.inSeconds;
}
