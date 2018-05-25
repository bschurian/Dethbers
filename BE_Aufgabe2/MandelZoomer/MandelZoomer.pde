PShader mandel;
int thresh = 10;
float rightBound = 1;
float leftBound = -2.5;
float upBound = 1;
float downBound = - 1;
final float zoomFactor = 2;


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
}

void mouseWheel(MouseEvent event) {
  final float e = event.getCount();
  boolean zoomRegistered = true;
  boolean zoomIn= false;
  if(e==-1){
    zoomIn = false;
  }else{
    if(e==1){
      zoomIn = true;
    }else{
      zoomRegistered = false;
    }
  }
  if(zoomRegistered){
    //the point under the mouse is where to zoom in to/ out of
    final float mX = float(mouseX)/width;
    final float x = map(mX,0,1,leftBound,rightBound);
    final float mY = float(mouseY)/height;
    final float y = map(mY,0,1,downBound,upBound);
    //distance to that point
    float xToRB= abs(x - rightBound);
    float xToLB= abs(x - leftBound);
    float yToUB= abs(y - upBound);
    float yToDB= abs(y - downBound);
    //reverse distance if zooming out
    if(!zoomIn){
      xToRB *= -1;
      xToLB *= -1;
      yToUB *= -1;
      yToDB *= -1;
    }
    //modify bounds(scaled to zoomfactor)
    rightBound -= xToRB/zoomFactor;
    leftBound += xToLB/zoomFactor;
    upBound -= yToUB/zoomFactor;
    downBound += yToDB/zoomFactor;
  }
}

float c = 0;

void draw() {
  lights();
  background(100);

  shader(mandel);
  update();

  rect(-float(width)/2, -float(height)/2, float(width), float(height));

  resetShader();
  text(nf(frameRate, 2, 1) + " fps", -float(width)/2+40, -float(height)/2+40, 30);
  text(width + "x" + height + " pixels", -float(width)/2+40, -float(height)/2+60, 30);
}
