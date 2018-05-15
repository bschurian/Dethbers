/**
 * Transparency. 
 * 
 * Move the pointer left and right across the image to change
 * its position. This program overlays one image over another 
 * by modifying the alpha value of the image with the tint() function. 
 */

PImage img;
float offsetX = 0;
float offsetY = 0;
float r = 50;
float speed = 1.0/2.0;

void setup() {
  size(640, 360);
  img = loadImage("moonwalk.jpg");  // Load an image into the program
  img.loadPixels();
  noStroke(); 
}

void draw() { 
  image(img, 0, 0);
  float cycleOne = sin(millis()/1000.0)*(r/2);
  for(int yI = -3; yI < 2; yI++){
    for(int xI = -2; xI < 3; xI++){
      // 1 2     1 2
      //     3 4
      fill(img.get((int)(r*xI*6          +offsetX), (int)(r*4*yI    +offsetY)));
      star(r*xI*6          +offsetX, r*4*yI    +offsetY,  r, r+cycleOne, 6);
      
      fill(img.get((int)(r*xI*6+2*r      +offsetX), (int)(r*4*yI    +offsetY)));
      star(r*xI*6+2*r      +offsetX, r*4*yI    +offsetY,  r, r-cycleOne, 6);
      
      fill(img.get((int)(r*xI*6    +2*r+r+offsetX), (int)(r*4*yI+r*2+offsetY)));
      star(r*xI*6    +2*r+r+offsetX, r*4*yI+r*2+offsetY,  r, r+cycleOne, 6);
      
      fill(img.get((int)(r*xI*6+2*r+2*r+r+offsetX), (int)(r*4*yI+r*2+offsetY)));
      star(r*xI*6+2*r+2*r+r+offsetX, r*4*yI+r*2+offsetY,  r, r-cycleOne, 6);
    }
  }
  offsetX = 1.0*speed +(offsetX%(r*2*3));
  offsetY = 0.2*speed +(offsetY%(r*2*3));
}

void star(float x, float y, float fixR, float changR, int npoints) {
  float angle = TWO_PI / npoints;
  float halfAngle = angle/2.0;
  beginShape();
  for (float a = 0; a < TWO_PI; a += angle) {
    float sx = x + fixR + cos(a) * changR;
    float sy = y + fixR +sin(a) * changR;
    vertex(sx, sy);
    sx = x+ fixR + cos(a+halfAngle) * fixR;
    sy = y+ fixR + sin(a+halfAngle) * fixR;
    vertex(sx, sy);
  }
  endShape(CLOSE);
}
