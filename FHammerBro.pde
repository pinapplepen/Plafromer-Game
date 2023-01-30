class FHammerBro extends FGameObject {

  int direction = L;
  int speed = 50;
  int frame = 0;
  int i = 0;
  int coolDown;
  boolean isAlive = true;
  
  FHammerBro(float x, float y) {
    super();
    setPosition(x, y);
    setName("hammerBro");
    setRotatable(false);
  }

  void act() {
    animate();
    collide();
    move();
    hammerThrow();
  }

  void hammerThrow() {
    coolDown++;

    if (coolDown > 150 && isAlive) {
      FBox b = new FBox(gridSize, gridSize);
      b.setPosition(getX(), getY());
      b.setSensor(true);
      b.setVelocity(200*random(-1, 1), -550);
      b.attachImage(hammer);
      b.setAngularVelocity(80);
      b.setName("hammer");
      world.add(b);
      coolDown = 0;
    }
  }


  void animate() {
   
    if (frame >= hammerBro.length) frame = 0;
    if (frameCount%5 == 0) {
      if (direction == R) attachImage(hammerBro[frame]);
      if (direction == L) attachImage(reverseImage(hammerBro[frame]));
      frame++;
    }
    
  }

  void collide() {

    if (isTouching("player")) {
      if (player.getY() < getY()-gridSize/1.25) {
        world.remove(this);
        enemies.remove(this);
        isAlive = false;
        player.setVelocity(player.getVelocityX(), -300);
      } else {
        player.lives--;
        player.setPosition(300, 500);
      }
    }
  }

  void move() {

    i++;
    if (i > 75) {
      direction = direction * -1;
      i = 0;
    }
    float vy = getVelocityY();
    setVelocity(speed*direction, vy);
  }
}
