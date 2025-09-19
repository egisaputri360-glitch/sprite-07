import 'package:flame/sprite.dart';
import 'package:flame/flame.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:sprite_07/utils/create_animation_by_limit.dart';

class PlayerSpriteSheetComponentAnimationFull extends SpriteAnimationComponent
    with HasGameReference, KeyboardHandler {

  // Variabel ukuran layar
  late double screenWidth;
  late double screenHeight;

  // Titik tengah untuk posisi awal karakter
  late double centerX;
  late double centerY;

  // Ukuran setiap frame dalam sprite sheet
  final double spriteSheetWidth = 680;
  final double spriteSheetHeight = 472;

  // Kecepatan pergerakan karakter (pixel per detik)
  final double speed = 500;

  // Vector untuk arah dan kecepatan pergerakan
  Vector2 velocity = Vector2.zero();

  // Menyimpan arah hadap karakter (1 = kanan, -1 = kiri)
  double direction = 1;

  // Status apakah karakter sedang berjalan atau diam
  bool isMoving = false;

  // Mencegah input ganda ketika tombol ditekan cepat
  bool isTabPressed = false;

  // Kumpulan animasi yang digunakan
  late SpriteAnimation deadAnimation;
  late SpriteAnimation idleAnimation;
  late SpriteAnimation jumpAnimation;
  late SpriteAnimation runAnimation;
  late SpriteAnimation walkAnimation;

  @override
  void onLoad() async {
    // Memuat gambar sprite sheet
    final spriteImages = await Flame.images.load('dinofull.png');

    // Membuat objek SpriteSheet dengan ukuran frame
    final spriteSheet = SpriteSheet(
      image: spriteImages,
      srcSize: Vector2(spriteSheetWidth, spriteSheetHeight),
    );

    // Membuat animasi dari sprite sheet sesuai urutan frame
    deadAnimation = spriteSheet.createAnimationByLimit(xInit: 0, yInit: 0, step: 8, sizeX: 5, stepTime: .08);
    idleAnimation = spriteSheet.createAnimationByLimit(xInit: 1, yInit: 2, step: 10, sizeX: 5, stepTime: .08);
    jumpAnimation = spriteSheet.createAnimationByLimit(xInit: 3, yInit: 2, step: 12, sizeX: 5, stepTime: .08);
    runAnimation = spriteSheet.createAnimationByLimit(xInit: 1, yInit: 4, step: 8, sizeX: 5, stepTime: .08);
    walkAnimation = spriteSheet.createAnimationByLimit(xInit: 6, yInit: 2, step: 10, sizeX: 5, stepTime: .08);

    // Set animasi default saat pertama kali dimuat
    animation = runAnimation;

    // Menyimpan ukuran layar game
    screenWidth = game.size.x;
    screenHeight = game.size.y;

    // Set ukuran karakter berdasarkan ukuran frame
    size = Vector2(spriteSheetWidth, spriteSheetHeight);

    // Menghitung posisi awal karakter agar berada di tengah layar
    centerX = (screenWidth / 2) - (spriteSheetWidth / 2);
    centerY = (screenHeight / 2) - (spriteSheetHeight / 2);

    // Atur posisi awal karakter
    position = Vector2(centerX, centerY);
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Perbarui posisi karakter berdasarkan velocity
    position += velocity * dt;

    // Mencegah karakter keluar dari sisi layar
    position.x = position.x.clamp((width / 2) - 50, (screenWidth - (width / 2)) + 50);

    // Ubah animasi berdasarkan apakah karakter sedang bergerak atau tidak
    if (isMoving) {
      if (animation != walkAnimation) {
        animation = walkAnimation;
      }
    } else {
      if (animation != idleAnimation) {
        animation = idleAnimation;
      }
    }

    // Membalik arah karakter jika menghadap kiri
    scale.x = direction == -1 ? -1 : 1;
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    // Reset status gerakan setiap kali tombol dilepas
    isMoving = false;
    velocity.x = 0;

    // Jika tombol panah kiri ditekan
    if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      velocity.x = -speed; // Geser ke kiri
      direction = -1; // Menghadap kiri
      isMoving = true;
    }

    // Jika tombol panah kanan ditekan
    if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      velocity.x = speed; // Geser ke kanan
      direction = 1; // Menghadap kanan
      isMoving = true;
    }

    return true;
  }
}
