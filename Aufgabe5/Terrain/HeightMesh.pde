import static java.util.Collections.nCopies;

// Uses a height field to create a terrain mesh
abstract class HeightMesh extends Mesh {

  // The height map
  private float height[][];
  private PImage heightMap;

  // Range of height values in current height map
  private float heightMin;
  private float heightMax;

  // Properties
  private float scale;        // Defines mapping of height field values to mesh vertex height
  private int subdivisions;   // Number of subdivisions per segment of the grid
  private int mapSize;        // Number of vertices in one grid dimension. Hast to be power of 2 plus 1.
  private float meshWidth;    // The size of the final mesh in x direction
  private float meshHeight;   // The size of the final mesh in y direction

  public HeightMesh() {
    super();
    this.mapSize = 17;
    scale = 25;
    subdivisions = 0;
    meshWidth = meshHeight = 50;
    height = new float[mapSize][mapSize];
    heightMap = new PImage(mapSize, mapSize);
    heightMin = heightMax = 0;
  }

  // Catmull-Rom spline interpolator from http://www.paulinternet.nl/?page=bicubic
  private float cubicInterpolate(float p0, float p1, float p2, float p3, float t) {
    return p1 + 0.5f * t * (p2 - p0 + t * (2 * p0 - 5 * p1 + 4 * p2 - p3 + t * ( 3 * (p1 - p2 ) + p3 - p0)));
  }

  // Retrives a value from the height map
  // Returns the height value, or 0 in case of out-of-bounds access
  protected float get(int x, int y) {
    if ((x < 0) || (x >= mapSize) || (y < 0) || (y >= mapSize)) return 0;
    else return height[y][x];
  }

  // Retrieves a value from the height map using bicubic interpolation
  protected float get(float x, float y) {
    if ((x < 0) || (x >= mapSize) || (y < 0) || (y >= mapSize)) return 0;
    int ox = floor(x) - 1;
    int oy = floor(y) - 1;
    float x0 = cubicInterpolate(get(ox + 0, oy + 0), get(ox + 1, oy + 0), get(ox + 2, oy + 0), get(ox + 3, oy + 0), x%1);  
    float x1 = cubicInterpolate(get(ox + 0, oy + 1), get(ox + 1, oy + 1), get(ox + 2, oy + 1), get(ox + 3, oy + 1), x%1);
    float x2 = cubicInterpolate(get(ox + 0, oy + 2), get(ox + 1, oy + 2), get(ox + 2, oy + 2), get(ox + 3, oy + 2), x%1);
    float x3 = cubicInterpolate(get(ox + 0, oy + 3), get(ox + 1, oy + 3), get(ox + 2, oy + 3), get(ox + 3, oy + 3), x%1);
    return cubicInterpolate(x0, x1, x2, x3, y%1);
  }

  // Store a value in the heigth map
  // Out-of-bounds access is ignored.
  protected void set(int x, int y, float value) {
    if ((x < 0) || (x >= mapSize) || (y < 0) || (y >= mapSize)) return;
    height[y][x] = value;
    if (value < heightMin) heightMin = value;
    if (value > heightMax) heightMax = value;
  }

  protected int numberOfVerticesPerSide() {
    return mapSize + (mapSize - 1) * subdivisions;
  }

  // Provided by sub classs.
  // Used to create height field
  protected abstract void calculateHeightField();

  private void calculateVertices() {

    // Setup some interim values for re-use
    float stepX = meshWidth / (float)(numberOfVerticesPerSide() - 1);
    float stepY = meshHeight / (float)(numberOfVerticesPerSide() - 1);
    float originX = meshWidth / 2.0f;
    float originY = meshHeight / 2.0f;

    // Construct vertices and colors
    for (float y = 0; y < numberOfVerticesPerSide(); ++y) {
      for (float x = 0; x < numberOfVerticesPerSide(); ++x) {

        // Vertex position
        float vx = x * stepX - originX;
        float vy = y * stepY - originY;
        float px = x / (float)(subdivisions + 1);
        float py = y / (float)(subdivisions + 1);
        final float h = get(px, py);
        PVector result = new PVector(vx, vy, h * scale);
        vertices.add(result);

        // Vertex color
        // Height dependent rainbows :)
        colorMode(HSB, 360, 100, 100);
        final float c = map(h, heightMin, heightMax, 0, 360);
        vertexColors.add(color(c, 100, 100));
        colorMode(RGB, 255);
      }
    }
  }

  private void calculateTriangles() {

    // Construct faces 
    // v1--v2  v1--v2
    // | \  |  |  / |    (Alternate between these for each column grid cell, also alternate starting shape with each row)
    // |  \ |  | /  |
    // v3--v4  v3--v4

    boolean top_left_to_bottom_right = true;
    for (int y = 0; y < numberOfVerticesPerSide() - 1; ++y) {
      for (int x = 0; x < numberOfVerticesPerSide() - 1; ++x) {
        // CCW Triangles
        final int v1 = y * numberOfVerticesPerSide() + x;
        final int v2 = v1 + 1;
        final int v3 = v1 + numberOfVerticesPerSide();
        final int v4 = v3 + 1;
        if (top_left_to_bottom_right) {
          addTriangle(v1, v4, v3);
          addTriangle(v1, v2, v4);
        } else {
          addTriangle(v2, v3, v1);
          addTriangle(v2, v4, v3);
        }
        top_left_to_bottom_right = !top_left_to_bottom_right; // Alternate for column
      }
      top_left_to_bottom_right = !top_left_to_bottom_right; // Alternate for row
    }
  }

  private void calculateVertexNormals() {

    final Vector<PVector> faceNormals = new Vector<PVector>();
    for (int i = 0; i < vertices.size(); ++i) faceNormals.add(new PVector());
    final Vector<Integer> adjacencies = new Vector<Integer>();
    for (int i = 0; i < vertices.size(); ++i) adjacencies.add(0);

    // Accumulate all face normals per vertex
    for (int i=0; i < triangles.size(); ++i) {

      final Integer[] triangle = triangles.get(i);

      // Calculate face normal
      final PVector v1 = PVector.sub(vertices.get(triangle[0]), vertices.get(triangle[1]));
      final PVector v2 = PVector.sub(vertices.get(triangle[0]), vertices.get(triangle[2]));
      final PVector n = new PVector();
      PVector.cross(v1, v2, n);
      n.normalize();

      // Accumulate face normals for each vertex
      faceNormals.get(triangle[0]).add(n);
      faceNormals.get(triangle[1]).add(n);
      faceNormals.get(triangle[2]).add(n);

      // Count how many faces each vertex is adjacent to
      adjacencies.set(triangle[0], adjacencies.get(triangle[0]) + 1);
      adjacencies.set(triangle[1], adjacencies.get(triangle[1]) + 1);
      adjacencies.set(triangle[2], adjacencies.get(triangle[2]) + 1);
    }

    // Average face normals and store as vertex normal
    for (int i = 0; i < faceNormals.size(); ++i) {
      faceNormals.get(i).div(adjacencies.get(i));
      vertexNormals.add(faceNormals.get(i));
    }
  }

  private void updateHeightMap() {
    heightMap.loadPixels();
    for (int y = 0; y < mapSize; ++y) {
      for (int x = 0; x < mapSize; ++x) {
        final int c = round(map(height[y][x], -1, 1, 0, 255));  // Mapping range [-1, 1] to color values
        heightMap.pixels[y * mapSize + x] = color(c, c, c, 255);  
      }
    }
    heightMap.updatePixels();
  }

  // Create mesh data
  protected void create() {
    heightMin = heightMax = 0;
    calculateHeightField();
    updateHeightMap();
    calculateVertices();
    calculateTriangles();
    calculateVertexNormals();
  }


  // Properties

  public int mapSize() { 
    return mapSize;
  }
  public HeightMesh mapSize(int s) { 
    this.mapSize = s;
    height = new float[mapSize][mapSize];
    heightMap = new PImage(mapSize, mapSize);
    markAsDirty();
    return this;
  }

  public float scale() { 
    return scale;
  }
  public HeightMesh scale(float s) { 
    scale = s; 
    markAsDirty();
    return this;
  }

  public int subdivisions() { 
    return subdivisions;
  }
  public HeightMesh subdivisions(int s) { 
    if (s >= 0) {
      subdivisions = s;
      markAsDirty();
    } else throw new IllegalArgumentException("Number of subdivision has to be a positive number");
    return this;
  }

  public float width() { 
    return meshWidth;
  }
  public float height() { 
    return meshHeight;
  }
  public HeightMesh size(float width, float height) { 
    meshWidth = width;
    meshHeight = height;
    markAsDirty();
    return this;
  }

  // Get the height field as a texture. Useful for debugging
  public PImage heightMap() {
    return heightMap;
  }

  // Prints the height field to the console
  public void dump() {
    for (int y = 0; y < mapSize; ++y) {
      for (int x = 0; x < mapSize; ++x)
        print(nf(get(x, y), 1, 2) + " ");
      println();
    }
  }
}
