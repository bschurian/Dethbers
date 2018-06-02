import camera3D.*;
import camera3D.generators.*;
import camera3D.generators.util.*;

  
PShader edges;  
PImage img;
    
float xo;
float yo;
float zoom =1;

    
void setup() {
    size(600, 600, P3D);
    xo= width/2;
    yo= height/2;
    smooth();
    //noStroke();
    
   // img = loadImage("Download.png");      
  //edges = loadShader("edges.glsl");
   // image(img, 0, 0);
}

void draw() {
 // shader(edges);

noFill();
background(204);
beginCamera();
camera();
translate(50,50,0);

//scale(zoom);
box(75);
}


void keyPressed(){
  if (key == CODED){
    if(keyCode == UP){
      zoom += .03;
    }
    if(keyCode == DOWN){
      zoom -= .03;
    }
 
  }
 // camera(100.0, 60.0, 10.0, 50.0, 50.0, 3.0, 0.0, 1.0, 4.0);
}
