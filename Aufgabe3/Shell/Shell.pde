
import peasy.PeasyCam;

PeasyCam cam;

PShader shader;
Torus object;

void setup() {
  
  size(1000, 800, P3D);
  
  // Set camera
  cam = new PeasyCam(this, 50);
  cam.setWheelScale(0.1);
  float z = cam.getPosition()[2];
  perspective(50, float(width)/float(height), z/10.0, z*10.0);
  
  // Init shader
  shader = loadShader("fragment.glsl", "vertex.glsl"); 
  shader.set("color", 0.5, 0.9, 0.8);
  
  // Define extruded object
  PShape path = createShape(ELLIPSE, 0, 0, 2, 1);
  object = new Torus().radius(5).segments(100).shape(path);
}

void draw() {
  
  background(80, 80, 120); 
  //noStroke();  // Comment out to see wireframe

  // Set lights
  ambientLight(20, 20, 20);
  lightSpecular(255, 255, 255);  
  float[] camPos = cam.getPosition();
  directionalLight(204, 204, 204, -camPos[0], -camPos[1], -camPos[2]);
  shininess(128);
  specular(255, 255, 255);
  
  // Draw shell
  shader(shader);
  shape(object.geometry());
}  
