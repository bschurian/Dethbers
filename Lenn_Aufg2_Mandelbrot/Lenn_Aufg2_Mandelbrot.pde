PImage data;

// It all starts with the width, try higher or lower values
float w = 4;
float h = (w * height) / width;

// Start at negative half the width and height
float xmin = -w/2;
float ymin = -h/2;


void update() {

  data.loadPixels();

  // Calculate Mandelbrot set and write to pixels of data image
  // TODO

  
  data.updatePixels();
}

void setup() {
  size(600, 400);
  data = new PImage(width, height);
  background(51);
}

void draw() {
  update();
  image(data, 0, 0);
  text(nf(frameRate, 2, 1) + " fps", 10, 30);
  text(width + "x" + height + " pixels", 10, 45);
}
