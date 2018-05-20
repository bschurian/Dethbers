PShader mandel;
protected int thresh = 10;
protected float rightBound = 1;
protected float leftBound = -2.5;
protected float upBound = 1;
protected float downBound = - 1;
float zTrans;
float xTrans;
float yTrans;


void setup() {
  size(640, 360, P3D);
  noStroke();

  mandel = loadShader("mandelzoomer.glsl");
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
  zTrans += e;
  println(zTrans);
}

void mouseDragged(){
  xTrans = mouseX; 
  yTrans = mouseY; 
}

void draw() {
  lights();
  background(0);

  beginCamera();
  camera(0, 0, 1, //coordinate for the eye (x,y,z)
         0, 0, 0,   //coordinate for the center of the scene (x,y,z)
         0, 1, 0);  // upX,upY,upZ
  translate(xTrans,yTrans,-zTrans);
  endCamera();
  
box(90);
  //rect(0, 0, width, height);


  update();
  text(nf(frameRate, 2, 1) + " fps", 10, 30);
  text(width + "x" + height + " pixels", 10, 45);
 // println(nf(frameRate, 2, 1) + " fps", 10, 30);
}
