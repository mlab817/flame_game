import 'package:flame/components.dart';
import 'package:flame/collisions.dart';

import '../main.dart';

class BakedGoodComponent extends SpriteComponent
    with CollisionCallbacks, HasGameRef<MyGame> {
  //
  late RectangleHitbox hitbox;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // make the hitbox in the inner box of the entire image
    hitbox =
        RectangleHitbox.relative(parentSize: Vector2.all(32), Vector2.all(0.5));

    add(hitbox);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    // add to baked goods
    gameRef.bakedGoodsCollected++;
    // remove when collected
    gameRef.remove(this);

    super.onCollision(intersectionPoints, other);
  }
}
