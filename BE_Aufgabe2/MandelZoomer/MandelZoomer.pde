PShader mandel;
int thresh = 10;
final float rightBound = 1;
final float leftBound = -2.5;
final float upBound = 1;
final float downBound = - 1;
float zTrans;
float xTrans;
float yTrans;


void setup() {
  size(640, 360, P3D);
  noStroke();

  mandel = loadShader("mandelzoomer.glsl");

  beginCamera();
  float fov = PI/3.0;
  float cameraZ = (height/2.0) / tan(fov/2.0);;
  perspective(fov, float(width)/float(height), 0.1, 1000);
  translate(width/2, height/2, 310);
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
  zTrans += e*10;
}

void keyPressed() {
  float zDelta=0;
  if (keyCode==UP) {
    zDelta = -1;
  }
  if (keyCode==DOWN) {
    zDelta = 1;
  }
  zTrans += zDelta;
  print(zTrans);
  beginCamera();
  translate(0, 0, zDelta);
  endCamera();
}  

void mouseDragged() {
  xTrans = mouseX; 
  yTrans = mouseY;
}

void draw() {
  lights();
  background(100);

  beginCamera();
  //camera(0, 0, 31, //coordinate for the eye (x,y,z)
  //       0, 0, 0,   //coordinate for the center of the scene (x,y,z)
  //       0, 1, 0);  // upX,upY,upZ
  //frustum(-10, 0, 0, 10, 10, 200);
//  translate(0, 0, -zTrans);
  endCamera();

  rect(leftBound, downBound, -leftBound+rightBound, -downBound+upBound);
  //box(1, 1, 1);

  update();
  //text(nf(frameRate, 2, 1) + " fps", 10, 10, 45);
  //println(nf(frameRate, 2, 1) + " fps", 10, 30);
}
