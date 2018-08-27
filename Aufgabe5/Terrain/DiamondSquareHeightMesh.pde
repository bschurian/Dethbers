 //<>//
// Creates a height mesh unsing a variant of the diamon-square algorithm
class DiamondSquareHeightMesh extends HeightMesh {

  // Overall "harshness" of the height map
  private float harshness;
  
  // Random seed -> defines terrain shape
  private int seed;

  public DiamondSquareHeightMesh() {
    super();
    harshness = 0.5;
    seed = millis();
  }

  // Calculate log2 for integers
  private int log2(int x) {
    return floor(log(x) / log(2));
  }

  // This fills the two dimensional height field defined in base class using the diamond-square algorithm.
  // Use only get() and set() to access the field. 
  // mapSize() gives size of one field dimension.
  protected void calculateHeightField() {

    // TODO: Code the diamond-square algorithm
    
  }

  // Properties

  public float harshness() { 
    return harshness;
  }
  public DiamondSquareHeightMesh harshness(float h) { 
    harshness = h;
    markAsDirty();
    return this;
  }
  
  public float seed() { 
    return seed;
  }
  public DiamondSquareHeightMesh seed(int s) { 
    seed = s;
    randomSeed(seed);
    markAsDirty();
    return this;
  }

  // HeightMesh Properties - passing through to enable fluent syntax

  public DiamondSquareHeightMesh mapSize(int s) { 
    // This is an easy but stupid way of checking for correct map size
    switch(s) {
    case 3:
    case 5:
    case 9:
    case 17:
    case 33:
    case 65:
    case 129:
    case 257:
    case 513:
    case 1025:
    case 2049:
    case 4097:
      break;
    default:
      throw new IllegalArgumentException("Map size must be a value 2^n + 1 (e.g. 5, 9, 17, 33, ...). Maximum is 4097");
    }
    super.mapSize(s);
    return this;
  }

  public DiamondSquareHeightMesh scale(float s) { 
    super.scale(s);
    return this;
  }

  public DiamondSquareHeightMesh subdivisions(int s) { 
    super.subdivisions(s);
    return this;
  }

  public DiamondSquareHeightMesh size(float width, float height) { 
    super.size(width, height);
    return this;
  }
}
