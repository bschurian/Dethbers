float zTrans;
float xTrans;
float yTrans;

void setup() {
  size(640, 360, P3D);
  fill(204);
  
  camera(0.0, 0.0, width, //coordinate for the eye (x,y,z)
         0.0, 0.0, 0.0,   //coordinate for the center of the scene (x,y,z)
         0.0, 0.0, 0.0);  // upX,upY,upZ
  translate(width/2,height/2,0);
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  zTrans += e*0.1;
  println(e);
}

void mouseDragged(){
  xTrans = mouseX; 
  yTrans = mouseY; 
}


void draw() {
  lights();
  background(0);
  
  beginCamera();
  camera();
  translate(xTrans,yTrans,-zTrans);
  endCamera();
  
  noStroke();
  box(90);
}
