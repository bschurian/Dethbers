int cols, rows;
int scl = 20;
int w = 1200;
int h= 1200;
float flying = 0;

float[][] terrain;

void setup(){
  size(1920, 1080, P3D);
  //fullScreen(P3D,1);
  cols = w/scl;
  rows=h/scl;
  
  terrain = new float[cols][rows];
}

void draw(){
  
  flying -= 0.05;
  
  float yoff=flying;
  for(int y= 0; y<rows; y++){
    float xoff = 0;
    for(int x = 0; x<cols; x++){
      terrain[x][y] = map(noise(xoff,yoff), 0, 1, -150, 150);
      xoff += 0.1;
    }
    yoff += 0.1;
  }
  
  
  background(0);
  stroke(255);
  
  translate(width/2,height/2);
  rotateX(PI/3);
  
  
  translate(-w/2,-h/2);
  for(int y= 0; y<rows-1; y++){
    
    //fill(100,100,0);
    noFill();
    beginShape(TRIANGLE_STRIP);
    for(int x = 0; x<cols; x++){
       vertex(x*scl, y*scl, terrain[x][y]);
       vertex(x*scl, (y+1)*scl, terrain[x][y+1]);
      //rect(x*scl, y*scl, scl, scl);
    }
    endShape();
  }
  
}
