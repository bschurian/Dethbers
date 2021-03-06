/** //<>// //<>//
 * Mandelbrot 
 * 
 */

protected int maxIters = 200;
protected int thresh = 8;
protected int zoom = 1;
protected float rightBound =  1*zoom;
protected float leftBound  = -2*zoom;
protected float upBound    =  1*zoom;
protected float downBound  = -1*zoom;

PImage data;

void update() {
  data.loadPixels();
  for (int y = 0; y < data.height; y++) { //<>//
    final float origIm = downBound + (float(y)/data.height) * abs(upBound - downBound);
    for (int x = 0; x < data.width; x++) {
      final float origRe = leftBound + (float(x)/data.width) * abs(leftBound - rightBound);

      float re = origRe;
      float im = origIm;
      boolean diverged = false;
      for (int i = 1; i <= maxIters; i++) {
        float tempRe = re*re - im*im;
        float tempIm = 2.0 * re * im;
        re = tempRe + origRe;
        im = tempIm + origIm;
        if (dist(re*re, im*im, 0, 0) > 4.0) {
          diverged = true;
          float grey = (float(i)/maxIters)*255;
          data.pixels[y*data.width+x] = color(grey);
          break;
        }
      }
      if (!diverged) {
        data.pixels[y*data.width+x] = color(0);
      }
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
