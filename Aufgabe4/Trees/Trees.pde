import peasy.*;

PVector light = new PVector();  // Light direction for shading

PShader sceneShader;   // For rendering the final scene
PShader shadowShader;  // For renderung the shadow map
PGraphics shadowMap;   // Keeps the shadow information as a texture

// This matrix transoforms homogeneous shadowCoords into the UV texture space [-1, 1] -> [0, 1]
final PMatrix3D shadowCoordsToUvSpace = new PMatrix3D(
  0.5, 0.0, 0.0, 0.5, 
  0.0, 0.5, 0.0, 0.5, 
  0.0, 0.0, 0.5, 0.5, 
  0.0, 0.0, 0.0, 1.0
  );

PeasyCam cam;   // Useful camera library
Turtle turtle;  // Draws the graphics

// Used for production system
ArrayList<Token> tokens[];
int current = 0;

// Create a tree by exercising the production system
void buildTree() {

  // Prepare
  tokens[0].clear();
  tokens[1].clear();
  current = 0;
  int next = 1;

  // Axiom
  tokens[current].add(new A(100, config.om0));

  for (int i = 0; i <= config.n; i++) {
    tokens[next] = new ArrayList<Token>();
    for (Token t : tokens[current]) {
      if (!(t instanceof A)) {
        tokens[next].add(t);
      } else {
        A a = (A) t;
        if(a.s >= config.min){
          Token[] newTokens = new Token[]{new Weight(a.w),new Forward(a.s),new Push(), new Turn(config.a1),new Roll(config.fi1),new A(a.s * config.r1, a.w * pow(config.q, config.e)),new Pop(),new Push(), new Turn(config.a2),new Roll(config.fi2),new A(a.s * config.r2, a.w * pow(1-config.q, config.e)),new Pop()};
          for(Token token: newTokens){
            tokens[next].add(token);
          }      
        }
      }
    }
    tokens[current] = tokens[next];
  }

  // Make geometry
  turtle.reset();
  for (Token t : tokens[current]) {
    t.call();
  }
}

// Pressing any key results in a new tree
void keyReleased() {
  config = new Configuration(millis());
  buildTree();
}

void setup() {

  fullScreen(P3D);

  // Setup camera
  cam = new PeasyCam(this, 300);
  cam.rotateY(PI/4);
  cam.rotateX(PI/4);
  //cam.lookAt(0, -50, 0);
  cam.setWheelScale(0.1);

  // Setup shadow mapping 
  shadowShader = new PShader(this, "shadow.vert", "shadow.frag");
  shadowMap = createGraphics(width * 4, height * 4, P3D);
  shadowMap.beginDraw();
  shadowMap.noStroke();
  shadowMap.shader(shadowShader);
  shadowMap.ortho(-200, 200, -200, 200, 10, 400); // Setup orthogonal view matrix for the directional light
  shadowMap.endDraw();

  // Init scene render
  sceneShader = new PShader(this, "scene.vert", "scene.frag");
  shader(sceneShader);
  noStroke();
  perspective(60 * DEG_TO_RAD, (float)width / height, 10, 1000);

  // Build Tree
  turtle = new Turtle();
  tokens = new ArrayList[2];
  tokens[0] = new ArrayList<Token>();
  tokens[1] = new ArrayList<Token>();
  buildTree();
}

public void render(PGraphics canvas) {

  // Tree
  canvas.pushMatrix();
  canvas.scale(0.2);
  turtle.draw(canvas);
  canvas.popMatrix();

  // Box
  canvas.noStroke();
  canvas.fill(255);
  canvas.box(300, 5, 300);
}

public void renderShadowMap() {

  // Render the shadow map
  shadowMap.beginDraw();
  shadowMap.camera(light.x, light.y, light.z, 0, 0, 0, 0, 1, 0);
  shadowMap.background(0xffffffff); // Will set the depth to 1.0 (maximum depth)
  render(shadowMap);
  shadowMap.endDraw();
  sceneShader.set("shadowMap", shadowMap);  // Send to shader

  // Generate shadow coordinate transformation matrix
  final PMatrix3D PMV = ((PGraphicsOpenGL)shadowMap).projmodelview;
  final PMatrix3D MV_inverse = ((PGraphicsOpenGL)g).modelviewInv;    
  PMatrix3D shadowTransform = new PMatrix3D();
  shadowTransform.apply(shadowCoordsToUvSpace);  // Convert coords into UV
  shadowTransform.apply(PMV); // Apply project-model-view matrix from the shadow pass (light direction)
  shadowTransform.apply(MV_inverse); // Processing needs us to apply the inverted model-view matrix of the final scene pass [1] 
  shadowTransform.transpose(); // [2]
  sceneShader.set("shadowTransform", shadowTransform); // Send to shader
}

public void renderScene() {
  background(100, 100, 100);
  directionalLight(255, 255, 255, light.x, light.y, light.z);
  render(g);
}

public void renderLightSource() {
  pushMatrix();
  fill(255);
  translate(light.x, light.y, light.z);
  sphere(5);
  popMatrix();
}

void draw() {

  // Calculate the light position
  final float t = TWO_PI * (millis() / 1000.0) / 10.0;
  light.set(sin(t) * 160, -160, cos(t) * 160);

  // Render
  renderShadowMap();  // shadow pass
  renderScene();      // final scene
  renderLightSource(); // add indication of light position
}

/*
 * [1] This is needed because Processing is pre-multiplying the vertices by the modelview matrix (for better performance).
 * [2] Why does the matrix need to be transposed ?!
 */
