class FWater extends FGameObject {
  int frame = (int) random(0, 4);
  FWater(float x, float y) {
    super();
    setPosition(x, y);
    setStatic(true);
    setSensor(true);
    setName("waterTile");
  }

  void act() {
    animate();
  }

  void animate() {
    action = waterSprites;
    if (frame >= action.length) frame = 0;
    if (frameCount % objectRefresh == 0) {
      attachImage(waterSprites[frame]);
      frame++;
    }
  }
}
