import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../main.dart';

class ObstacleComponent extends PositionComponent with CollisionCallbacks {
  final MyGame game;

  ObstacleComponent({required this.game});

  late RectangleHitbox hitbox;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    hitbox = RectangleHitbox();

    add(hitbox);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    //
  }
}
