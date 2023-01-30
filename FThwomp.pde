class FThwomp extends FGameObject {

  int speed = 50;
  int frame = 0;

  FThwomp(float w, float h, int x, int y) {
    super(x, y);
    setPosition(w, h);
    setName("thwomp");
    setRotatable(false);
    setStatic(true);
    attachImage(thwomp0);
  }

  void act() {
    collide();
    faces();
  }


  void collide() {
    if (abs(getX() - player.getX()) < 32 && getY() < player.getY()) {
      setStatic(false);
      println("ur mum");
      attachImage(thwomp1);
    }



    if (isTouching("player")) {
      if (player.getY() < getY()-gridSize/1.25) {
        world.remove(this);
        enemies.remove(this);
        player.setVelocity(player.getVelocityX(), -300);
      } else {
        player.lives--;
        player.setPosition(300, 500);
      }
    }
  }

  void faces() {
  }
}
