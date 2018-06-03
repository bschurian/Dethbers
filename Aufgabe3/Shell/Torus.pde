
import java.util.*;

class Torus {

  // Parameters
  private int segments;
  private float radius;
  private PShape shape;
  private float alpha;
  private float z0;
  private float turns;

  // Stores geometry
  Vector<PVector> vertex;
  Vector<PVector> vertexNormal;
  Vector<Integer[]> face;  // quads (four indices per face)

  // Used for lazy generation of geometry
  private boolean dirty;
  PShape geometry;

  public Torus() {
    // Default values
    segments = 100;
    radius = 2  ;
    turns = 2;
    alpha = PI/6;
    z0 = alpha*2;
    shape = createShape(ELLIPSE, 0, 0, 1, 1);
    geometry = new PShape();
    dirty = true;
  }

  // TODO: This is different for a shell
  // Eidt: 30.05.18
  private PVector position(float t) {

    float e = pow(exp(1), alpha*t);
    PVector result = (new PVector(
      radius * cos(t), 
      radius * sin(t), 
      z0
      ));
    return result.mult(e);
  }

  // TODO: This is different for a shell 
  // Eidt: 30.05.18
  private PVector derivate1(float t) {
    float e = pow(exp(1.0), alpha*t); 

    return (new PVector( 
      radius * (alpha *cos(t)-sin(t)), 
      radius * (alpha *sin(t) + cos(t)), 
      z0*alpha
      )).mult(e);
  }

  // TODO: This is different for a shell
  // Eidt: 30.05.18
  private PVector derivate2(float t) {
    float e = pow(exp(1.0), alpha*t); 
    return new PVector( 
      radius*((pow(alpha, 2)- 1) *cos(t) - 2*alpha * sin(t)), 
      radius*((pow(alpha, 2) -1) * sin(t)+ 2* alpha* cos(t)), 
      z0*pow(alpha, 2)
      ).mult(e);
  }

  private PMatrix3D frenet(float t) {

    // Translate
    PMatrix3D matrix = new PMatrix3D();

    // Scale
    final PVector pos = position(t);
    matrix.translate(pos.x, pos.y, pos.z);

    // Rotate
    final PVector e0 = derivate1(t).normalize();
    final PVector e2 = e0.cross(derivate2(t)).normalize();
    final PVector e1 = e2.cross(e0);
    matrix.apply(
      e2.x, e1.x, e0.x, 0, 
      e2.y, e1.y, e0.y, 0, 
      e2.z, e1.z, e0.z, 0, 
      0, 0, 0, 1
      );

    //final float f = 1.0 + sin(8.0 * t) / 5.0;  // TODO: This is different for a shell
    final float f = pow(exp(1.0), alpha*t);  // Edit: 30.05.18
    matrix.scale(f, f, f);



    return matrix;
  }


  //// TODO: This is different for a shell
  //private PVector position(float t) {
  //  return new PVector(
  //    radius * cos(t), 
  //    radius * sin(t), 
  //    0
  //    );
  //}

  //// TODO: This is different for a shell
  //private PVector derivate1(float t) {
  //  return new PVector(
  //    - radius * sin(t), 
  //    radius * cos(t), 
  //    0
  //    );
  //}

  //// TODO: This is different for a shell
  //private PVector derivate2(float t) {
  //  return new PVector(
  //    - radius * cos(t), 
  //    - radius * sin(t), 
  //    0
  //    );
  //}

  //private PMatrix3D frenet(float t) {

  //  // Translate
  //  PMatrix3D matrix = new PMatrix3D();
  //  final PVector pos = position(t);
  //  matrix.translate(pos.x, pos.y, pos.z);

  //  // Rotate
  //  final PVector e0 = derivate1(t).normalize();
  //  final PVector e2 = e0.cross(derivate2(t)).normalize();
  //  final PVector e1 = e2.cross(e0);
  //  matrix.apply(
  //    e2.x, e1.x, e0.x, 0, 
  //    e2.y, e1.y, e0.y, 0, 
  //    e2.z, e1.z, e0.z, 0, 
  //    0, 0, 0, 1
  //    );

  //  // Scale
  //  final float f = 1.0 + sin(8.0 * t) / 5.0;  // TODO: This is different for a shell
  //  matrix.scale(f, f, f);

  //  return matrix;
  //}


  private void extrudeVertices() {

    // These need to be filled
    vertex = new Vector<PVector>();
    vertexNormal = new Vector<PVector>();

    // Go along the path and subdivide it into rings. Use the position() method to do this.
    // For each ring, take each shape vertex and transform it into model coordinates by using the frenet matrix.
    // Hint: When looping over the shape vertices, use only use shape vertices with a vertex code of "VERTEX"

    for (int i = 1; i <= segments; i++) {
      float t = float(i)/segments * turns * 2*PI; 
      PVector pos = position(t);

      //DEBUG: Path-only
      //vertex.add(pos);
      //vertexNormal.add(pos);

      PMatrix3D fre = frenet(t);
      for (int j = 0; j< shape.getVertexCount()-1; j++) {// For each ring,  
        PVector v = shape.getVertex(j); // take each shape vertex
        if (shape.getVertexCode(j) == VERTEX) {
          PVector modelV = new PVector(); // and transform it into model coordinates by using the frenet matrix.
          fre.mult(v, modelV);
          // Store each final vertex position in the given vector and calculate it's normal. Store the normal, too. 
          vertex.add(modelV);
          vertexNormal.add(v.sub(pos).normalize());
        }
      }
    }
  }

  private void constructHull() {

    // This needs to be filled
    face = new Vector<Integer[]>();

    //Create quads (four-sided polygons) for each segment between two rings.
    //Save each quad into the face vector.
    //Hint: Front facing polygons are in CCW vertex order (openGL default)

    int shapeVCount = vertex.size()/segments;
    for (int seg = 0; seg < segments - 1; seg++) {
      int segOffset = seg*shapeVCount;
      for (int j = 0; j <  shapeVCount; j++) {
        Integer[] faceVerts = new Integer[]{          
          segOffset + (j % shapeVCount), 
          segOffset + ((j + 1) % shapeVCount), 
          segOffset + shapeVCount + ((j + 1) % shapeVCount), 
          segOffset + shapeVCount + (j % shapeVCount)};
        face.add(faceVerts);
      }
    }
    //DEBUG: Parh-only
    //for (int s = 0; s< segments/4; s++) {
    //  int sI = 4*s;
    //  face.add(new Integer[]{sI+0, sI+1, sI+3, sI+2});
    //}
  }

  private void create() {

    // Create Geometry
    extrudeVertices();
    constructHull();

    // Create a PShape from geometry
    geometry = createShape();
    geometry.beginShape(QUADS);
    for (int i = 0; i < face.size(); ++i) {
      final Integer[] quad = face.get(i);
      for (int j=0; j < 4; ++j) {
        final PVector n = vertexNormal.get(quad[j]);
        geometry.normal(n.x, n.y, n.z);
        final PVector v = vertex.get(quad[j]);
        geometry.vertex(v.x, v.y, v.z);
      }
    }    
    geometry.endShape();

    dirty = false;
  }

  public  int segments() { 
    return segments;
  }

  public Torus segments(int segments) { 
    this.segments = segments; 
    dirty = true;
    return this;
  }

  public float turns() { 
    return turns;
  }

  public Torus turns(float turns) { 
    this.turns = turns; 
    this.alpha = PI/(12*turns);
    dirty = true;
    return this;
  }

  public float radius() { 
    return radius;
  }

  public Torus radius(float radius) { 
    this.radius = radius;
    dirty = true;
    return this;
  }

  public PShape shape() { 
    return shape;
  }

  public Torus shape(PShape shape) {
    this.shape = shape; 
    dirty = true;
    return this;
  }

  public PShape geometry() { 
    if (dirty) create();
    return geometry;
  }
}
