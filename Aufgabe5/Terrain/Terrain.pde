import peasy.PeasyCam;

PeasyCam cam;

PVector sun;
PShader shader;
DiamondSquareHeightMesh mesh;

void setup() {
  fullScreen(P3D);
  //size(800, 800, P3D);

  // Setup camera
  cam = new PeasyCam(this, 0, 0, 0, 100);
  cam.setWheelScale(0.1);
  perspective(radians(50), float(width)/float(height), 1.0, 10000.0);

  // Setup shader
  sun = new PVector(0, 50, 0);
  shader = new PShader(this, "vertex.glsl", "fragment.glsl");
  shader.set("lightPosition", sun);
  shader.set("skyColor", new PVector(0.8, 0.8, 1.0));
  shader.set("groundColor", new PVector(0.3, 0.2, 0.0));
  shader.set("highlightColor", new PVector(0.3, 0.2, 0.1));
  shader.set("shininess", 4.0);
  
  // Create mesh
  mesh = new DiamondSquareHeightMesh().mapSize(33).harshness(0.4).size(100, 100).scale(25).subdivisions(8);
}

float waterLevel = 0.0;

void draw() {
  
  background(70, 70, 70);

  // Terrain
  shader(shader);
  shape(mesh.geometry());
  resetShader();
  
  // Water
  if (show_water) {
    if (incPressed) waterLevel += 0.1;
    if (decPressed) waterLevel -= 0.1;
    strokeWeight(3);
    stroke(100, 100, 255);
    fill(0, 0, 255);
    translate(0, 0, waterLevel);
    rect(- mesh.width() / 2, - mesh.height() /2, mesh.width(), mesh.height());
  }
  
  // Height map texture
  if (show_texture) {
    cam.beginHUD();
    image(mesh.heightMap(), 0, 0, 200, 200);
    cam.endHUD();
  }
}



// --- Key handling -------------

boolean show_texture = false;
boolean show_water = false;
boolean incPressed = false; 
boolean decPressed = false;

// Need this for continuous key presses
void keyPressed() {
   if (key == CODED) {
     if (keyCode == UP) incPressed = true;
     if (keyCode == DOWN) decPressed = true;
   }
}

// Check keys
void keyReleased() {
  switch (key) {
  case 't':
    show_texture = !show_texture;
    break;
  case 'w':
    show_water = !show_water;
    break;
  case 's':
    mesh.seed(millis());
    break;
  case CODED:
    switch (keyCode) {
    case UP:
      incPressed = false;
      break;
    case DOWN:
      decPressed = false;
      break;
    }
  }
}
