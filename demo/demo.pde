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
}

void mousePointer() {
  beginShape();
  vertex(0, 0);
  vertex(100, 100);
  vertex(55, 100);
  vertex(75, 135);
  vertex(55, 145);
  vertex(35, 110);
  vertex(0, 140);
  endShape();
}

void draw() {  
  moonlander.update();
  float t = (float)moonlander.getValue("t");
  
  translate(0.5 * width, 0.5 * height);
  scale(height / 1000.0);
  background(0);
  
  float lol = 500.0 * (noise(t) - noise(0));
  translate(lol, lol, lol );
  rotateY(1.5 * t);
  rotateX(2.3 * t);
  mousePointer();
}
