import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../dialogs/dialog_box.dart';
import '../main.dart';

class FriendComponent extends PositionComponent with CollisionCallbacks {
  final MyGame game;

  FriendComponent({required this.game});

  //
  late RectangleHitbox hitbox;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    hitbox = RectangleHitbox();

    add(hitbox);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    // stop when the player hits a friend
    game.dialogBox = DialogBox(text: 'This is my message to you!', game: game);
    game.add(game.dialogBox!);

    game.direction = Direction.idle;

    remove(hitbox);

    super.onCollision(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    print("I made a new friend");

    super.onCollisionEnd(other);
  }
}
