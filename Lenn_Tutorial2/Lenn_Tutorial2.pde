/**
 * Mouse 2D. 
 * 
 * Moving the mouse changes the position and size of each box. 
 */
 
 //Globale Variablen
 float angle1 =0; 
 float angle2 =0;
 float size;
 float position;
 

void setup() {

  size(640, 360); 
  size = height/2;
  position = width;
  noStroke();
  rectMode(CENTER);
}

void draw() {
  
  background(51);
  
  float d1 = 10 + (sin(angle1) * size/2) + size/2;
  float d2 = 10 + (sin(angle1 + PI) * size/2) + size/2;
  
  float x1 = 10 + (sin(angle2) * position/2) + position/2;
  float x2 = 10 + (sin(angle2 + PI) * position/2) + position/2;

  fill(255, 204);
  rect(x1, height/2, d1, d1); 
  rect(x2, height/2, d2, d2);


  angle1 += 0.1;  //Frequenz Größe 1Hz
  angle2 += 0.025; //Frequenz Position 0.25Hz
}
