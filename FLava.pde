class FLava extends FGameObject {
  int frame = (int) random(0, 4);
  FLava(float x, float y) {
    super();
    setPosition(x, y);
    setStatic(true);
    setSensor(true);
    setName("lava");
  }

  void act() {
    animate();
  }

  void animate() {
    action = lavaSprites;
    if (frame >= action.length) frame = 0;
    if (frameCount % objectRefresh == 0) {
      attachImage(lavaSprites[frame]);
      frame++;
    }
  }
}
