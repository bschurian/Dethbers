/**
 * Mandelbrot 
 * 
 */

protected int maxIters = 20;
protected int thresh = 4;
protected float rightBound = 1;
protected float leftBound = -2.5;
protected float upBound = 1;
protected float downBound = - 1;

PImage data;

void update() {
  
  data.loadPixels();
   
  for (int y = 0; y < data.height; y++) {
    float im = upBound - (float(y)/data.height) * abs(downBound - upBound);
    for (int x = 0; x < data.width; x++) {
      float re = leftBound + (float(x)/data.width) * abs(leftBound - rightBound);
      float z = 0;
      boolean diverged = false;
      for(int i = 1; i <= 10; i++){
        if(z > thresh){
          diverged = true;
          float gray = (float(i-1)/maxIters)*255;
          data.pixels[y*data.width+x] = color(gray);          
        }
        //TODO
        z = z*z + re*re + im*im*-1;
      }
      if(!diverged){
        data.pixels[y*data.width+x] = color(1,0,0);
      }
    }
  }  
  data.updatePixels();

}
void setup() {
  size(600, 400);
  data = new PImage(width, height);
}

void draw() {
  update();
  image(data, 0, 0);
  text(nf(frameRate, 2, 1) + " fps", 10, 30);
  text(width + "x" + height + " pixels", 10, 45);
}
