import peasy.*;
import java.util.Map;

PVector light = new PVector();  // Light direction for shading

final Configuration config_a = new Configuration(0.75f, 0.77f, 0.5759586532f, -0.5759586532f, 0.0f, 0.0f, 30.0f, 0.50f, 0.40f, 0.0f, 10);
final Configuration config_b = new Configuration(0.65f, 0.71f, 0.471238898f, -1.1868238914f, 0.0f, 0.0f, 20.0f, 0.53f, 0.50f, 1.7f, 12);
final Configuration config_c = new Configuration(0.50f, 0.85f, 0.436332313f, -0.2617993878f, PI, 0.0f, 20.0f, 0.45f, 0.50f, 0.5f, 9);
final Configuration config_d = new Configuration(0.60f, 0.85f, 0.436332313f, -0.2617993878f, PI, PI, 20.0f, 0.45f, 0.50f, 0.0f, 10);
final Configuration config_e = new Configuration(0.58f, 0.83f, 0.5235987756f, 0.2617993878f, 0.0f, PI, 20.0f, 0.40f, 0.50f, 1.0f, 11);
final Configuration config_f = new Configuration(0.92f, 0.37f, 0.0f, 1.0471975512f, PI, 0.0f, 2.0f, 0.50f, 0.0f, 0.5f, 15);
final Configuration config_g = new Configuration(0.8f, 0.8f, 0.5235987756f, -0.5235987756f, 2.3911010752f, 2.3911010752f, 30.0f, 0.5f, 0.5f, 0.0f, 10);
final Configuration config_h = new Configuration(0.95f, 0.75f, 0.0872664626f, -0.5235987756f, -HALF_PI, HALF_PI, 40.0f, 0.60f, 0.45f, 25.0f, 12);
final Configuration config_i = new Configuration(0.55f, 0.95f, -0.0872664626f, 0.5235987756f, 2.3911010752f, 2.3911010752f, 5.0f, 0.40f, 0.0f, 5.0f, 12);

// The current configuration
Configuration config = config_g;  // Default is a nice 3D tree
Configuration rootConfig = config_a;

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
Turtle turtle1;  // Draws the graphics
Turtle turtle2;  // Draws the graphics

// Used for production system
//ArrayList<Token> tokens[];
//int current = 0;
Map<String, ArrayList<Token>[]> trees;

// Create a tree by exercising the production system
void buildTree(final Configuration config, final String treeName, final Turtle turtle) {
  trees.remove(treeName);
  ArrayList<Token> tokens[];
  tokens = new ArrayList[2];
  tokens[0] = new ArrayList<Token>();
  tokens[1] = new ArrayList<Token>();

  // Prepare
  tokens[0].clear();
  tokens[1].clear();
  int current = 0;
  int next = 1;

  // Axiom
  tokens[current].add(new A(100, config.om0));

  //for (int i = 0; i <= 5; i++) {
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
    String s = "";
    for(Token t: tokens[current]){
      s+=t.toString();    
    }
    //println(s);
    //println();
  }

  // Make geometry
  turtle.reset();
  if(turn){
    Token t = new Turn(PI);
    t.call(turtle);
  }
  for (Token t : tokens[current]) {
    t.call(turtle);
  }
  trees.put(treeName, tokens);
}

// Pressing any key results in a new tree
void keyReleased() {
  //config = new Configuration(247659);
  config = new Configuration(millis());
  buildTree(config, "main", turtle1);
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

  trees = new HashMap();

  // Build Tree
  turtle1 = new Turtle();
  turn = false;
  config = config_g;
  buildTree(config, "main",turtle1);
  turtle2 = new Turtle();
  turn = true;
  Configuration rootConfig;
  //               Configuration(  r1,   r2,            a1,             a2,      fi1,                 fi2,            om0,    q,    e,  min,  n);
  rootConfig = new Configuration(0.85, 0.8, QUARTER_PI*0.7, -QUARTER_PI*0.7, HALF_PI, -HALF_PI-QUARTER_PI, config.om0*1.1, 0.55, 0.6f, 0, 10);
  //rootConfig = config_g;
  buildTree(rootConfig, "root",turtle2);
  turn = false;
}

boolean turn = true;

public void render(PGraphics canvas) {

  // Tree
  canvas.pushMatrix();
  canvas.scale(0.2);
  //sceneShader.set(
  sceneShader.set("baseColor", 0.49019607843137253, 0.4117647058823529, 0.20392156862745098 );
  turtle1.draw(canvas);
  sceneShader.set("baseColor", 0.396078431372549, 0.3843137254901961, 0.25098039215686274 );
  turtle2.draw(canvas);
  canvas.popMatrix();

  // Box
  sceneShader.set("baseColor", 0.0,1.0,0.0 );
  canvas.noStroke();
  int r = 100;
  canvas.translate(0,r);
  canvas.sphere(r);
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
