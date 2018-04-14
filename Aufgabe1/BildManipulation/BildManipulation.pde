PImage img;
int breit;
int hoch;
int w;
int h;
int rectScale;
float count;

void setup(){
  size(300, 400);
  img = loadImage("me.jpg");
  img.loadPixels();
  image(img, 0, 0);
  
  breit = 300;
  hoch = 400;
  rectScale = 20;
  count = 0;
}

void draw(){
  
  for(h=0; h<hoch; h=h+rectScale){
    for(w=0; w<breit; w=w+rectScale){
      color c = img.get(w,h);
      
      fill(c);
      noStroke();
      rect(w,h,rectScale,rectScale);
    }
  }
  rectScale = int((30*sin(count))+40);
  count = count + 0.02;
}
