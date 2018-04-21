/**
 * Transparency. 
 * 
 * Move the pointer left and right across the image to change
 * its position. This program overlays one image over another 
 * by modifying the alpha value of the image with the tint() function. 
 */

PImage img;
float offset = 0;
float easing = 0.05;
float r = 50;

void setup() {
  size(640, 360);
  img = loadImage("moonwalk.jpg");  // Load an image into the program
  img.loadPixels();
  noStroke(); 
}

void draw() { 
  //for(int i = 0; i< img.height; i++){
  //  for (int j = 0; j< img.width; j++){
  //    img.pixels[i*j] = img.pixels[i*j+2 % img.pixels.length];
  //  }
  //}
  image(img, 0, 0);  // Display at full opacity
  float cycleOne = sin(millis()/1000.0)*(r/2);
  for(int yI = -1; yI < 2; yI++){
    for(int xI = -1; xI < 3; xI++){
      // 1 2     1 2
      //     3 4
      fill(img.get((int)(r*xI*6          ), (int)(r*4*yI    )));
      star(r*xI*6          , r*4*yI    ,  r, r+cycleOne, 6);
      fill(img.get((int)(r*xI*6+2*r      ), (int)(r*4*yI    )));
      star(r*xI*6+2*r      , r*4*yI    ,  r, r-cycleOne, 6);
      fill(img.get((int)(r*xI*6    +2*r+r), (int)(r*4*yI+r*2)));
      star(r*xI*6    +2*r+r, r*4*yI+r*2,  r, r+cycleOne, 6);
      fill(img.get((int)(r*xI*6+2*r+2*r+r), (int)(r*4*yI+r*2)));
      star(r*xI*6+2*r+2*r+r, r*4*yI+r*2,  r, r-cycleOne, 6);
    }
  }
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
