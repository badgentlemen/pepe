import 'dart:async';

import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:pepe/field.dart';

class Workspace extends FlameGame with TapCallbacks {

  @override
  Color backgroundColor() {
    return Colors.grey.shade300;
  }

  @override
  FutureOr<void> onLoad() {
    final field = Field();

    add(field);

    return super.onLoad();
  }
}
