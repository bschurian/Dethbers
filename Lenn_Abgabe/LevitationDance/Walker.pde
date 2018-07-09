class Walker { //<>// //<>//
  // ---------- variables  ---------- //
  float x, y, targetX, targetY, ellipseSize = 5.0, alphaEllipse = 175;
  int connectCounter = 0, connectAmount = 3;

  // ---------- Constructor and getter-methods ---------- //
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
  void addConnectCounter(int c) {
    connectCounter = connectCounter+c;
  }
  int getConnectCounter() {
    return connectCounter;
  }

  // ---------- BEATWALK: Move random and large steps  ---------- //
  void beatWalk() {
    targetX = x+random(-width/2, width/2);
    targetY = y+random(-height/2, height/2);

    if (targetX < 0 || targetX > width || targetY < 0 || targetY > height ) {
      beatWalk();
    } else {
      // move smoothly to target positon
      x = lerp(x, targetX, 0.1);
      y = lerp(y, targetY, 0.1);
    }
  }

  // ---------- WALK: Move little steps by no Beat ---------- //
  void walk() {    
    targetX = x+random(-10, 10);
    targetY = y+random(-10, 10);   

    if (targetX < 0 || targetX > width || targetY < 0 || targetY > height) {
      walk();
    } else {
      // move smoothly to target position
      x = lerp(x, targetX, 0.1);
      y = lerp(y, targetY, 0.1);
    }
  }

  // ---------- Display an ellipse and change radius by beat recognition ---------- //
  void show(float beatFloat) {
    beatFloat = map(beatFloat, 0, 1000, 5, 50);
    fill(200, alphaEllipse);
    ellipse(x, y, beatFloat, beatFloat);
  }


  // -----  Connecting dots ------- //
  void connectWalker(Walker[] walkers) {
    stroke(175, 50);
    for (int i = 0; i< 3; i++) {
      line(x, y, walkers[i].getX(), walkers[i].getY());
    }
  }
}
