PShader mandel;

void setup() {
  size(640, 360, P2D);
  noStroke();

  mandel = loadShader("mandelzoomer.glsl");
}

void draw() {
  shader(mandel); 
  rect(0, 0, width, height);
}
