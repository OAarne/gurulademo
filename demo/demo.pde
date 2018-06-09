import moonlander.library.*;
import ddf.minim.*;
import java.util.logging.*;

Moonlander moonlander;

void settings() {
  size(640, 480, P3D);
}

void setup() {
  moonlander = Moonlander.initWithSoundtrack(this, "tekno_127bpm.mp3", 127, 8);
  moonlander.start("localhost", 9001, "syncdata.rocket");
  frameRate(60);
  noiseSeed(123123);
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

void mousePointers(float size, int count, float d) {
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
    translate(0, 0, d * ((float)i / Math.max(1.0, (float)count - 1.0) - 0.5));
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

void flyingPointerEffect() {
  float flyingPointerMovement = (float)moonlander.getValue("flyingPointerMovement");
  float flyingPointerDepth = (float)moonlander.getValue("flyingPointerDepth");
  float flyingPointerSize = (float)moonlander.getValue("flyingPointerSize");
  float t = 0.2 * (float)moonlander.getCurrentTime();
  
  pushMatrix();
  float x = flyingPointerMovement * 300;
  translate(2 * x * (noise(t, 0) - 0.5), 2 * x * (noise(t, 1) - 0.5), 2 * x * (noise(t, 2) - 0.5));
  float y = flyingPointerMovement * 10;
  rotateY(y * noise(t, 3));
  rotateX(y * noise(t, 4));
  rotateZ(y * noise(t, 4));
  mousePointers(flyingPointerSize, 7, flyingPointerDepth * 0.5 * (1 - cos(2 * (float)Math.PI * (0.375 + 0.125 * (float)moonlander.getCurrentRow()))));
  popMatrix();
}

void draw() {  
  moonlander.update();
  
  translate(0.5 * width, 0.5 * height);
  scale(height / 1000.0);
  background(0);
  
  flyingPointerEffect();
}
