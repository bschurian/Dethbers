PImage img;


void setup(){
  size(640, 320);
  img = loadImage("tim.jpg");
  int dimension = img.width * img.height;
  img.loadPixels();
  
 /* for (int i = 0; i < dimension; i += 2) { 
    img.pixels[i] = color(0, 0, 255); 
  } 
  img.updatePixels();
  
  */
}


void draw(){

 // image(img, 0, 0);
  
  int pointillize = 10;
  // Pick a random point
  int x = int(random(img.width));
  int y = int(random(img.height));
  int loc = x + y*img.width;
  
  // Look up the RGB color in the source image
  loadPixels();
  float r = red(img.pixels[loc]);
  float g = green(img.pixels[loc]);
  float b = blue(img.pixels[loc]);
  noStroke();
  
  // Draw an ellipse at that location with that color
  fill(r,g,b,100);
  ellipse(x,y,pointillize,pointillize);

}
