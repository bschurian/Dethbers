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
  for (int y = 0; y < data.height/2; y++) {
    float origIm = downBound + (float(y)/data.height) * abs(upBound - downBound); //<>//
    for (int x = 0; x < data.width; x++) {
      float origRe = leftBound + (float(x)/data.width) * abs(leftBound - rightBound);
      float re = origRe;
      float im = origIm;
      boolean diverged = false; //<>//
      for(int i = 1; i <= maxIters; i++){
        float tempRe = re*re - im*im;
        float tempIm = 2.0*re*im;
        re = tempRe + origRe;
        im = tempIm + origIm;
        if(re + im > thresh){
          print(" "+re+" "+im+"!");
          diverged = true;
          float grey = (float(i)/maxIters)*255;
          data.pixels[y*data.width+x] = color(1); 
          break;
        }
      }
      if(!diverged){
        data.pixels[y*data.width+x] = color(0,1,0);
      }
      print(data.pixels[y*data.width+x]);
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
