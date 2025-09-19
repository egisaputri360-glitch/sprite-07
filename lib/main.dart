import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:sprite_07/component/player_sprite_sheet_component_animation_full.dart';
import 'package:flutter/material.dart';

class MyGame extends FlameGame with HasKeyboardHandlerComponents {
  @override
  Future<void> onLoad() async {
    super.onLoad();
    add(PlayerSpriteSheetComponentAnimationFull());
  }
}

void main() {
  runApp(
    GameWidget(
      game: MyGame(),
    ),
  );
}
