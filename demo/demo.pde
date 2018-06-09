import moonlander.library.*;
import ddf.minim.*;

Moonlander moonlander;

void settings() {
  size(640, 480, P3D);
}

void setup() {
  moonlander = Moonlander.initWithSoundtrack(this, "tekno_127bpm.mp3", 127, 8);
  moonlander.start();
  frameRate(60);
  noiseSeed(1337);
}

PVector[] initMousePointerCoords() {
  PVector[] ret = {
    new PVector(0, 0),
    new PVector(100, 100),
    new PVector(55, 100),
    new PVector(75, 135),
    new PVector(55, 145),
    new PVector(35, 110),
    new PVector(0, 140),
  };
  
  for(PVector v : ret) {
    v.sub(50, 70);
    v.mult(1. / 140);
  }
  
  return ret;
}
PVector[] mousePointerCoords = initMousePointerCoords();

// Pakka pointtereita origoon, count kpl, paksuus 2r
void mousePointers(float size, int count, float r) {
  pushStyle();
  noStroke();
  for(int i = 0; i < count; ++i) {
    pushMatrix();
    if(i % 3 == 0) {
      fill(255, 255, 255);
    } else if(i % 3 == 1) { 
      fill(0, 255, 255);
    } else {
      fill(255, 0, 0);
    }
    translate(0, 0, 2 * r * ((float)i / Math.max(1.0, (float)count - 1.0) - 0.5));
    scale(size);
    beginShape();
    for(PVector v : mousePointerCoords) {
      vertex(v.x, v.y);
    }
    endShape();
    popMatrix();
  }
  popStyle();
}

// 3D-pointteri origoon, paksuus 2r
void mousePointer3D(float size, float r) {
  pushStyle();
  noStroke();
  
  // Pohjat
  fill(255, 255, 255);
  for(int i = -1; i <= 1; i += 2) {
    pushMatrix();
    translate(0, 0, r * i);
    scale(size);
    beginShape();
    for(PVector v : mousePointerCoords) {
      vertex(v.x, v.y);
    }
    endShape();
    popMatrix();
  }
  
  // Laidat
  pushMatrix();
  scale(size);
  PVector prev = mousePointerCoords[mousePointerCoords.length - 1];
  int idx = 0;
  for(PVector cur : mousePointerCoords) {
    if(idx % 2 == 0) {
      fill(0, 255, 255);
    } else {
      fill(255, 0, 0);
    }
    beginShape();
    float u = r / Math.max(size, 1.0);
    vertex(prev.x, prev.y, u);
    vertex(cur.x, cur.y, u);
    vertex(cur.x, cur.y, -u);
    vertex(prev.x, prev.y, -u);
    endShape();
    prev = cur;
    ++idx;
  }
  popMatrix();
  
  popStyle();
}

void flyingPointerEffect() {
  float movement = (float)moonlander.getValue("flyingPointerMovement");
  float depth = (float)moonlander.getValue("flyingPointerDepth");
  float size = (float)moonlander.getValue("flyingPointerSize");
  int type = moonlander.getIntValue("flyingPointerType");
  float light = (float)moonlander.getValue("flyingPointerLightIntensity");
  float count = (float)moonlander.getValue("flyingPointerCount");
  float blowup = (float)moonlander.getValue("flyingPointerBlowUp");
  float t = 0.2 * (float)moonlander.getCurrentTime();
  
  pointLight(255 * light, 255 * light, 255 * light, -1000, -1000, 0);
  ambientLight(255 * (1 - light), 255 * (1 - light), 255 * (1 - light));
  
  for(int i = 1; i <= Math.ceil(count); ++i) {
    float t2 = t - 100 * i;
    pushMatrix();
    scale(blowup);
    float x = movement * 600;
    translate(2 * x * (noise(t2, 0) - 0.5), 2 * x * (noise(t2, 1) - 0.5), 2 * x * (noise(t2, 2) - 0.5));
    float y = movement * 5;
    rotateY(y * noise(t2, 3));
    rotateX(y * noise(t2, 4));
    rotateZ(y * noise(t2, 4));
    float d = depth * 0.5 * (1 - cos(2 * (float)Math.PI * (0.375 + 0.125 * (float)moonlander.getCurrentRow())));
    float coef = 1;
    if((float)i > count) {
      coef = (1 - ((float)i - count));
    }
    if(type == 0) {
      mousePointers(coef * size, 7, coef * d);
    } else {
      mousePointer3D(coef * size, coef * d);
    }
    popMatrix();
  }
}

void creditsEffect() {
  // TODO: koodaa creditsit
  rect(0, 0, 100, 100);
}

void draw() {  
  moonlander.update();
  
  camera(0, 0, 1000, 0, 0, 0, 0, 1, 0);
  background(0);
  
  int effect = moonlander.getIntValue("effect");
  if(effect == 0) flyingPointerEffect();
  if(effect == 1) creditsEffect();
}
