//William Cheng
//Programming 12

import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

import fisica.*;
FWorld world;

//Color
color black = #000000;
color white = #FFFFFF;
color leafGreen = #9edb69;
color grassGreen = #64f013;
color waterBlue = #2525a8;
color iceBlue = #36e8c4;
color trunkBrown = #665737;
color dirtBrown = #ba6747;
color bridgeBrown = #c97b06;

color fenceBrown = #5e481e;
color stoneGrey = #94928e;
color spikeGrey = #9e727b;
color lavaRed = #f70521;


color trampolinePink = #e43cfa;
color goombaYellow = #eafa3c;
color thwompPurple = #7800FF;
color hammerBroOrange = #FFFFBE00;

PImage map, dirt, grassT, marioL, marioR, bridgeL, bridgeM, bridgeR, fenceL, fenceM, fenceR, grassB, grassBL, grassBR, grassL, grassR, grassTL, grassTR, ice, lava0, lava1, lava2, lava3, lava4, lava5, lava6, leafL, leafM, leafR, stone, trunk, trunkLeaf, water1, water2, water3, water4, water5, spike, trampoline, thwomp0, thwomp1, hammer;
PImage rHeart, bHeart;
int gridSize = 32;
int objectRefresh = 15;
int playerRefresh = 5;
int frameMultiplier = 60;
int gravity = 900;
float zoom = 0.8; //camera zoom

float oxygenLevel = 3*frameMultiplier;

boolean wKey, aKey, sKey, dKey, upKey, downKey, leftKey, rightKey, spaceKey, swimming, isIdle;
FPlayer player;
FBox borderL;

ArrayList<FGameObject> terrain; //special terrain
ArrayList<FGameObject> enemies;
PImage[] lavaSprites;
PImage[] waterSprites;

PImage[] idle;
PImage[] jump;
PImage[] run;
PImage[] action;

PImage[] goombas;
PImage[] hammerBro;

PFont pixelFont;

void setup() {
  size(640, 640);
  frameRate(60);

  rHeart = loadImage("textures/rHeart.png");
  bHeart = loadImage("textures/bHeart.png");

  lavaSprites = new PImage[6];
  lavaSprites[0] = loadImage("textures/lava0.png");
  lavaSprites[1] = loadImage("textures/lava0.png");
  lavaSprites[2] = loadImage("textures/lava2.png");
  lavaSprites[3] = loadImage("textures/lava3.png");
  lavaSprites[4] = loadImage("textures/lava4.png");
  lavaSprites[5] = loadImage("textures/lava5.png");

  waterSprites = new PImage[4];
  waterSprites[0] = loadImage("textures/water0.png");
  waterSprites[1] = loadImage("textures/water1.png");
  waterSprites[2] = loadImage("textures/water2.png");
  waterSprites[3] = loadImage("textures/water3.png");
  swimming = false;

  //========================================================================================
  idle = new PImage[2];
  idle[0] = loadImage("textures/PIdle0.png");
  idle[1] = loadImage("textures/PIdle1.png");

  jump = new PImage[1];
  jump[0] = loadImage("textures/PJump0.png");

  run = new PImage[3];
  run[0] = loadImage("textures/PRun0.png");
  run[1] = loadImage("textures/PRun1.png");
  run[2] = loadImage("textures/PRun2.png");

  action = idle;

  //=========================================================================================================
  goombas = new PImage[2];
  goombas[0] = loadImage("textures/goomba0.png");
  goombas[0].resize(gridSize, gridSize);
  goombas[1] = loadImage("textures/goomba1.png");
  goombas[1].resize(gridSize, gridSize);

  hammerBro = new PImage[2];
  hammerBro[0] = loadImage("textures/hammerbro0.png");
  hammerBro[1] = loadImage("textures/hammerbro1.png");
  hammer = loadImage("textures/hammer.png");

  Fisica.init(this);
  terrain = new ArrayList<FGameObject>();
  enemies = new ArrayList<FGameObject>();
  thwomp0 = loadImage("textures/thwomp0.png");
  thwomp1 = loadImage("textures/thwomp1.png");

  map = loadImage("map2.png");
  marioL = loadImage("textures/marioL.png");
  marioR = loadImage("textures/marioR.png");
  bridgeL = loadImage("textures/bridgeL.png");
  bridgeM = loadImage("textures/bridgeM.png");
  bridgeR = loadImage("textures/bridgeR.png");
  dirt = loadImage("textures/dirt.png");
  fenceL = loadImage("textures/fenceL.png");
  fenceM = loadImage("textures/fenceL.png");
  fenceR = loadImage("textures/fenceR.png");
  grassB = loadImage("textures/grassB.png");
  grassBL = loadImage("textures/grassBL.png");
  grassBR = loadImage("textures/grassBR.png");
  grassL = loadImage("textures/grassL.png");
  grassR = loadImage("textures/grassR.png");
  grassT = loadImage("textures/grassT.png");
  grassTL = loadImage("textures/grassTL.png");
  grassTR = loadImage("textures/grassTR.png");
  ice = loadImage("textures/ice.png");
  //ice.resize(32, 32);
  lava6 = loadImage("textures/lava6.png");
  leafL = loadImage("textures/leafL.png");
  leafM = loadImage("textures/leafM.png");
  leafR = loadImage("textures/leafR.png");
  stone = loadImage("textures/stone.png");
  trunk = loadImage("textures/trunk.png");
  trunkLeaf = loadImage("textures/trunkLeaf.png");
  water4 = loadImage("textures/water4.png");
  spike = loadImage("textures/spike.png");
  trampoline = loadImage("textures/trampoline.png");
  loadWorld(map);
  loadPlayer();
}

void loadWorld(PImage img) {
  world = new FWorld(-3000, -3000, 3000, 3000);
  world.setGravity(0, 900);
  world.setGrabbable(false); //ask

  for (int y = 0; y < img.height; y++) { //image or map.height?
    for (int x = 0; x < img.width; x++) {
      color c = img.get(x, y); //c color at that pixel
      FBox b = new FBox(gridSize, gridSize);
      b.setPosition (x*gridSize, y*gridSize);
      b.setStatic(true);

      color cn = img.get(x, y-1);
      color ce = img.get(x+1, y);
      color cs = img.get(x, y+1);
      color cw = img.get(x-1, y);
      int n = img.get(x, y-1);
      int e = img.get(x+1, y);
      int s = img.get(x, y+1);
      int w = img.get(x-1, y);


      if (c == dirtBrown) { //
        b.attachImage(dirt);
        b.setName("dirtTile");
        b.setFriction(1.5);
        world.add(b); //
      } else if (c == grassGreen) {
        b.attachImage(grassT);
        b.setName("grassTile");
        b.setFriction(1.5);
        world.add(b);
      } else if (c == iceBlue) {
        b.attachImage(ice);
        b.setName("iceTile");
        b.setFriction(0.1);
        world.add(b);
      } else if (c == trampolinePink) {
        b.attachImage(trampoline);
        b.setName("trampolineTile");
        b.setFriction(1);
        b.setRestitution(2);
        world.add(b);
      } else if (c == black) { //stone block
        b.attachImage(stone);
        b.setName("stone");
        b.setFriction(1.5);
        world.add(b);
      } else if (c == stoneGrey) { //stone block
        b.attachImage(stone);
        b.setName("wall");
        world.add(b);
      }


      //Trunk n Leaves
      else if (c == trunkBrown) {
        b.attachImage(trunk);
        b.setSensor(true);
        b.setName("tree trunk");
        world.add(b);
      } else if (c == leafGreen && cs == trunkBrown) {
        b.attachImage(trunkLeaf);
        b.setSensor(true);
        b.setName("tree turnk");
        world.add(b);
      } else if (c == leafGreen && cw == leafGreen && e == leafGreen) { //middle block
        b.attachImage(leafM);
        b.setName("treetop");
        world.add(b);
      } else  if (c == leafGreen && cw != leafGreen) { //west/left
        b.attachImage(leafL);
        b.setName("treetop");
        world.add(b);
      } else  if (c == leafGreen && ce != leafGreen) { //east/right
        b.attachImage(leafR);
        b.setName("treetop");
        world.add(b);
      } else if (c == spikeGrey) {
        b.attachImage(spike);
        b.setName("spike");
        world.add(b);
      } else if (c == bridgeBrown) {
        FBridge br = new FBridge(x*gridSize, y*gridSize);
        terrain.add(br);
        br.setName("bridgeTile");
        world.add(br);
      } else if (c == goombaYellow) {
        FGoomba gmb = new FGoomba(x*gridSize, y*gridSize);
        enemies.add(gmb);
        world.add(gmb);
      } else if (c == waterBlue && cn == waterBlue) {
        b.attachImage(water4);
        b.setName("water");
        b.setSensor(true);
        world.add(b);
      } else if (c == waterBlue) {
        FWater wtr = new FWater(x*gridSize, y*gridSize);
        terrain.add(wtr);
        world.add(wtr);
      } else if (c == spikeGrey) {
        b.attachImage(spike);
        b.setName("spike");
        world.add(b);
      } else if (c == lavaRed) {
        FLava lva = new FLava(x*gridSize, y*gridSize);
        terrain.add(lva);
        world.add(lva);
      } else if (c == thwompPurple) {
        FThwomp tmp = new FThwomp(x*gridSize, y*gridSize, gridSize*2, gridSize*2);
        terrain.add(tmp);
        world.add(tmp);
      } else if (c == hammerBroOrange) {
        FHammerBro hmb = new FHammerBro(x*gridSize, y*gridSize);
        terrain.add(hmb);
        world.add(hmb);
      }
    }
  }
}
void loadPlayer() {
  player = new FPlayer();
  world.add(player);
}



void draw() {
  background(#AEC6CF);
  drawWorld();
  actWorld(); //player act
}

void drawWorld() {

  pushMatrix();
  if (player.getX() < 180) {
    translate(-180*zoom+width/2, -player.getY()*zoom+height/2); //negative to counter normal
  } else {
    translate(-player.getX()*zoom+width/2, -player.getY()*zoom+height/2);
  }
  scale(zoom);
  world.step();
  world.draw();
  popMatrix();
}

void actWorld() {

  player.act();

  for (int i = 0; i < terrain.size(); i++) {
    FGameObject t = terrain.get(i);
    t.act();
  }

  for (int i = 0; i < enemies.size(); i++) {
    FGameObject e = enemies.get(i);
    e.act();
  }
  if (!swimming) {
    world.setGravity(0, 900);
    playerRefresh = 5;
  }
  if (swimming) {
    world.setGravity(0, 90);
    playerRefresh = 12;
  }
}
