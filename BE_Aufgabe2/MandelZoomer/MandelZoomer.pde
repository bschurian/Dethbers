PShader mandel;
protected int thresh = 10;
protected float rightBound = 1;
protected float leftBound = -2.5;
protected float upBound = 1;
protected float downBound = - 1;

void setup() {
  size(640, 360, P2D);
  noStroke();

  mandel = loadShader("mandelzoomer.glsl");
}

void update() {
  mandel.set("rightBound", rightBound);
  mandel.set("leftBound", leftBound);
  mandel.set("upBound", upBound);
  mandel.set("downBound", downBound);
  shader(mandel);
  rect(0, 0, width, height);
}

void draw() {
  update();
  text(nf(frameRate, 2, 1) + " fps", 10, 30);
  text(width + "x" + height + " pixels", 10, 45);
}
