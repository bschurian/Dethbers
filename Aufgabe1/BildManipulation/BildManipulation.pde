PImage img;

int rectScale;
int count;
int minWidth;
int maxWidth;

void setup() {
  size(300, 400);
  img = loadImage("me.jpg");
  img.loadPixels();
  image(img, 0, 0);

  count = 0;
  minWidth = 5;
  maxWidth = 50;
}

void draw() {
 
  float co = cos(0.02*count);
  rectScale = int(map(co, -1, 1, minWidth, maxWidth));

  for (int h=0; h<height; h += rectScale) {
    for (int w=0; w<width; w += rectScale) {
      color c = img.get(w, h);    
      fill(c);
      noStroke();
      //rectMode(CENTER);
      rect(w, h, rectScale, rectScale);
    }
  }
  count++;
  // saveFrame("output/picManip_####.png");
}
