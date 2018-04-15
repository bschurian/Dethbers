PImage img;

int rectScale;
int count;

void setup(){
  size(300, 400);
  img = loadImage("me.jpg");
  img.loadPixels();
  image(img, 0, 0);
  
  count = 0;
}

void draw(){
  
  rectScale = int(20*sin(0.02*count)+30);
  
  for(int h=0; h<height; h += rectScale){
    for(int w=0; w<width; w += rectScale){
      color c = img.get(w,h);
      
      fill(c);
      noStroke();
      rect(w, h, rectScale, rectScale);
    }
  }
  
  count++;
  
  // saveFrame("output/picManip_####.png");
}
