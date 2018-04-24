PShader edges;  
PImage img;
    
void setup() {
  size(300, 400, P2D);
  img = loadImage("me.jpg");      
  edges = loadShader("edges.glsl");
}

void draw() {
  shader(edges);
  image(img, 0, 0);
}
