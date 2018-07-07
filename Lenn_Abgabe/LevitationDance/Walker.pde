class Walker {
  float x, y, targetX, targetY, ellipseSize = 5.0;


  Walker(float x_init, float y_init) {
    this.x = x_init;
    this.y = y_init;
  }

  float getX() {
    return x;
  }
  float getY() {
    return y;
  }

  // method for walk at beat - long move
  void beatWalk() {
    targetX = x+random(-width/2, width/2);
    targetY = y+random(-height/2, height/2);
    if (targetX < 0 || targetX > width || targetY < 0 || targetY > height ) {
      beatWalk();
    } else {
      // move smoothly to target positXon
      x = lerp(x, targetX, 0.1);
      y = lerp(y, targetY, 0.1);      
    }
  }

  // method for walk at no beat - short move
  void walk() {    
    targetX = x+random(-10, 10);
    targetY = y+random(-10, 10);   

    if (targetX < 0 || targetX > width || targetY < 0 || targetY > height) {
      walk();
    } else {
      // move smoothly to target positXon
      x = lerp(x, targetX, 0.1);
      y = lerp(y, targetY, 0.1);      
    }
  }

  void show(float beatFloat) {
    beatFloat = map(beatFloat, 0, 1000, 5, 50);
    fill(175, 100);
    ellipse(x, y, beatFloat, beatFloat);       
  }
  
  void connectWalker(Walker[] walkers) {
    //for (Walker walker : walkers) {
    for (int i = 0; i<5; i++) {  
      stroke(255, 50);
      line(x, y, walkers[i].getX(), walkers[i].getY());
    }
  }
}
