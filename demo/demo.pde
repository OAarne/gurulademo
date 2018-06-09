import moonlander.library.*;
import ddf.minim.*;

Moonlander moonlander;

void settings() {
  size(640, 480, P3D);
}

PImage hourglass;

void setup() {
  moonlander = Moonlander.initWithSoundtrack(this, "Rhinoceros.mp3", 126, 8);
  moonlander.start();
  frameRate(60);
  noiseSeed(1337);
  
  hourglass = loadImage("hourglass.png");
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
  
  pointLight(255 * light, 255 * light, 255 * light, -1000, -1000, 1000);
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

void creditsEffect() {
  pushStyle();
  pushMatrix();
  
  background(0, 0, 0);
  
  float pos = (float)moonlander.getValue("creditsPos");
  translate(0, -pos);
  String text =
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec nec felis volutpat, suscipit mi sit amet, faucibus est. Praesent egestas lobortis erat a facilisis. Fusce finibus, tellus at placerat congue, velit nisi varius orci, quis porta augue turpis at augue. Sed mollis odio magna, ut semper nisl mattis at. Curabitur faucibus condimentum elit maximus interdum. Quisque at aliquet nisl. Curabitur vel faucibus eros, non egestas risus.\n\n" +
    "Suspendisse in molestie erat, eget elementum turpis. Nunc viverra vulputate mi, sed pulvinar justo iaculis a. Pellentesque viverra sapien risus, condimentum ornare elit condimentum eget. Proin venenatis turpis in lectus sollicitudin tristique. In ullamcorper id tortor sed blandit. Duis convallis bibendum nisi, ac mollis elit scelerisque ac. Fusce non pharetra arcu. Etiam sapien ante, vestibulum at magna id, ornare tincidunt lectus. Vivamus faucibus elementum est ut ultrices. Suspendisse at leo eu magna sollicitudin lobortis.\n\n" +
    "Sed sit amet viverra nibh. Aliquam finibus accumsan vulputate. Mauris vitae volutpat sapien, ac ultricies leo. Curabitur sit amet turpis vehicula, faucibus enim et, suscipit turpis. Curabitur ut eleifend mauris, scelerisque tempor nisl. Suspendisse imperdiet, justo eu ullamcorper elementum, augue neque laoreet justo, nec porta mi sem eget erat. Vestibulum vel nisi ut orci faucibus ullamcorper sagittis nec urna. Phasellus malesuada eros id libero commodo, et volutpat mi malesuada. Donec sagittis at libero et gravida. Phasellus quis libero quam. Ut purus ligula, euismod quis justo in, scelerisque facilisis quam. Praesent fermentum sapien ut rhoncus consectetur. Fusce maximus accumsan venenatis. Integer a urna vitae dui suscipit rhoncus ut at metus.\n\n" +
    "Mauris fermentum dui et ultrices fringilla. Vestibulum commodo lacinia lectus vel hendrerit. Curabitur hendrerit orci urna, vitae porta justo ultricies eu. Vestibulum iaculis vitae nunc id malesuada. Duis ligula mi, tincidunt a ligula quis, lacinia placerat dui. Morbi vestibulum lorem eget enim imperdiet, sed tempor nibh cursus. Cras elementum ipsum et lacus condimentum, quis finibus quam rutrum. Donec augue augue, egestas quis est in, facilisis tristique lacus. Praesent fringilla vulputate risus, ut rutrum arcu aliquam vitae. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Suspendisse malesuada tincidunt mollis. Nunc lacinia leo leo, non maximus est faucibus sed. Donec consequat purus eu ante egestas, sit amet ultricies metus venenatis.\n\n" +
    "Morbi aliquet ante vitae faucibus porta. In eleifend odio a purus efficitur, non molestie ipsum dictum. Mauris cursus justo at pellentesque suscipit. Phasellus sit amet orci at turpis luctus congue. Integer nec justo libero. Cras convallis odio a tortor eleifend finibus. Proin ac fermentum lorem, nec sollicitudin sem. Proin lacinia quis arcu vel vehicula. Aliquam erat volutpat.";
  
  fill(255);
  textSize(100);
  text(text, -700, 600, 1400, 1000000);
  
  popMatrix();
  popStyle();
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
  
  pointLight(255 * light_r, 255 * light_g, 255 * light_b, 0, 0, 2000 - 80 * light_beet * light_beet);
  
  light_beet = (beat + 3) % 6;
  pointLight(255 * light_r, 255 * light_g, 255 * light_b, 0, 0, 2000 - 80 * light_beet * light_beet);
  
  float fadeout = moonlander.getIntValue("tunnel_out");
  
  background(0);
  
  float diameter = 200;
  float jaggyness = 100;
  float boxes_per_ring = 15;
  float boxsize = PI * diameter / boxes_per_ring;
  float depth = 100; 
  
  float zStart = 1000;
  float zEnd = zStart - boxsize * depth;
  
  //translate(0, 0, -time*100);
    
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
      fill(255*c, 255*c, 255*c);
  
      float box_d = diameter + jaggyness / 2 - jaggyness * noise(i+d  +time);
      
      box_d -= pulse * diameter / 3; // (diameter / map(ring_z, zStart, zEnd, 4, 1));
     
      translate(0, box_d/2 * (fadeout / 100 * (d+2) + 1), 0);
      
      box(PI * box_d / boxes_per_ring);
      //box(boxsize);
      
      popMatrix();
    }
  }
  
  popMatrix();
  popStyle();
}

float cubicPulse( float c, float w, float x ){
  x = abs(x - c);
  if( x>w ) return 0.0;
  x /= w;
  return 1.0 - x*x*(3.0-2.0*x);
}

float planeDist(PVector a, PVector b, PVector c, PVector p) {
  PVector normal = PVector.sub(b, a).cross(PVector.sub(c, a));
  normal.normalize();
  PVector d = PVector.sub(p, a);
  return d.dot(normal);
}

boolean is2(int a, int b, int c, int d) {
  return (a == c && b == d) || (a == d && b == c);
}

void cubeEffect() {
  pushStyle();
  pushMatrix();
  
  directionalLight(255, 255, 255, 1, 1, -1);
  ambientLight(128, 128, 128);
  
  int content = moonlander.getIntValue("cubeContent");
  
  float t = (float)moonlander.getCurrentTime();
  rotateX(t);
  rotateY(1.3 * t);
  
  float meas = (float)moonlander.getCurrentRow() / 8;
  float measInt = (float)Math.floor(meas);
  float measFrac = meas - measInt;
  
  PGraphics graphics[] = new PGraphics[6];
  for(int i = 0; i < 6; ++i) {
    graphics[i] = createGraphics(100, 100);
  }
  
  if(content == 0) {
    for(int i = 0; i < 6; ++i) {
      PGraphics g = graphics[i];
      g.beginDraw();
      g.background(100);
      g.imageMode(CENTER);
      g.translate(0.5 * g.width, 0.5 * g.height);
      g.rotate(0.5 * (float)Math.PI * (measInt + measFrac * measFrac * (3 - 2 * measFrac)));
      g.image(hourglass, 0, 0, 0.4 * g.width, 0.4 * g.width);
      g.endDraw();
    }
  }
  
  if(content == 1) {
    PVector[][] polygons = new PVector[3][];
    int[][][] triangulation = {
      {{0, 1}, {5, 6}, {6, 0}},
      {{0, 1}, {1, 2}, {6, 0}},
      {{0, 1}, {6, 0}, {2, 3}, {3, 4}, {4, 5}}
    };
    for(int polyi = 0; polyi < polygons.length; ++polyi) {
      PVector axis = new PVector(noise(polyi, 0.1) - 0.5, noise(polyi, 0.2) - 0.5, noise(polyi, 0.3) - 0.5);
      axis.normalize();
      
      PVector rot1 = axis.cross(new PVector(1, 0, 0));
      rot1.normalize();
      PVector rot2 = axis.cross(rot1);
      rot2.normalize();
      
      float myt = 5 * t * noise(polyi, 0.5);
      
      PVector base = PVector.add(PVector.mult(rot1, cos(myt)), PVector.mult(rot2, sin(myt)));
      base = PVector.add(base, PVector.mult(axis, noise(polyi, 0.4)));
      base.normalize();
      
      PVector[] poly = new PVector[mousePointerCoords.length];
      polygons[polyi] = poly;
      PVector e1 = base.cross(new PVector(1, 0, 0));
      e1.normalize();
      PVector e2 = base.cross(e1);
      e2.normalize();
      for(int i = 0; i < poly.length; ++i) {
        poly[i] = PVector.add(base, PVector.add(PVector.mult(e1, mousePointerCoords[i].x), PVector.mult(e2, mousePointerCoords[i].y)));
        poly[i].normalize();
      }
    }
    
    t *= 0.6;
    for(int i = 0; i < 6; ++i) {
      PGraphics g = graphics[i];
      g.beginDraw();
      g.loadPixels();
      for(int x = 0; x < g.width; ++x) {
        for(int y = 0; y < g.height; ++y) {
          g.pixels[x + y * g.width] = #000000;
          
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
          
          float h = 0.4 * cos(1.3 * u + 1.5 * v - 0.3 * w + 1.2 * t) - 0.7 * sin(1.5 * u + 1.1 * v + 0.3 * w - 1.5 * t) + 0.3 * cos(-0.7 * u + v + w + 3 * t) + 0.7 * t;
          
          h *= 10;
          float val = h - floor(h);
          val = cubicPulse(0.5, 0.2, val);
          
          PVector origin = new PVector(0, 0, 0);
          
          float dist = -1;
          for(int polyi = 0; polyi < polygons.length; ++polyi) {
            for(int trg = 0; trg < triangulation.length; ++trg) {
              float mydist = 1;
              for(int pair = 0; pair < triangulation[trg].length; ++pair) {
                int i0 = triangulation[trg][pair][0];
                int i1 = triangulation[trg][pair][1];
                PVector p0 = polygons[polyi][i0];
                PVector p1 = polygons[polyi][i1];
                
                mydist = Math.min(mydist, planeDist(origin, p0, p1, spherePos));
              }
              dist = Math.max(dist, mydist);
            }
          }
          
          if(dist > -0.1) {
            if(dist < 0) {
              if(dist > -0.05) {
                val = 1 - Math.abs(dist + 0.05) / 0.05;
              } else {
                val = Math.max(val, 1 - Math.abs(dist + 0.05) / 0.05);
              }
            } else {
              val = 0;
            }
          }
          
          g.pixels[x + y * g.width] = hsvToRgb(0.1, 1.0, val);
        }
      }
      g.updatePixels();
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
    translate(0, 0, 275);
    image(graphics[i], 0, 0, 550, 550);
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

void drawTiled(PImage img) {
  img.loadPixels();
  loadPixels();
  for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        pixels[y * width + x] = img.pixels[(y % img.height) * img.width + (x % img.width)];
      }
  }
  updatePixels();
}

PImage blurredText;
PImage enhancedText;

void titleText() {
  if (blurredText == null) {
    PGraphics graphics = createGraphics(width, height);
    graphics.beginDraw();
    graphics.background(0);
    graphics.fill(255);
    graphics.textAlign(CENTER, TOP);

    int ts = 10;
    String str1 = "Graffathon";
    String str2 = "Graffathon 2018";
    for (int i = 0; i < 1000; i++, ts++) {
      graphics.textSize(ts);
      if (graphics.textWidth(str1) >= graphics.width)
        break;
    }
    graphics.textSize(ts - 1);

    graphics.text(str2, 0, 0, graphics.width, graphics.height);
    graphics.endDraw();

    blurredText = blur(blur(blur(graphics)));
    enhancedText = findEdges(softenLess(graphics));
  }

  loadPixels();
  for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        color blurredPx = blurredText.pixels[blurredText.width * y + x];
        if (red(blurredPx) == 0 && green(blurredPx) == 0 && blue(blurredPx) == 0)
          continue;
        pixels[blurredText.width * y + x] = blurredPx;
      }
  }
  updatePixels();
}

void dezgegEffect() {
  int wh = Math.min(width, height) / 4;
  PImage img = colorWheel(wh, wh);

  int swWidth = (int)(moonlander.getValue("colorEffectSineWaveWidth") * wh);
  int swHeight = (int)(moonlander.getValue("colorEffectSineWaveHeight") * wh);
  img = sineWaveBoth(img, 2, swHeight, 2, swWidth);
  int waterLR = (int)(moonlander.getValue("colorEffectWaterLR") * wh);
  int waterUD = (int)(moonlander.getValue("colorEffectWaterUD") * wh);
  img = waterWith(img, img, waterLR, waterUD);

  drawTiled(img);
  titleText();
}

void wavesEffect() {
  pushStyle();
  pushMatrix();
  
  noStroke();
  
  int zoom = moonlander.getIntValue("waves_zoom");
  
  float light_r = 0.5;
  float light_g = 0.1;
  float light_b = 1.0;
  
  float ambient = 0.8;
  ambientLight(255 * (1 - ambient), 255 * (1 - ambient), 255 * (1 - ambient));
  
  lightFalloff(1, 0, 0.00001 / zoom);
 
  translate(0, 0, zoom);
 
  pointLight(255 * light_r, 255 * light_g, 255 * light_b, 0.0, 0.0, 200.0);
  
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
      
      box(boxSize * 2* (1 - 2* noise(x+40,y+30)));
      
      popMatrix();
    }
  }
  
   popMatrix();
   popStyle();
}

void puu(float x, float y, float dist, float d) {
  
  float time = (float)moonlander.getCurrentTime();
  
  if (noise(x,y,d) < 0.10 * d) return;
  
  float p = -20 / d;
 
  stroke(255.0 / 500.0 * (500.0 + dist));
  line(0,0,0,0,p,0);
  translate(0,p,0);
  
  for (int i = 0; i < 3; ++i) {
    
    float n = 0.5 - noise(x, y, time/5 + float(i) / 3 + d);
    
    rotateZ(2*PI / 6 * (-1 + i) + n);
    
    puu(x,y,dist, d+1);
    
    rotateZ(-2*PI / 6 * (-1 + i) - n);
    
  }
  
  translate(0,-p,0);
}

void treeEffect() {
  pushStyle();
  pushMatrix();
  
  rotateX(-10.0 / 360 * 2 * PI);
  //translate(100, 1000, -3000;
  float time = (float)moonlander.getCurrentTime();
  translate(0,-100,500 + time*100);
  
  for (int i = -10; i < 10; ++i) {
    for (int j = -10; j < 20; ++j) {
      
      float nx = noise(i, j);
      float nz = noise(j, i);
      
      float dx = 50*(i + nx);
      float dz = 50*(j + nz);
      
      translate(dx, 0, dz);
      puu(i,j,dz,1);    
      translate(-dx, 0, -dz);
    }
  }
  
  
  
  popMatrix();
  popStyle();
}

void draw() {  
  moonlander.update();
  
  camera(0, 0, 1000, 0, 0, 0, 0, 1, 0);
  background(0);
 
  int effect = moonlander.getIntValue("effect");

  if(effect == 0) flyingPointerEffect();
  if(effect == 1) dezgegEffect();
  if(effect == 2) cubeEffect();
  if(effect == 3) wavesEffect();
  if(effect == 4) boxTunnelEffect();
  if(effect == 5) creditsEffect();
}
