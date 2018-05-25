PShader mandel;
int thresh = 10;
float rightBound = 1;
float leftBound = -2.5;
float upBound = 1;
float downBound = - 1;
float zTrans;
float xTrans;
float yTrans;


void setup() {
  size(640, 360, P3D);
  //defaultCam is ortho();
  noStroke();

  mandel = loadShader("mandelzoomer.glsl");

  beginCamera();
  translate(width/2, height/2, 0);
  endCamera();
}

void update() {
  mandel.set("rightBound", rightBound);
  mandel.set("leftBound", leftBound);
  mandel.set("upBound", upBound);
  mandel.set("downBound", downBound);
  shader(mandel);
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  float x = float(mouseX)/width;
  //println(x);
}

float c = 0;

void draw() {
  lights();
  background(100);

  //rect(leftBound, downBound, -leftBound+rightBound, -downBound+upBound);
  rect(-float(width)/2, -float(height)/2, float(width), float(height));
  //rect(0,0,1000, 1000);
  //box(1, 1, 1);

  update();
  //text(nf(frameRate, 2, 1) + " fps", 10, 10, 45);
  //println(nf(frameRate, 2, 1) + " fps", 10, 30);
}
