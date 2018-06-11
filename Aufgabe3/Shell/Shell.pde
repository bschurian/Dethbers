
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
  perspective(50, float(width)/float(height), z/10.0, z*10.0);
  //perspective(50, float(width)/float(height), 0.0001, 100000);

  // Init shader
  shader = loadShader("fragment.glsl", "vertex.glsl");
  // Define extruded object
  PShape path = createShape(ELLIPSE, 0, 0, 1, 1);
  //path = createShape(TRIANGLE, -2,0, -1,0, -2,-1);
  //path = createShape(RECT, 1,1,2,2);
  object = new Torus().radius(.5).segments(300).shape(path).turns(4).z0(2.55).alpha(PI/48);
}


void draw() {

  background(80, 80, 120); 
  noStroke();  // Comment out to see wireframed

  // Set lights
  ambientLight(250, 250, 20);
  lightSpecular(255, 255, 255);  
  float[] camPos = cam.getPosition();
  directionalLight(204, 204, 204, -camPos[0], -camPos[1], -camPos[2]);
  //directionalLight(0, 255, 0, 1, 0, 0);
  shininess(128);
  specular(255, 255, 255);

  //lights();

  //object.turns(object.turns +.001);
  shape(object.geometry());

  // Draw shell  
  shader.set("color", 0.5, 0.5, 0.5);
  shader(shader);

  stroke(1);
  //for (int i=0; i< object.vertex.size(); i++) {
  //  println(object.vertex.get(i));
  //  PVector v= object.vertex.get(i);
  //  PVector n= object.vertexNormal.get(i);
  //  float l = 0.1;
  //  line(v.x, v.y, v.z, v.x+n.x*l, v.y+n.y*l, v.z+n.z*l);
  //}
  //println();
  //color(255,0,0);
  stroke(1);
  line(0, 0, 0, 10, 0, 0);
  line(0, 0, 0, 0, 10, 0);
  line(0, 0, 0, 0, 0, 10);
  
}  
