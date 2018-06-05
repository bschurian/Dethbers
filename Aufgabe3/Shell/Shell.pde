
import peasy.PeasyCam;
import processing.opengl.PGL;

PeasyCam cam;

PShader shader;
Torus object;

void setup() {

  size(1000, 800, P3D);

  // Set camera
  cam = new PeasyCam(this, 50);
  //cam.setWheelScale(0.1);
  float z = cam.getPosition()[2];
  //perspective(50, float(width)/float(height), z/10.0, z*10.0);
  perspective(50, float(width)/float(height), 0.0001, 100000);

  // Init shader
  shader = loadShader("fragment.glsl", "vertex.glsl"); 
  shader.set("color", 0.5, 0.9, 0.8);

  // Define extruded object
  PShape path = createShape(ELLIPSE, 0, 0, 1, 1);
  object = new Torus().radius(0.5).segments(100).shape(path).turns(2);
}

void draw() {

  background(80, 80, 120); 
  noStroke();  // Comment out to see wireframed

  // Set lights
  ambientLight(20, 20, 20);
  lightSpecular(255, 255, 255);  
  float[] camPos = cam.getPosition();
  directionalLight(204, 204, 204, -camPos[0], -camPos[1], -camPos[2]);
  shininess(128);
  specular(255, 255, 255);

  // Draw shell
  //shader(shader);
  shape(object.geometry());
  /*
  stroke(1);
  for (int i=0; i< object.vertex.size(); ++i) {

    PVector v= object.vertex.get(i);
    PVector n= object.vertexNormal.get(i);
   // n.mult(0.5);
    line(v.x, v.y, v.z, v.x+n.x*0.1, v.y+n.y*0.1, v.z+n.z*0.1);
     
  }*/
}  
