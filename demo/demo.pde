import moonlander.library.*;
import ddf.minim.*;

Moonlander moonlander;

color fuchsia = color(254,127,250);
color teal = color(123,241,246);
color paleBlue = color(160,191,239);

void settings() {
  size(640, 360, P3D);
//  fullScreen(P3D);
} 

PImage hourglass;
PGraphics graphics[];

String name = "dangling pointer.";

String space = "                                                                  ";
String credits =
  "Music: 'Rhinoceros' by Kevin MacLeod (CC BY 3.0) " + space +
  "Greetings to: all fuksipallerot and n:th year students of Gurula " + space +
//  "Fuckings to: Alepa Otaniemi for not having PowerKing!" + space +
  "Team Gurula";

void setup() {
  moonlander = Moonlander.initWithSoundtrack(this, "Rhinoceros-clip.mp3", 126, 8);
  moonlander.start();
  frameRate(60);
  noiseSeed(1337);
  
  hourglass = loadImage("hourglass.png");
  graphics = new PGraphics[6];
  for(int i = 0; i < 6; ++i) {
    graphics[i] = createGraphics(100, 100);
  }
  
  noCursor();
}

PVector[] initMousePointerCoords() {
  PVector[] ret = {
    new PVector(0, 0),
    new PVector(100, 105),
    new PVector(55, 105),
    new PVector(72, 145),
    new PVector(52, 155),
    new PVector(34, 113),
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
      fill(teal);
    } else {
      fill(fuchsia);
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
  fill(220, 220, 220);
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
    float darken = 0.8;
    if(idx % 2 == 0) {
      fill(red(teal)*darken,green(teal)*darken,blue(teal)*darken);
    } else {
      fill(red(fuchsia)*darken,green(fuchsia)*darken,blue(fuchsia)*darken);
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
  
  pointLight(255 * light, 255 * light, 255 * light, -1000, -1000, 1000);
  ambientLight(255 * (1 - light), 255 * (1 - light), 255 * (1 - light));
  
  for(int i = 1; i <= Math.ceil(count); ++i) {
    float t2 = t - 100 * i;
    pushMatrix();
    float x = movement * 600;
    translate(2 * x * (noise(t2, 0) - 0.5), 2 * x * (noise(t2, 1) - 0.5), 2 * x * (noise(t2, 2) - 0.5));
    translate(0, 0, blowup);
    float y = movement * 5;
    rotateY(y * noise(t2, 3));
    rotateX(y * noise(t2, 4));
    rotateZ(y * noise(t2, 4));
    float d = depth * 0.5 * (1 - cos(2 * (float)Math.PI * (0.125 * (float)moonlander.getCurrentRow())));
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

void boxTunnelEffect() {
  pushStyle();
  pushMatrix();
  
  noStroke();
  
  float time = (float)moonlander.getCurrentTime();
  float beat = (float)moonlander.getCurrentRow() / 8 + 0.9;
  
  float light_r = 0.5;
  float light_g = 0.1;
  float light_b = 1.0;
  
  float ambient = 0.8;
  ambientLight(255 * (1 - ambient), 255 * (1 - ambient), 255 * (1 - ambient));
  
  lightFalloff(1, 0, 0.00001);
  
  float light_beet = beat % 6;
  
  pointLight(red(teal), green(teal), blue(teal), 0, 0, 2000 - 80 * light_beet * light_beet);
  
  light_beet = (beat + 3) % 6;
  pointLight(red(teal), green(teal), blue(teal), 0, 0, 2000 - 80 * light_beet * light_beet);
  
  float fadeout = (float) moonlander.getValue("tunnel_out") * 60;
  
  background(0);
  
  float diameter = 270;
  float jaggyness = 100;
  float boxes_per_ring = 15;
  float boxsize = PI * diameter / boxes_per_ring;
  float depth = 100; 
  
  float zStart = 1200;
  //float zEnd = zStart - boxsize * depth;
  
  //translate(0, 0, -time*100);
  
  float tunnel_spiral = (float) moonlander.getValue("tunnel_spiral");
    
  for (float d = 0; d < depth; ++d) {
    
    float pulse = pow((1.0 + sin(beat*2 + 6*PI * d / 100)) / 2, 1.5); 
    
    rotateZ(2*PI * noise(d) / 100.0);
    
    float ring_z = zStart + -d * boxsize;
    
    for (float i = 0; i < boxes_per_ring; ++i) {
      pushMatrix(); 
      
      rotateZ(2*PI / 10 * noise(d, time));
     
      translate(0, 0, ring_z);
      rotateZ(2*PI / boxes_per_ring * i);
      
      float c = noise(d / depth * 4 + time, 0.5 - i / boxes_per_ring); 
      //c = (1+c)/2;
      float mdist = ((i + d + floor(time*5)) % boxes_per_ring);
      mdist = min(mdist, boxes_per_ring - mdist);
      
      if (tunnel_spiral * 100 > d && mdist < 3) {
        float n = noise(d / depth + 0.1 * mdist);
        fill(red(fuchsia) * n, green(fuchsia) * n, blue(fuchsia) * n);
      } else
        fill(255*c, 255*c, 255*c);
  
      float box_d = diameter + jaggyness / 2 - jaggyness * noise(i+d  +time);
      
      box_d -= pulse * diameter / 3; // (diameter / map(ring_z, zStart, zEnd, 4, 1));
     
      translate(0, box_d/2 * (fadeout / 100 * (d+2) + 1), noise(d/depth) * 30);
      
      box(PI * box_d / boxes_per_ring);
      //box(boxsize);
      
      popMatrix();
    }
  }
  
  popMatrix();
  popStyle();
  
  pushMatrix();
  pushStyle();
  
  float tunnel_cursor = (float) moonlander.getValue("tunnel_cursor");
  if (tunnel_cursor > 0) {
    translate(0,0,910 - 2000 * tunnel_cursor);
    rotateX(PI/2 - PI/24);
    rotateY(-PI/12);
    
    rotateY(tunnel_cursor * 2*PI * 5);
    translate(0, 0, 50);
    mousePointer3D(60,5);
  }
  
  popMatrix();
  popStyle();
}

static float cubicPulse( float c, float w, float x ){
  x = abs(x - c);
  if( x>w ) return 0.0;
  x /= w;
  return 1.0 - x*x*(3.0-2.0*x);
}

static float planeDist(PVector a, PVector b, PVector c, PVector p) {
  PVector normal = PVector.sub(b, a).cross(PVector.sub(c, a));
  normal.normalize();
  PVector d = PVector.sub(p, a);
  return d.dot(normal);
}

void cubeEffect() {
  pushStyle();
  pushMatrix();
  
  directionalLight(255, 255, 255, 1, 1, -1);
  ambientLight(200, 200, 200);
  
  float content = (float)moonlander.getValue("cubeContent");
  float arrowSize = (float)moonlander.getValue("cubeArrowSize");
  float arrowBling = (float)moonlander.getValue("cubeArrowBling");
  float plasmaCoef = (float)moonlander.getValue("cubePlasmaCoef");
  
  float t = (float)moonlander.getCurrentTime();
  rotateX(t);
  rotateY(1.3 * t);
  
  boolean[] visible = new boolean[6];
  for(int i = 0; i < 6; ++i) {
    pushMatrix();
    if(i == 1) rotateX(0.5 * (float)Math.PI);
    if(i == 2) rotateX((float)Math.PI);
    if(i == 3) rotateX(-0.5 * (float)Math.PI);
    if(i == 4) rotateY(0.5 * (float)Math.PI);
    if(i == 5) rotateY(-0.5 * (float)Math.PI);
    if(screenZ(0, 0, 0) > screenZ(0, 0, 1)) visible[i] = true;
    popMatrix();
  }
  
  float meas = (float)moonlander.getCurrentRow() / 8 + 0.5;
  float measInt = (float)Math.floor(meas);
  float measFrac = meas - measInt;
  
  if(content < 1) {
    for(int i = 0; i < 6; ++i) {
      PGraphics g = graphics[i];
      g.beginDraw();
      g.background(100 * (1 + Math.min(content, 0)));
      g.imageMode(CENTER);
      g.translate(0.5 * g.width, 0.5 * g.height);
      g.rotate(0.5 * (float)Math.PI * (measInt + measFrac * measFrac * (3 - 2 * measFrac)));
      g.image(hourglass, 0, 0, 0.4 * g.width, 0.4 * g.width);
      g.endDraw();
    }
  }
  
  if(content > 0) {
    PVector[][] polygons = new PVector[5][];
    int[][][] triangulation = {
      {{0, 1}, {5, 6}, {6, 0}},
      {{0, 1}, {1, 2}, {6, 0}},
      {{0, 1}, {6, 0}, {2, 3}, {3, 4}, {4, 5}}
    };
    if(arrowSize > 0) {
      for(int polyi = 0; polyi < polygons.length; ++polyi) {
        PVector axis = new PVector(noise(polyi, 2.1, 0.5) - 0.5, noise(polyi, 13.2, 0.5) - 0.5, noise(polyi, -5.7, 0.5) - 0.5);
        axis.normalize();
        
        PVector rot1 = axis.cross(new PVector(1, 0, 0));
        rot1.normalize();
        PVector rot2 = axis.cross(rot1);
        rot2.normalize();
        
        float myt = 2 * t * noise(polyi, 1.18);
        
        PVector base = PVector.add(PVector.mult(rot1, cos(myt)), PVector.mult(rot2, sin(myt)));
        base = PVector.add(base, PVector.mult(axis, noise(polyi, 0.4)));
        base.normalize();
        
        PVector[] poly = new PVector[mousePointerCoords.length];
        polygons[polyi] = poly;
        PVector e1 = base.cross(new PVector(1, 0, 0));
        e1.setMag(arrowSize);
        PVector e2 = base.cross(e1);
        e2.setMag(arrowSize);
        for(int i = 0; i < poly.length; ++i) {
          poly[i] = PVector.add(base, PVector.add(PVector.mult(e1, mousePointerCoords[i].x), PVector.mult(e2, mousePointerCoords[i].y)));
          poly[i].normalize();
        }
      }
    }
    
    t *= 0.6;
    for(int i = 0; i < 6; ++i) {
      PGraphics g = graphics[i];
      g.beginDraw();
      if(visible[i]) {
        g.loadPixels();
        for(int x = 0; x < g.width; ++x) {
          for(int y = 0; y < g.height; ++y) {
            float A = (float)x / (float)g.width;
            float B = (float)y / (float)g.width;
            
            float u, v, w;
            u = A;
            v = B;
            w = 0;
            if(i == 1) {
              u = A;
              v = 0;
              w = 1 - B;
            }
            if(i == 2) {
              u = A;
              v = 1 - B;
              w = 1;
            }
            if(i == 3) {
              u = A;
              v = 1;
              w = B;
            }
            if(i == 4) {
              u = 1;
              v = B;
              w = A;
            }
            if(i == 5) {
              u = 0;
              v = B;
              w = 1 - A;
            }
            
            PVector spherePos = new PVector(u - 0.5, v - 0.5, w - 0.5);
            spherePos.normalize();
            
            float t2 = 0.5 * (t - 37) + 37;
            float h = 0.41 * cos(1.35 * u + 1.54 * v - 0.39 * w - 1.21 * t2) - 0.75 * sin(1.53 * u + 1.15 * v + 0.37 * w + 1.51 * t2) - 0.32 * cos(-0.75 * u + v + w + 3.5 * t2) + 0.72 * t2;
            
            h *= 10; 
            float val = h - floor(h);
            val = cubicPulse(0.5, 0.2, val);
            val *= plasmaCoef;
            
            PVector origin = new PVector(0, 0, 0);
            
            if(arrowSize > 0) {
              float dist = -1;
              for(int polyi = 0; polyi < polygons.length; ++polyi) {
                if(polygons[polyi][0].dot(spherePos) < 0) continue;
                for(int trg = 0; trg < triangulation.length; ++trg) {
                  float mydist = 1;
                  for(int pair = 0; pair < triangulation[trg].length; ++pair) {
                    int i0 = triangulation[trg][pair][0];
                    int i1 = triangulation[trg][pair][1];
                    PVector p0 = polygons[polyi][i0];
                    PVector p1 = polygons[polyi][i1];
                    
                    mydist = Math.min(mydist, planeDist(origin, p0, p1, spherePos));
                    if(mydist < -0.1) break;
                  }
                  dist = Math.max(dist, mydist);
                }
              }
              
              dist /= Math.max(plasmaCoef, 0.4);
              if(dist > -0.1) {
                if(dist < 0) {
                  if(dist > -0.05) {
                    val = 1 - Math.abs(dist + 0.05) / 0.05;
                  } else {
                    val = Math.max(val, 1 - Math.abs(dist + 0.05) / 0.05);
                  }
                  val *= Math.min(plasmaCoef * 7, 1);
                } else {
                  val = Math.min(1 + (dist - (0.1 + 0.05 * sin(2 * (float)Math.PI * meas))) / 0.05, 1);
                  val *= arrowBling * plasmaCoef;
                }
              }
            }
            
            color c = hsvToRgb(hue(fuchsia)/255, saturation(fuchsia)/255, val);;
            if(content == 1) {
              g.pixels[x + y * g.width] = c;
            } else {
              g.pixels[x + y * g.width] = alphaBlend(c, g.pixels[x + y * g.width], content);
            }
          }
        }
        g.updatePixels();
      }
      g.endDraw();
    }
  }
  
  imageMode(CENTER);
  
  for(int i = 0; i < 6; ++i) {
    pushMatrix();
    if(i == 1) rotateX(0.5 * (float)Math.PI);
    if(i == 2) rotateX((float)Math.PI);
    if(i == 3) rotateX(-0.5 * (float)Math.PI);
    if(i == 4) rotateY(0.5 * (float)Math.PI);
    if(i == 5) rotateY(-0.5 * (float)Math.PI);
    translate(0, 0, 285);
    image(graphics[i], 0, 0, 570, 570);
    popMatrix();
  }
  
  popMatrix();
  popStyle();
}

color hsvToRgb(double h, double s, double v) {
    int i = (int)(h * 6);
    double f = h * 6 - i;
    double p = v * (1.0 - s);
    double q = v * (1.0 - f * s);
    double t = v * (1.0 - (1.0 - f) * s);

    double r = 0.0, g = 0.0, b = 0.0;
    switch (i % 6) {
        case 0: r = v; g = t; b = p; break;
        case 1: r = q; g = v; b = p; break;
        case 2: r = p; g = v; b = t; break;
        case 3: r = p; g = q; b = v; break;
        case 4: r = t; g = p; b = v; break;
        case 5: r = v; g = p; b = q; break;
    }
    return color(Math.round(r * 255), Math.round(g * 255), Math.round(b * 255));
}

PImage colorWheel(int w, int h) {
  PImage img = createImage(w, h, RGB);
  img.loadPixels();
  int midX = img.width / 2;
  int midY = img.height / 2;

  int radius = midX;
  int halfRadius = radius / 2;

  for (int y = 0; y < img.height; y++) {
      for (int x = 0; x < img.width; x++) {
          double d = Math.sqrt(Math.pow((double)(x - midX), 2.0) + Math.pow((double)(y - midY), 2.0));
          if (d > radius) {
              img.pixels[y * img.width + x] = color(0, 0, 0);
              continue;
          }

          int dx = x - midX;
          int dy = y - midY;
          double normAngle = (atan2(dx, dy) - Math.PI) / (-2.0 * Math.PI);

          double saturation = d < halfRadius ? d / halfRadius : 1.0;
          double value = d < halfRadius ? 1.0 : (radius - d) / halfRadius;
          img.pixels[y * img.width + x] = hsvToRgb(normAngle, saturation, value);
      }
  }
  img.updatePixels();
  return img;
}

PImage waterWith(PImage img, PImage other, int lrAmount, int udAmount) {
  PImage newImg = createImage(img.width, img.height, RGB);

  img.loadPixels();
  other.loadPixels();

  for (int y = 0; y < img.height; y++) {
    for (int x = 0; x < img.width; x++) {
      color col = other.pixels[y * img.width + x];
      double diff = Math.max(Math.max(red(col), green(col)), blue(col));

      int nx = (int)Math.round((1.0 + diff / 255.0) * lrAmount + x) % img.width;
      if (nx < 0)
        nx += img.width;
      int ny = (int)Math.round((1.0 + diff / 255.0) * udAmount + y) % img.height;
      if (ny < 0)
        ny += img.height;
      newImg.pixels[y * img.width + x] = img.pixels[ny * img.width + nx];
    }
  }
  newImg.updatePixels();
  return newImg;
}

PImage sineWaveBoth(PImage img, int peaksUD, int h, int peaksLR, int w) {
  PImage newImg = createImage(img.width, img.height, RGB);
  img.loadPixels();

  double kUD = peaksUD * PI;
  double kLR = peaksLR * PI;

  for (int y = 0; y < img.height; y++) {
    for (int x = 0; x < img.width; x++) {
      double dx = Math.sin(((double)y / img.height) * kLR) * w;
      int x2 = (int)Math.floor((x + dx) % img.width);
      if (x2 < 0)
        x2 += img.width;

      double dy = Math.sin(((double)x / img.width) * kUD) * h;
      int y2 = (int)Math.floor((y + dy) % img.height);
      if (y2 < 0)
        y2 += img.height;

      newImg.pixels[y * img.width + x] = img.pixels[y2 * img.width + x2];
    }
  }
  newImg.updatePixels();
  return newImg;
}

int clamp255(int v) {
  if (v < 0) return 0;
  if (v > 255) return 255;
  return v;
}

PImage convolute(PImage img, int[] matrix, int divisor) {
  PImage newImg = createImage(img.width, img.height, RGB);
  img.loadPixels();

  int[] DX = new int[] {-1,  0,  1, -1, 0, 1, -1, 0, 1};
  int[] DY = new int[] {-1, -1, -1,  0, 0, 0,  1, 1, 1};

  for (int y = 0; y < img.height; y++) {
      for (int x = 0; x < img.width; x++) {

          int[] comps = new int[3];
          for (int i = 0; i < DX.length; i++) {
              int rx = x + DX[i];
              if (rx < 0)
                rx = 0;
              else if (rx >= img.width)
                rx = img.width - 1;
              int ry = y + DY[i];
              if (ry < 0)
                ry = 0;
              else if (ry >= img.height)
                ry = img.height - 1;

              color px = img.pixels[img.width * ry + rx];
              comps[0] += red(px) * matrix[i];
              comps[1] += green(px) * matrix[i];
              comps[2] += blue(px) * matrix[i];

          }
          newImg.pixels[y * img.width + x] = color(
            clamp255(comps[0] / divisor),
            clamp255(comps[1] / divisor),
            clamp255(comps[2] / divisor));
      }
  }
  return newImg;
}

PImage blur(PImage img) {
    return convolute(img, new int[] { 3, 3, 3,
                                      3, 8, 3,
                                      3, 3, 3 }, 32);
}

PImage softenLess(PImage img) {
    return convolute(img, new int[] { 0, 1, 0,
                                      1, 2, 1,
                                      0, 1, 0 }, 6);
}

PImage findEdges(PImage img) {
    return convolute(img, new int[] { 1, 1, 1,
                                      1,-2, 1,
                                     -1,-1,-1 }, 1);
}

color alphaBlend(color c1, color c2, float alpha) {
  return color(
    int(red(c1) * alpha + red(c2) * (1.0 - alpha)),
    int(green(c1) * alpha + green(c2) * (1.0 - alpha)),
    int(blue(c1) * alpha + blue(c2) * (1.0 - alpha))
  );
}

void drawTiled(PImage img) {
  int yCount = height / img.height + 1;
  int xCount = width / img.width + 1;
  for (int y = 0; y < yCount; y++) {
      for (int x = 0; x < xCount; x++) {
        image(img, x * img.width, y * img.height, img.width, img.height);
      }
  }
}

PImage blurredText;

void titleText() {
  if (blurredText == null) {
    PGraphics graphics = createGraphics(width, height);
    graphics.beginDraw();
    graphics.background(0);
    graphics.fill(255);
    graphics.textAlign(CENTER, TOP);

    String str1 = "Graffathon";
    String str2 = "Graffathon 2018";

    int ts = 369;
    for (int i = 0; i < 10; i++, ts--) {
      graphics.textSize(ts);
      if (graphics.textWidth(str1) < graphics.width)
        break;
    }
    graphics.textSize(ts);

    graphics.text(str2, 0, 0, graphics.width, graphics.height);
    graphics.endDraw();

    blurredText = blur(blur(graphics));
  }

  float textAlpha = (float)moonlander.getValue("titleTextAlpha");

  loadPixels();
  for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        color blurredPx = blurredText.pixels[blurredText.width * y + x];
        if (red(blurredPx) == 0 && green(blurredPx) == 0 && blue(blurredPx) == 0)
          continue;
        pixels[blurredText.width * y + x] = alphaBlend(blurredPx, pixels[blurredText.width * y + x], textAlpha);
      }
  }
  updatePixels();
}

void dezgegEffect() {
  resetMatrix();
  ortho();
  translate(-width / 2, -height / 2);
  int wh = Math.min(width, height) / 4;
  PImage img = colorWheel(wh, wh);

  int swWidth = (int)(moonlander.getValue("colorEffectSineWaveWidth") * wh);
  int swHeight = (int)(moonlander.getValue("colorEffectSineWaveHeight") * wh);
  img = sineWaveBoth(img, 2, swHeight, 2, swWidth);
  int waterLR = (int)(moonlander.getValue("colorEffectWaterLR") * wh);
  int waterUD = (int)(moonlander.getValue("colorEffectWaterUD") * wh);
  img = waterWith(img, img, waterLR, waterUD);

  drawTiled(img);
  //titleText();
}

void doFade(float amount) {
  //loadPixels();
  //for (int y = 0; y < height; y++) {
  //    for (int x = 0; x < width; x++) {
  //      color c = pixels[y * width + x];
  //      pixels[y * width + x] = color(amount * red(c), amount * green(c), amount * blue(c));
  //    }
  //}
  //updatePixels();
}

void wavesEffect() {
  pushStyle();
  pushMatrix();
  
  noStroke();
  
  float fadein = (float)moonlander.getValue("waves_fadein");
  int zoom = moonlander.getIntValue("waves_zoom");
  
  float light_r = 0.5;
  float light_g = 0.1;
  float light_b = 1.0;
  
  float ambient = 0.8;
  ambientLight(255 * (1 - ambient), 255 * (1 - ambient), 255 * (1 - ambient));
  
  lightFalloff(1, 0, 0.00001 / zoom);
 
  translate(0, 0, zoom);
 
  pointLight(red(teal), green(teal), blue(teal), 0.0, 0.0, 200.0);
  
  float time = (float)moonlander.getCurrentTime();
  float beat = (float)moonlander.getCurrentRow();
  
  float boxSize = 30;
  
  float pulse = pow(((1 + sin(beat)) / 2), 2);
  
  for (int x = -40; x < 40; ++x) {
    for (int y = -30; y < 30; ++y) {
      pushMatrix();
      
      float z_wave = pow((1 + sin(sqrt(x*x + y*y) + beat/2)) / 2, 4);
      
      translate(x * boxSize, y * boxSize, noise(x, y, time)*20 + z_wave * 30);
      
      translate(-x * boxSize * (zoom - 1)/1000, -y * boxSize * (zoom - 1)/1000, -pow((zoom - 1)/sqrt(x*x + y*y),1.2) );
      
      box(fadein* boxSize * 2* (1 - 2* noise(x+40,y+30)));
      
      popMatrix();
    }
  }
  
   popMatrix();
   popStyle();
}

void puu(float x, float y, float dist, float d) {
  if(d > 4) return;
  
  float time = (float)moonlander.getCurrentTime();
  
  if (noise(x,y,d) < 0.10 * d && d > 2.5) return;
  
  float p = -20 / d;
 
  line(0,0,0,0,p,0);
  translate(0,p,0);
  
  for (int i = 0; i < 3; ++i) {
    
    float n = 0.5 - noise(x, y, time/5 + float(i) / 3 + d);
    n *= 2;
    
    rotateZ(2*PI / 6 * (-1 + i) + n);
    
    puu(x,y,dist, d+1);
    
    rotateZ(-2*PI / 6 * (-1 + i) - n);
    
  }
  
  translate(0,-p,0);
}

void treeEffect() {
  pushStyle();
  pushMatrix();
  
  float curParam = (float)moonlander.getValue("treeCursorParam");
  float curParam2 = curParam * curParam;
  
  textSize(100);
  float fadeout = Math.min(Math.min(map(curParam, 0.9, 1, 1, 0), map(curParam, 0.0, 0.004, 0, 1)), 1);
  fill(255 * fadeout);
  text(credits, 900 - (textWidth(credits) + 700) * curParam, -300);
  
  rotateX(-10.0 / 360 * 2 * PI);
  
  pushMatrix();
  translate(0, -100, 950 - 2500 * curParam2);
  rotateX((1 - curParam2) * 0.5 * (float)Math.PI);
  rotateZ((1 - curParam2 * curParam2) * 0.35);
  mousePointer3D(50, 5);
  popMatrix();
  
  float time = (float)moonlander.getCurrentTime();
  translate(0,-100,500 + time*100);
  
  float jd = 2 * time;
  float j1 = -10 - jd;
  float j2 = 10 - jd;
  
  for (int i = -7; i <= 7; ++i) {
    for (int j = (int)j1; j < (int)j2; ++j) {
      if(i >= -1 && i <= 1) {
        continue;
      }
      
      float nx = noise(i, j) - 0.5;
      float nz = noise(j, i);
      
      float dx = 50*(i + nx);
      float dz = 50*(j + nz);
      
      translate(dx, 0, dz);
      if (j % 2 == 0) stroke(hsvToRgb(hue(fuchsia)/255, saturation(fuchsia)/255, map(j, j1, j2, 0, 1) * fadeout));
      if (j % 2 != 0) stroke(hsvToRgb(hue(teal)/255, saturation(teal)/255, map(j, j1, j2, 0, 1) * fadeout));
      if (j % 3 == 0) stroke(hsvToRgb(hue(paleBlue)/255, saturation(paleBlue)/255, map(j, j1, j2, 0, 1) * fadeout));
      strokeWeight(height / 240);
      puu(i,j,dz,1);    
      translate(-dx, 0, -dz);
    }
  }
  
  popMatrix();
  popStyle();
}

void namedropEffect() {
  pushStyle();
  pushMatrix();
  
  fill(255);
  textSize(100);
  text(name, -600, -200, 0);
  
  float factor = (float)moonlander.getValue("dangle_factor");
  
  translate(215, -150, 0);
  
  
  rotateZ(sin(2*PI* factor * 3));
  translate(0, 200, 0);
  
  rotateZ(sin(2*PI / 12));
  mousePointer3D(70, 1);
  
  popMatrix();
  popStyle();
}

boolean firstFrame = true;

void draw() {  
  moonlander.update();
  
  float fov = PI/3.0;
  float cameraZ = (height/2.0) / tan(fov/2.0);
  perspective(fov, float(width)/float(height), 
              cameraZ/100.0, cameraZ*10.0);
  
  camera(0, 0, 1000, 0, 0, 0, 0, 1, 0);
  background(0);
  
  if(firstFrame) {
    textSize(100);
    textWidth(name);
    textWidth(credits);
    firstFrame = false;
  }

  int effect = moonlander.getIntValue("effect");

  if(effect == 0) flyingPointerEffect();
  if(effect == 1) dezgegEffect();
  if(effect == 9) namedropEffect();
  if(effect == 2) cubeEffect();
  if(effect == 3) wavesEffect();
  if(effect == 4) boxTunnelEffect();
  if(effect == 5) treeEffect();
  float fade = (float)moonlander.getValue("fade");
  if (fade < 1.0)
    doFade(fade);
}
