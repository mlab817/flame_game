import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../main.dart';
import 'friend.dart';

class PlayerComponent extends SpriteAnimationComponent
    with CollisionCallbacks, HasGameRef<MyGame> {
  @override
  Future<void> onLoad() async {
    super.onLoad();
    add(RectangleHitbox.relative(
        parentSize: Vector2.all(64), Vector2.all(0.75)));
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    //
    if (other is ScreenHitbox) {
      print('hit screenhitbox');
    } else if (other is FriendComponent) {
      print('hit friend');
    }
    super.onCollisionEnd(other);
  }
}
