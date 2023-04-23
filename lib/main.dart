import 'package:carrot/dialogs/dialog_box.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'components/baked_goods.dart';
import 'components/friend.dart';
import 'components/player.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GameWidget(
        game: MyGame(),
      ),
    ),
  );
}

enum Direction {
  idle,
  up,
  left,
  down,
  right,
}

class MyGame extends FlameGame with KeyboardEvents, HasCollisionDetection {
  late ParallaxComponent parallaxComponent;

  late PlayerComponent player;

  late SpriteAnimation upAnimation;
  late SpriteAnimation rightAnimation;
  late SpriteAnimation downAnimation;
  late SpriteAnimation leftAnimation;
  late SpriteAnimation idleAnimation;
  late SpriteAnimation explosionAnimation;

  late double mapWidth;
  late double mapHeight;

  DialogBox? dialogBox;

  final double animationSpeed = 0.1;
  final double characterSize = 64;
  final double characterSpeed = 80;

  // set initial direction to idle
  Direction direction = Direction.idle;
  int bakedGoodsCollected = 0;

  @override
  Color backgroundColor() => const Color(0xFFFFFFFF);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // load the tiledMap
    final homeMap = await TiledComponent.load('map.tmx', Vector2.all(16));
    add(homeMap);

    // set the map height and width
    mapWidth = homeMap.tileMap.map.width * 16;
    mapHeight = homeMap.tileMap.map.height * 16;

    final upSpriteSheet = SpriteSheet(
        image: await images.load('ACharUp.png'), srcSize: Vector2(24, 24));
    final leftSpriteSheet = SpriteSheet(
        image: await images.load('ACharLeft.png'), srcSize: Vector2(24, 24));
    final downSpriteSheet = SpriteSheet(
        image: await images.load('ACharDown.png'), srcSize: Vector2(24, 24));
    final rightSpriteSheet = SpriteSheet(
        image: await images.load('ACharRight.png'), srcSize: Vector2(24, 24));

    upAnimation =
        upSpriteSheet.createAnimation(row: 0, stepTime: animationSpeed, to: 4);
    leftAnimation = leftSpriteSheet.createAnimation(
        row: 0, stepTime: animationSpeed, to: 4);
    downAnimation = downSpriteSheet.createAnimation(
        row: 0, stepTime: animationSpeed, to: 4);
    rightAnimation = rightSpriteSheet.createAnimation(
        row: 0, stepTime: animationSpeed, to: 4);
    idleAnimation = downSpriteSheet.createAnimation(
        row: 0, stepTime: animationSpeed, to: 1);

    player = PlayerComponent()
      ..animation = idleAnimation
      ..position = Vector2(196, mapHeight - characterSize)
      // ..debugMode = true
      ..size = Vector2.all(
        characterSize,
      );

    add(player);

    final friendGroup = homeMap.tileMap.getLayer<ObjectGroup>('Friends');

    if (friendGroup != null) {
      for (var friendBox in friendGroup.objects) {
        add(FriendComponent(game: this)
          // ..debugMode = true
          ..position = Vector2(friendBox.x, friendBox.y)
          ..width = friendBox.width
          ..height = friendBox.height);
      }
    }

    final bakedGoodsGroup = homeMap.tileMap.getLayer<ObjectGroup>('BakedGoods');

    if (bakedGoodsGroup != null) {
      for (var bakedGoodsBox in bakedGoodsGroup.objects) {
        debugPrint(bakedGoodsBox.type);
        var bakedGoodType = '';
        switch (bakedGoodsBox.type) {
          case 'ApplePie':
            bakedGoodType = 'apple_pie.png';
            break;
          case 'Cheesecake':
            bakedGoodType = 'cheesecake.png';
            break;
          case 'Cookies':
            bakedGoodType = 'cookies.png';
            break;
          case 'Chocolate':
            bakedGoodType = 'chocolate.png';
            break;
          case 'ChocoCake':
            bakedGoodType = 'chocolatecake.png';
            break;
        }

        add(BakedGoodComponent()
          // ..debugMode = true
          ..position = Vector2(bakedGoodsBox.x, bakedGoodsBox.y)
          ..sprite = await loadSprite(bakedGoodType)
          ..width = bakedGoodsBox.width
          ..height = bakedGoodsBox.height);
      }
    }

    // dialogBox = DialogBox(text: 'Some text for dialog...', game: this);

    camera.followComponent(player,
        worldBounds: Rect.fromLTRB(0, 0, mapWidth, mapHeight));
  }

  @override
  void update(double dt) {
    super.update(dt);

    switch (direction) {
      case Direction.idle:
        player.animation = idleAnimation;
        break;
      case Direction.up:
        if (player.y > 0) {
          player.animation = upAnimation;
          player.y -= dt * characterSpeed;
        } else {
          direction = Direction.idle;
        }
        break;
      case Direction.right:
        if (player.x < mapWidth - characterSize) {
          player.animation = rightAnimation;
          player.x += dt * characterSpeed;
        } else {
          direction = Direction.idle;
        }
        break;
      case Direction.down:
        if (player.y < mapHeight - characterSize) {
          player.animation = downAnimation;
          player.y += dt * characterSpeed;
        } else {
          direction = Direction.idle;
        }
        break;
      case Direction.left:
        if (player.x > 0) {
          player.animation = leftAnimation;
          player.x -= dt * characterSpeed;
        } else {
          direction = Direction.idle;
        }
        break;
    }
  }

  @override
  KeyEventResult onKeyEvent(
      RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final isKeyDown = event is RawKeyDownEvent;

    final isUp = keysPressed.contains(LogicalKeyboardKey.arrowUp);
    final isRight = keysPressed.contains(LogicalKeyboardKey.arrowRight);
    final isDown = keysPressed.contains(LogicalKeyboardKey.arrowDown);
    final isLeft = keysPressed.contains(LogicalKeyboardKey.arrowLeft);

    if (isKeyDown) {
      if (isUp) {
        // add(golems[0]);
        direction = Direction.up;
      } else if (isRight) {
        // add(golems[1]);
        direction = Direction.right;
      } else if (isDown) {
        // add(golems[2]);
        direction = Direction.down;
      } else if (isLeft) {
        // add(golems[3]);
        direction = Direction.left;
      } else {
        direction = Direction.idle;
      }
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }
}
