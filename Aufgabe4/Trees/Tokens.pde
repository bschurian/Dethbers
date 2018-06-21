/*
 * These tokens are used by the production system to control the turtle.
 * Feel free to add additional tokens.
 */


// Provides tokens with a call() method
abstract class Token {
  public abstract void call(final Turtle turtle);
}

// This token will be replaced in production system
class A extends Token {

  private float s, w;

  public A(float s, float w) {
    this.s = s;
    this.w = w;
  }

  public float s() {
    return this.s;
  }

  public void s(float s) {
    this.s = s;
  }

  public float w() {
    return this.w;
  }

  public void w(float w) {
    this.w = w;
  }

  public void call(final Turtle turtle) {
  }

  public String toString() {
    return "A("+this.s+", "+this.w+")";
  }
}

// Changes branch "thickness"
class Weight extends Token {

  private float w;

  public Weight(float w) {
    this.w = w;
  }

  public float w() {
    return this.w;
  }

  public void w(float w) {
    this.w = w;
  }

  public void call(final Turtle turtle) {
    turtle.weight(w);
  }

  public String toString() {
    return "!("+this.w+")";
  }
}

// Changes branch colour
class Colour extends Token {

  private int c;

  public Colour(int c) {
    this.c = c;
  }

  public int c() {
    return this.c;
  }

  public void c(int c) {
    this.c = c;
  }

  public void call(final Turtle turtle) {
    turtle.colour(c);
  }

  public String toString() {
    return "C("+this.c+")";
  }
}

// Creates a branch
class Forward extends Token {

  private float s;

  public Forward(float s) {
    this.s = s;
  }

  public float s() {
    return s;
  }

  public void s(float s) {
    this.s = s;
  }

  public void call(final Turtle turtle) {
    turtle.forward(s);
  }
  public String toString() {
    return "F("+this.s+")";
  }
}

// Turns the turtle
class Turn extends Token {

  private float a;

  public Turn(float angle) {
    a = angle;
  }

  public float a() {
    return a;
  }

  public void a(float angle) {
    a = angle;
  }

  public void call(final Turtle turtle) {
    turtle.turnLeft(a);
  }
  public String toString() {
    return "+("+this.a+")";
  }
}

// Rolls the turtle
class Roll extends Token {

  private float a;

  public Roll(float angle) {
    a = angle;
  }

  public float a() {
    return a;
  }

  public void a(float angle) {
    a = angle;
  }

  public void call(final Turtle turtle) {
    turtle.rollLeft(a);
  }
  public String toString() {
    return "/("+this.a+")";
  }
}

//Creates an Apple
class Apple extends Token {

  private float r;

  public Apple(float radius) {
    r = radius;
  }

  public float r() {
    return r;
  }

  public void r(float radius) {
    r = radius;
  }

  public void call() {
    turtle.apple(r);
  }
}


// Remember current coordinate system
class Push extends Token {
  public void call(final Turtle turtle) {
    turtle.push();
  }
  public String toString() {
    return "[";
  }
}

// Restore current coordinate system
class Pop extends Token {
  public void call(final Turtle turtle) {
    turtle.pop();
  }
  public String toString() {
    return "]";
  }
}
