
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
  // Define extruded object
  PShape path = createShape(ELLIPSE, 0, 0, 1, 3);
  //path = createShape(TRIANGLE,2,1,0,0,0,1);
  object = new Torus().radius(1.5).segments(100).shape(path).turns(2).z0(2.66).alpha(PI/48);
  //object = new Torus().radius(1).segments(100).shape(path).turns(2).z0(2.4).alpha(PI/48);
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

  lights();

  //object.turns(object.turns +.001);

  // Draw shell
  shader(shader);
  shape(object.geometry());

  //stroke(1);
  //for (int i=0; i< object.vertex.size(); ++i) {
  //  PVector v= object.vertex.get(i);
  //  PVector n= object.vertexNormal.get(i);
  //  // n.mult(0.5);
  //  float l = 0.1;
  //  line(v.x, v.y, v.z, v.x+n.x*l, v.y+n.y*l, v.z+n.z*l);
  //}
  //line(0, 0, 0, 1, 0, 0);
  //line(0, 0, 0, 0, 4, 0);
  //line(0, 0, 0, 0, 0, 10);
}  
