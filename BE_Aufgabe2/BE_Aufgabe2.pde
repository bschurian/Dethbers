/**
 * Mandelbrot 
 * 
 */

<<<<<<< HEAD
protected int maxIters = 200;
protected int thresh = 10;
protected float rightBound = 1;
protected float leftBound = -2.5;
protected float upBound = 1;
protected float downBound = - 1;
=======
protected int maxIters = 100;
protected int thresh = 3;
protected int zoom = 1;
protected float rightBound =  1*zoom;
protected float leftBound  = -2*zoom;
protected float upBound    =  1*zoom;
protected float downBound  = -1*zoom;
>>>>>>> Ben

PImage data;

void update() {
  data.loadPixels();
<<<<<<< HEAD
  for (int y = 0; y < data.height; y++) {
    float origIm = downBound + (float(y)/data.height) * abs(upBound - downBound); //<>//
=======
  for (int y = 0; y < data.height; y++) { //<>// //<>//
    final float origIm = downBound + (float(y)/data.height) * abs(upBound - downBound);
>>>>>>> Ben
    for (int x = 0; x < data.width; x++) {
      final float origRe = leftBound + (float(x)/data.width) * abs(leftBound - rightBound);
      
      float re = origRe;
      float im = origIm;
      boolean diverged = false;
      for(int i = 1; i <= maxIters; i++){
        float tempRe = re*re - im*im;
        float tempIm = 2.0 * re * im;
        re = tempRe + origRe;
        im = tempIm + origIm;
        if (dist(re*re, im*im, 0, 0) > 4.0) {
          diverged = true;
          float grey = (float(i)/maxIters)*255;
<<<<<<< HEAD
          data.pixels[y*data.width+x] = color(grey); 
=======
          data.pixels[y*data.width+x] = color(grey);
>>>>>>> Ben
          break;
        }
      }
      if(!diverged){
        data.pixels[y*data.width+x] = color(0);
      }
<<<<<<< HEAD
=======
      //data.pixels[y*data.width+x] = color(origRe*255, origIm * 255, 0);
      //data.pixels[y*data.width+x] = color(re*255, im * 255, 0);
>>>>>>> Ben
    }
  }
  data.updatePixels();
  
}

void setup() {
  size(640, 360);
  data = new PImage(width, height);
}

void draw() {
  update();
  image(data, 0, 0);
  text(nf(frameRate, 2, 1) + " fps", 10, 30);
  text(width + "x" + height + " pixels", 10, 45);
}
