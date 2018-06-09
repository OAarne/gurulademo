import moonlander.library.*;
import ddf.minim.*;

Moonlander moonlander;

void settings() {
  size(640, 480, P3D);
}

PImage hourglass;

void setup() {
  moonlander = Moonlander.initWithSoundtrack(this, "tekno_127bpm.mp3", 127, 8);
  moonlander.start();
  frameRate(60);
  noiseSeed(1337);
  
  hourglass = loadImage("hourglass.png");
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
  pushStyle();
  pushMatrix();
  
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

void cubeEffect() {
  pushStyle();
  pushMatrix();
  
  directionalLight(255, 255, 255, 1, 1, -1);
  ambientLight(128, 128, 128);
  
  float t = (float)moonlander.getCurrentTime();
  rotateX(t);
  rotateY(1.3 * t);
  
  float meas = (float)moonlander.getCurrentRow() / 8;
  float measInt = (float)Math.floor(meas);
  float measFrac = meas - measInt;
  
  PGraphics graphics = createGraphics(1000, 1000);
  graphics.beginDraw();
  graphics.rectMode(RADIUS);
  graphics.background(100);
  graphics.imageMode(CENTER);
  graphics.translate(500, 500);
  graphics.rotate(0.5 * (float)Math.PI * (measInt + measFrac * measFrac * (3 - 2 * measFrac)));
  graphics.image(hourglass, 0, 0, 300, 300);
  graphics.endDraw();
  
  imageMode(CENTER);
  
  for(int i = 0; i < 6; ++i) {
    pushMatrix();
    if(i == 1) rotateX((float)Math.PI);
    if(i == 2) rotateX(0.5 * (float)Math.PI);
    if(i == 3) rotateX(-0.5 * (float)Math.PI);
    if(i == 4) rotateY(0.5 * (float)Math.PI);
    if(i == 5) rotateY(-0.5 * (float)Math.PI);
    translate(0, 0, 275);
    image(graphics, 0, 0, 550, 550);
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

void drawTiled(PImage img) {
  loadPixels();
  for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        pixels[y * width + x] = img.pixels[(y % img.height) * img.width + (x % img.width)];
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
}

void draw() {  
  moonlander.update();
  
  camera(0, 0, 1000, 0, 0, 0, 0, 1, 0);
  background(0);
  
  int effect = moonlander.getIntValue("effect");
  if(effect == 0) flyingPointerEffect();
  if(effect == 1) dezgegEffect();
  if(effect == 2) cubeEffect();
  if(effect == 3) creditsEffect();
}
