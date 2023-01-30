class FPlayer extends FGameObject { //F player behaves as an f box

  int lives = 5;
  int frame;
  int direction;


  FPlayer() {
    super(gridSize, gridSize); //fbox constructor, width, height
    frame = 0;
    direction = R;
    setPosition(300, 500);
    setName("player");
    setRotatable(false);
    //attachImage(idle[0]);
  }

  void act() {
    handleInput(); //Left right jump
    handleCollisions();
    animate();
    gameover();
  }

  void handleInput() {
    float vX = getVelocityX();
    float vY = getVelocityY();

    if (vY < 0.1) {
      action = idle;
    }

    if (aKey) {
      setVelocity(-200, vY);
      action = run;
      direction = L;
    }
    if (dKey) {
      setVelocity(200, vY);
      action = run;
      direction = R;
    }

    if (wKey && isTouching("grassTile") || wKey && isTouching("bridgeTile") || wKey && isTouching("stone") || wKey && isTouching("iceTile") || wKey && isTouching("treetop")|| wKey && isTouching("dirtTile")) {
      setVelocity(vX, -600);
    }

    if (abs(vY) > 0.1)
      action = jump;
  }

  void handleCollisions() {
    if (isTouching("spike") || isTouching("lava") || isTouching("hammer")) {
      setPosition(300, 500);
      lives--;
    }
  }

  void gameover() {
    textSize(50);

    if (lives < 5) {
      image(bHeart, 500, 20);
    } else {
      image(rHeart, 500, 20);
    }
    if (lives < 4) {
      image(bHeart, 525, 20);
    } else {
      image(rHeart, 525, 20);
    }
    if (lives < 3) {
      image(bHeart, 550, 20);
    } else {
      image(rHeart, 550, 20);
    }
    if (lives < 2) {
      image(bHeart, 575, 20);
    } else {
      image(rHeart, 575, 20);
    }
    if (lives < 1) {
      image(bHeart, 600, 20);
    } else {
      image(rHeart, 600, 20);
    }


    if (lives <= 0) {
      rectMode(CENTER);
      fill(#F51111);
      rect(width/2, height/2, width+25, height+25);
      fill(#FFDC0F);
      textAlign(CENTER);
      text("GAMEOVER", width/2, height/2);
    }
  }

  void animate() {
    if (frame >= action.length) frame = 0;
    if (frameCount % 5 == 0 ) {
      if (direction == R) attachImage(action[frame]);
      if (direction == L) attachImage(reverseImage(action[frame]));
      frame++;
    }
  }
}
