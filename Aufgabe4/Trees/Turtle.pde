import java.util.Stack;

/*
 * This turtle creates a single root PShape with many children (Basically a VBO), which gets pushed to the GPU
 * in the draw() call. It keeps its own a stack of coordinate system matrices, separate from processing.
 * Feel free to add additional features to the turtle.
 */
class Turtle {

  private float weight; // The "thickness" of a single branch (cylinder)
  private int colour;   // The branche'S colour

  private PMatrix3D coords = new PMatrix3D();  // Current coordinate system
  private Stack<PMatrix3D> stack = new Stack<PMatrix3D>(); // Stack of former coordinate systems

  private PShape root; // The PShape where all children are added to
  private PShape fruits; 
  // Never construct a turtle before setup()
  public Turtle() {
    reset();
  }

  // Set everything to default values.
  public void reset() {
    this.weight = 1.0;
    this.colour = color(255);
    stack.clear();
    coords.reset();
    root = createShape(GROUP);  // this will fail if sketch is not properly set up yet
    fruits = createShape(GROUP);
    // z Axis shows upwards
    coords.rotateX(HALF_PI); // This is an arbitrary initial orientation
  }

  // Draws a single branch a a cylinder
  public void forward(float length) {

    final int sides = 24;
    final float r = weight / 2.0;
    final float angle = TWO_PI / sides;

    PShape segment = createShape(GROUP);
    segment.applyMatrix(coords); 

    // Create bottom shape
    PShape bottom = createShape();
    bottom.setFill(colour);
    bottom.beginShape();
    for (int i = 0; i < sides; ++i) {
      float x = cos(i * angle) * r;
      float y = sin(i * angle) * r;
      bottom.vertex(x, y, 0, ((float)i)/sides, 0);
    }
    bottom.endShape(CLOSE);
    segment.addChild(bottom);

    // Create top shape
    PShape top = createShape();
    top.setFill(colour);
    top.beginShape();
    for (int i = 0; i < sides; ++i) {
      float x = cos(i * angle) * r;
      float y = sin(i * angle) * r;
      top.vertex(x, y, length, ((float)i)/sides, 1);
    }
    top.endShape(CLOSE);
    segment.addChild(top);

    // Create hull
    PShape hull = createShape();
    hull.setFill(colour);
    hull.beginShape(TRIANGLE_STRIP);
    for (int i = 0; i < sides + 1; ++i) {
      float x = cos(i * angle) * r;
      float y = sin(i * angle) * r;
      hull.vertex(x, y, length, ((float)i)/sides, 1);
      hull.vertex(x, y, 0, ((float)i)/sides, 0);
    }
    hull.endShape(CLOSE);
    segment.addChild(hull);

    root.addChild(segment);

    coords.translate(0, 0, length);
  }

  // Rotation. Angles are in radians
  public void turnLeft(float angle) {
    coords.rotateY(angle);
  }
  public void turnRight(float angle) {
    coords.rotateY(-angle);
  }
  public void pitchDown(float angle) {
    coords.rotateX(angle);
  }
  public void pitchUp(float angle) {
    coords.rotateX(-angle);
  }
  public void rollLeft(float angle) {
    coords.rotateZ(angle);
  }
  public void rollRight(float angle) {
    coords.rotateZ(-angle);
  }
  public void turnAround() {
    turnLeft(PI);
  }

  // Parametric setters
  public void colour(int colour) {
    this.colour = colour;
  }
  public void weight(float weight) {
    this.weight = weight;
  }

  //Apple
  public void apple(float r) {

    PShape apple = createShape(SPHERE, r);
    apple.applyMatrix(coords); 
    fruits.addChild(apple);
  }


  // Stores current coordinate system in stack
  void push() {
    stack.push(new PMatrix3D(coords));
  }

  // Restores current coordinate system from stack
  void pop() {
    coords = stack.pop();
  }

  // Pushes to GPU
  void draw(PGraphics canvas) {
    root.draw(canvas);
  }

  //Fruits
  void fruitDraw(PGraphics canvas) {
    fruits.draw(canvas);
  }
}
