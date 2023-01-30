class FBridge extends FGameObject {

  FBridge(float x, float y) {
    super();
    setPosition(x, y);
    setName("bridge");
    attachImage(bridgeM);
    setStatic(true);
  }

  void act() {
    if (isTouching("player")) {
      setStatic(false);
      setSensor(true);  //go away when out of world
    }
  }
}
