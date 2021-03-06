import peasy.*;
import java.util.Map;
//import java.util.stream.Stream;

PVector light = new PVector();  // Light direction for shading
PVector light2 = new PVector();  // Light direction for shading
int lDistance;

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

PShader sceneShader;   // For rendering the trees
PShader earthShader;   // For rendering the earth
PShader starsShader;
PShader treeShader;
PShader shadowShader;  // For renderung the shadow map
PGraphics shadowMap;   // Keeps the shadow information as a texture
PGraphics shadowMap2;   // Keeps the shadow information as a texture

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
PShape whale;
int whalesN = 5;

// Used for production system
//ArrayList<Token> tokens[];
//int current = 0;
Map<String, ArrayList<Token>[]> trees;

float earthAlpha = 1;

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

  boolean aNext = true;
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
        if (a.s >= config.min) {
          Token[] newTokens = new Token[]{new Weight(a.w), new Forward(a.s), new Push(), new Turn(config.a1), new Roll(config.fi1), new A(a.s * config.r1, a.w * pow(config.q, config.e)), new Pop(), new Push(), new Turn(config.a2), new Roll(config.fi2), new A(a.s * config.r2, a.w * pow(1-config.q, config.e)), new Pop()};
          for (Token token : newTokens) {
            tokens[next].add(token);
          }
        } else {
          float r = random(5, 10); 
          if (aNext) {
            tokens[next].add(new Apple(r));
          }
          aNext = !aNext;
        }
      }
    }


    tokens[current] = tokens[next];
    //String s = "";
    //for (Token t : tokens[current]) {
    //  s+=t.toString();
    //}
    //println(s);
    //println();
  }



  // Make geometry
  turtle.reset();
  if (isRoot) {
    Token t = new Turn(PI);
    t.call(turtle);
  } else {
    //Apple
    tokens[next] = new ArrayList<Token>();
    for (Token t : tokens[current]) {
      if (!(t instanceof A)) {
        tokens[next].add(t);
      } else {
        //if (random(0, 2) >=1) {
        //float r = random(5, 10); 
        //  tokens[next].add(new Apple(r));
        //}
        if (aNext) {
          float r = random(5, 10); 
          tokens[next].add(new Apple(r));
        }
        aNext = !aNext;
      }
    }

    tokens[current] = tokens[next];
  }
  for (Token t : tokens[current]) {
    t.call(turtle);
  }
  trees.put(treeName, tokens);
}

// Pressing (almost) any key results in a new tree
void keyReleased() {
  switch(keyCode) {
  case LEFT:
    earthAlpha = max(earthAlpha-0.1, 0.0);
    break;
  case RIGHT:
    earthAlpha = min(earthAlpha+0.1, 1.0);
    break;
  default:
    //antlers
    //config = new Configuration(201602);
    //bouquet
    //config = new Configuration(29353);
    config = new Configuration(millis());
    buildTree(config, "main", turtle1);
    isRoot = true;
    Configuration rootConfig;
    //               Configuration(  r1,   r2,            a1,             a2,      fi1,                 fi2,            om0,    q,    e,  min,  n);
    rootConfig = new Configuration(0.85, 0.8, QUARTER_PI*0.7, -QUARTER_PI*0.7, HALF_PI, -HALF_PI-QUARTER_PI, config.om0*1.1, 0.55, 0.6f, 0, 8);
    //rootConfig = config_g;
    println(rootConfig);    
    buildTree(rootConfig, "root", turtle2);
    isRoot = false;
  }
}

void setup() {

  fullScreen(P3D);
  //size(800, 600, P3D);
  blendMode(BLEND);

  // Setup camera
  cam = new PeasyCam(this, 300);
  cam.rotateY(PI/4);
  cam.rotateX(PI/4);
  //cam.lookAt(0, -50, 0);
  cam.setWheelScale(0.1);

  lDistance = 160;

  // Setup shadow mapping 
  shadowShader = new PShader(this, "shadow.vert", "shadow.frag");
  shadowMap = createGraphics(width * 4, height * 4, P3D);
  shadowMap.beginDraw();
  shadowMap.noStroke();
  shadowMap.shader(shadowShader);
  shadowMap.ortho(-200, 200, -200, 200, 10, 400); // Setup orthogonal view matrix for the directional light
  shadowMap.endDraw();
  shadowMap2 = createGraphics(width * 4, height * 4, P3D);
  shadowMap2.beginDraw();
  shadowMap2.noStroke();
  shadowMap2.shader(shadowShader);
  shadowMap2.ortho(-200, 200, -200, 200, 10, 400); // Setup orthogonal view matrix for the directional light
  shadowMap2.endDraw();


  // Init scene render
  sceneShader = new PShader(this, "scene.vert", "scene.frag");
  shader(sceneShader);
   treeShader = new PShader(this, "tree.vert", "tree.frag");
 // shader(treeShader);
  noStroke();
  perspective(60 * DEG_TO_RAD, (float)width / height, 10, 4000);
  // Init earth render
  earthShader = new PShader(this, "earth.vert", "earth.frag");
  // Init earth render
  starsShader = new PShader(this, "stars.vert", "stars.frag");


  trees = new HashMap();

  // Build Tree
  turtle1 = new Turtle();
  isRoot = false;
  //  config = config_g;
  //               Configuration(  r1,   r2,            a1,             a2,      fi1,                 fi2,            om0,    q,    e,  min,  n);
  config = new Configuration(0.9, 0.9, config_g.a1, config_g.a2, config_g.fi1, config_g.fi2, 70, config_g.q, config_g.e, config_g.min, config_g.n);
  buildTree(config, "main", turtle1);
  turtle2 = new Turtle();
  isRoot = true;
  Configuration rootConfig;
  //               Configuration(  r1,   r2,            a1,             a2,      fi1,                 fi2,            om0,    q,    e,  min,  n);
  rootConfig = new Configuration(0.85, 0.8, QUARTER_PI*0.7, -QUARTER_PI*0.7, HALF_PI, -HALF_PI-QUARTER_PI, config.om0*1.1, 0.55, 0.6f, 0, 8);
  //rootConfig = config_g;
  buildTree(rootConfig, "root", turtle2);
  isRoot = false;

  whale = loadShape("whale.obj");
  //magic number based on the model
  whale.scale(0.7);
  whale.rotateZ(-HALF_PI);
  whale.rotateY(0.3);
  whale.translate(0, 0, 20);
}

boolean isRoot = true;

public void renderTree(PGraphics canvas) {
  // Tree
  canvas.pushMatrix();
  canvas.scale(0.2);

  //treeShader.set("baseColor", 0.49019607843137253, 0.4117647058823529, 0.20392156862745098, 1.0 );
 // sceneShader.set("baseColor", 0.49019607843137253, 0.4117647058823529, 0.20392156862745098, 1.0 );
  treeShader.set("baseColor", 1.0*0.95, 0.98*0.95, 0.98*0.95, 1.0 );
  turtle1.draw(canvas);
  // sceneShader.set("baseColor", 0.5, 0.5, 0.5, 0.6);
  // turtle1.fruitDraw(g);
  //sceneShader.set("baseColor", 0.396078431372549, 0.3843137254901961, 0.25098039215686274, 1.0 );
  
  treeShader.set("baseColor", 1.0, 1.0, 1.0, 1.0 );

  turtle2.draw(canvas);
  canvas.popMatrix();
}
private PVector position(float t, float r) { 
  return new PVector( 
    r * cos(t), 
    //magic numbers
    sin(t)*50+sin(t*5)*3, 
    r * sin(t) 
    );
} 
private PVector derivate1(float t, float r) { 
  return new PVector( 
    - r * sin(t), 
    //0,
    //magic numbers
    cos(t)*50, 
    r * cos(t) 
    );
} 
private PVector derivate2(float t, float r) { 
  return new PVector( 
    - r * cos(t), 
    0, 
    - r * sin(t) 
    );
} 
private PMatrix3D frenet(float t, float r) { 
  // Translate 
  PMatrix3D matrix = new PMatrix3D(); 
  final PVector pos = position(t, r); 
  matrix.translate(pos.x, pos.y, pos.z); 
  // Rotate 
  final PVector e0 = derivate1(t, r).normalize(); 
  final PVector e2 = e0.cross(derivate2(t, r)).normalize(); 
  final PVector e1 = e2.cross(e0);
  matrix.apply( 
    e2.x, e1.x, e0.x, 0, 
    e2.y, e1.y, e0.y, 0, 
    e2.z, e1.z, e0.z, 0, 
    0, 0, 0, 1 
    ); 

  //// Scale 
  //final float f = 1.0 + sin(8.0 * t) / 5.0;  // TODO: This is different for a shell 
  //matrix.scale(f, f, f); 

  return matrix;
} 
public void renderWhales(PGraphics canvas) {
  float t = ((float) millis())/1000/30*4;
  float r = 100.0;
  for (int i = 0; i< whalesN; i++) {
    canvas.pushMatrix();
    //magic numbers
    canvas.translate(0, -75, 0);
    canvas.applyMatrix(frenet(t+2*PI*(1.0/5)*i, r+sin(t)));
    canvas.shape(whale);
    canvas.popMatrix();
  }
}
public void render(PGraphics canvas) {
  renderTree(canvas);
  renderWhales(canvas);
}
public void renderShadowMaps() {
  // Render the shadow map
  shadowMap.beginDraw();
  shadowMap.background(0xffffffff); // Will set the depth to 1.0 (maximum depth)
  shadowMap.camera(light.x, light.y, light.z, 0, 0, 0, 0, 1, 0);
  render(shadowMap);
  shadowMap.endDraw();
  sceneShader.set("shadowMap", shadowMap);  // Send to shader
  earthShader.set("shadowMap", shadowMap);  // Send to shader
  //treeShader.set("shadowMap", shadowMap);  // Send to shader
  // Generate shadow coordinate transformation matrix
  final PMatrix3D PMV = ((PGraphicsOpenGL)shadowMap).projmodelview;
  final PMatrix3D MV_inverse = ((PGraphicsOpenGL)g).modelviewInv;    
  PMatrix3D shadowTransform = new PMatrix3D();
  shadowTransform.apply(shadowCoordsToUvSpace);  // Convert coords into UV
  shadowTransform.apply(PMV); // Apply project-model-view matrix from the shadow pass (light direction)
  shadowTransform.apply(MV_inverse); // Processing needs us to apply the inverted model-view matrix of the final scene pass [1] 
  shadowTransform.transpose(); // [2]
  sceneShader.set("shadowTransform", shadowTransform); // Send to shader
  //treeShader.set("shadowTransform", shadowTransform); // Send to shader
  earthShader.set("shadowTransform", shadowTransform); // Send to shader

  shadowMap2.beginDraw();
  shadowMap2.background(0xffffffff); // Will set the depth to 1.0 (maximum depth)
  shadowMap2.camera(light2.x, light2.y, light2.z, 0, 0, 0, 0, 1, 0);
  render(shadowMap2);
  shadowMap2.endDraw();
  sceneShader.set("shadowMap2", shadowMap2);  // Send to shader
  earthShader.set("shadowMap2", shadowMap2);  // Send to shader
  treeShader.set("shadowMap2", shadowMap2);  // Send to shader
  // Generate shadow coordinate transformation matrix
  final PMatrix3D PMV2 = ((PGraphicsOpenGL)shadowMap2).projmodelview;
  final PMatrix3D MV_inverse2 = ((PGraphicsOpenGL)g).modelviewInv;    
  PMatrix3D shadowTransform2 = new PMatrix3D();
  shadowTransform2.apply(shadowCoordsToUvSpace);  // Convert coords into UV
  shadowTransform2.apply(PMV2); // Apply project-model-view matrix from the shadow pass (light direction)
  shadowTransform2.apply(MV_inverse2); // Processing needs us to apply the inverted model-view matrix of the final scene pass [1] 
  shadowTransform2.transpose(); // [2]
  sceneShader.set("shadowTransform2", shadowTransform2); // Send to shader
  treeShader.set("shadowTransform2", shadowTransform2); // Send to shader
  earthShader.set("shadowTransform2", shadowTransform2); // Send to shader
}
public void renderScene() {
  directionalLight(255, 255, 255, light.x, light.y, light.z);
  directionalLight(255, 255, 255, light2.x, light2.y, light2.z);
  // Render
  shader(treeShader);
  renderTree(g);

  shader(sceneShader);
  //sceneShader.set("baseColor", 0.1, 0.5, 1.0, 1.0);
 
  shader(treeShader);
   treeShader.set("baseColor", 0.1, 0.5, 1.0, 1.0);
  //blendMode(ADD);

  renderWhales(g);
  //blendMode(BLEND);
  shader(earthShader);
  renderEarth();
  shader(sceneShader);
  renderFruits();
}
public void renderFruits() {
  g.pushMatrix();
  g.scale(0.2);
  sceneShader.set("baseColor", 1.0, 0.5, 0.5, 0.4);
  turtle1.fruitDraw(g);
  g.popMatrix();
}
public void renderEarth() {
  // Earth
  //  earthShader.set("baseColor", 0.0, 1.0, 0.0 );
  earthShader.set("alpha", earthAlpha );
  earthShader.set("t", (float(millis())/1000.0)/365.0*2);
  int r = 200;
  g.translate(0, r);
  g.sphere(r);
  g.translate(0, -r);
}
public void renderBackground() {
  int r = 1000;
  sphere(r);
}
public void renderLightSources() {
  sceneShader.set("baseColor", 0.7, 0.9, 1.0, 1.0 );
  pushMatrix();
  fill(255);
  translate(light.x*1.05, light.y*1.05, light.z*1.05);
  sphere(5);
  popMatrix();
  pushMatrix();
  fill(255);
  translate(light2.x*1.05, light2.y*1.05, light2.z*1.05);
  sphere(5);
  popMatrix();
}
void draw() {
  background(255, 0, 0);

  // Calculate the light position
  final float t = TWO_PI * (millis() / 1000.0) / 20.0;
  light.set(sin(t) * lDistance, -lDistance, cos(t) * lDistance);
  light2.set(sin(t*1.5+HALF_PI) * lDistance, -lDistance*0.95, sin(t*1.5) * lDistance);

  shader(shadowShader);
  renderShadowMaps();  // shadow pass
  shader(starsShader);
  renderBackground(); 
  renderScene();      // final scene
  shader(sceneShader);
  renderLightSources(); // add indication of light position
}

/*
 * [1] This is needed because Processing is pre-multiplying the vertices by the modelview matrix (for better performance).
 * [2] Why does the matrix need to be transposed ?!
 */
