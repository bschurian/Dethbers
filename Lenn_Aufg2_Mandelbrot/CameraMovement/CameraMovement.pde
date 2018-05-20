float zTrans;
float xTrans;
float yTrans;
float xOffset;
float yOffset;
float px;
float py;
boolean locked;

void setup() {
  size(640, 360, P3D);
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  zTrans += e;
  //println(zTrans);
}

void mousePressed() {
  locked = true; 
  xOffset = mouseX-px; 
  yOffset = mouseY-py;
}

void mouseDragged() {
  if (locked) {
    px = mouseX-xOffset; 
    py = mouseY-yOffset;
  }
}

void mouseReleased() {
  locked = false;
}

void draw() {
  lights();
  background(0);

  beginCamera();
  camera(0.0, 0.0, width/2, // coordinate for the eye (x,y,z)
    0.0, 0.0, 0.0,          // coordinate for the center of the scene (x,y,z)
    0.0, 1.0, 0.0);         // upX,upY,upZ
  translate(xTrans, yTrans, (-zTrans));
  endCamera();
  
  println(-zTrans);

  //objects to screen
  noStroke();
  rect(px-width/2, py-height/2, width, height);
}
