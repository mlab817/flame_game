import 'package:carrot/main.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class DialogBox extends TextBoxComponent {
  //
  final MyGame game;

  DialogBox({required String text, required this.game})
      : super(
            text: text,
            position: game.size,
            boxConfig: TextBoxConfig(
              dismissDelay: 5.0,
              maxWidth: game.size.x * 0.5,
              timePerChar: 0.05,
            )) {
    anchor = Anchor.bottomRight;
  }

  @override
  void drawBackground(Canvas c) {
    //
    Rect rect = Rect.fromLTWH(0, 0, width, height);
    c.drawRect(rect, Paint()..color = const Color(0x8f37474f));
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (finished) {
      game.remove(this);
    }
  }
}
