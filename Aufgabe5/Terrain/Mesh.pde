import java.util.Vector;

// A single mesh consisting of vertices, vertex normals, and triangles
// Represented as a buffered PSHape object

abstract class Mesh {

  private boolean dirty;  // "dirty flag" used to determine when to regenerate geometry
  private PShape geometry;

  // The mesh data
  protected Vector<PVector> vertices;
  protected Vector<Integer> vertexColors;
  protected Vector<PVector> vertexNormals;
  protected Vector<Integer[]> triangles;

  public Mesh() {
    geometry = createShape(GROUP); 
    vertices = new Vector<PVector>();
    vertexColors = new Vector<Integer>();
    vertexNormals = new Vector<PVector>();
    triangles = new Vector<Integer[]>();
    dirty = true;
  }

  // Call to have the mesh regenerate its geometry on next data access 
  public void markAsDirty() {
    dirty = true;
  }

  // Parameters have changend. Mesh will be regenerated
  public boolean isDirty() {
    return dirty;
  }

  protected void addTriangle(int v1, int v2, int v3) {
    Integer[] poly = new Integer[3];
    poly[0] = v1;
    poly[1] = v2;
    poly[2] = v3;
    triangles.add(poly);
  }

  // Provided by sub classs.
  // Used to create vertices, normals, and triangles.
  abstract protected void create();

  // Retreive the mesh as a PShape
  public PShape geometry() {

    // No changes to geometry setup - can use precalculated mesh
    if (!dirty) return geometry;

    // New start. Create fresh mesh data
    vertices.clear();
    vertexColors.clear();
    vertexNormals.clear();
    triangles.clear();
    create();

    // Create a PShape from mesh data
    geometry = createShape();
    geometry.beginShape(TRIANGLES);
    geometry.noStroke();
    //geometry.stroke(255);
    for (int i = 0; i < triangles.size(); ++i) {
      final Integer[] tri = triangles.get(i);
      for (int j=0; j < 3; ++j) {
        final PVector n = vertexNormals.get(tri[j]);
        geometry.normal(n.x, n.y, n.z);
        final int c = vertexColors.get(tri[j]);
        geometry.fill(c);
        final PVector v = vertices.get(tri[j]);
        geometry.vertex(v.x, v.y, v.z);
      }
    }    
    geometry.endShape();

    dirty = false;
    return geometry;
  }

  // Retrieve number of vertices in currrent mesh
  public int numVertices() {
    if (dirty) create();
    return vertices.size();
  }

  // Retrieve number of triangles in currrent mesh
  public int numTriangless() {
    if (dirty) create();
    return triangles.size();
  }

  // Read access to vertices
  public Vector<PVector> vertices() {
    if (dirty) create();
    return vertices;
  }

  // Read access to vertices
  public Vector<Integer> colors() {
    if (dirty) create();
    return vertexColors;
  }

  // Read access to normals
  public Vector<PVector> normals() {
    if (dirty) create();
    return vertexNormals;
  }

  // Read access to triangles
  public Vector<Integer[]> triangles() {
    if (dirty) create();
    return triangles;
  }
}
