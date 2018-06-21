/*
 * Configurations for different kind of trees.
 * Reflects Table 1 in "L-systems: from the Theory to Visual Models of Plants" by Prusinkiewicz et al.
 */
class Configuration {

  public float r1, r2, a1, a2, fi1, fi2, om0, q, e, min;
  public int n;

  Configuration(float r1, float r2, float a1, float a2, float fi1, float fi2, float om0, float q, float e, float min, int n) {
    this.r1 = r1;
    this.r2 = r2;
    this.a1 = a1;
    this.a2 = a2;
    this.fi1 = fi1;
    this.fi2 = fi2;
    this.om0 = om0;
    this.q = q;
    this.e = e;
    this.min = min;
    this.n = n;
  }

  // Init with a random configuration, controlled by seed value
  Configuration(int seed) {
    randomSeed(seed);
    println("Configuration seed is " + seed);
    this.r1 = random(0.2f, 1.0f);
    this.r2 = random(0.2f, 1.0f);
    this.a1 = random(-HALF_PI, HALF_PI);
    this.a2 = random(-HALF_PI, HALF_PI);
    this.fi1 = random(-PI, PI);
    this.fi2 = random(-PI, PI);
    this.om0 = random(0.0f, 50.0f);
    this.q = random(0.40f, 0.60f);
    this.e = random(0.0f, 0.50f);
    this.min = random(0.0f, 0.30f);
    this.n = int(random(8, 15)); // Some of these can get large (!) - you may run out of heap space
  }
}

//final Configuration config_a = new Configuration(0.75f, 0.77f, 0.5759586532f, -0.5759586532f, 0.0f, 0.0f, 30.0f, 0.50f, 0.40f, 0.0f, 10);
//final Configuration config_b = new Configuration(0.65f, 0.71f, 0.471238898f, -1.1868238914f, 0.0f, 0.0f, 20.0f, 0.53f, 0.50f, 1.7f, 12);
//final Configuration config_c = new Configuration(0.50f, 0.85f, 0.436332313f, -0.2617993878f, PI, 0.0f, 20.0f, 0.45f, 0.50f, 0.5f, 9);
//final Configuration config_d = new Configuration(0.60f, 0.85f, 0.436332313f, -0.2617993878f, PI, PI, 20.0f, 0.45f, 0.50f, 0.0f, 10);
//final Configuration config_e = new Configuration(0.58f, 0.83f, 0.5235987756f, 0.2617993878f, 0.0f, PI, 20.0f, 0.40f, 0.50f, 1.0f, 11);
//final Configuration config_f = new Configuration(0.92f, 0.37f, 0.0f, 1.0471975512f, PI, 0.0f, 2.0f, 0.50f, 0.0f, 0.5f, 15);
//final Configuration config_g = new Configuration(0.8f, 0.8f, 0.5235987756f, -0.5235987756f, 2.3911010752f, 2.3911010752f, 30.0f, 0.5f, 0.5f, 0.0f, 10);
//final Configuration config_h = new Configuration(0.95f, 0.75f, 0.0872664626f, -0.5235987756f, -HALF_PI, HALF_PI, 40.0f, 0.60f, 0.45f, 25.0f, 12);
//final Configuration config_i = new Configuration(0.55f, 0.95f, -0.0872664626f, 0.5235987756f, 2.3911010752f, 2.3911010752f, 5.0f, 0.40f, 0.0f, 5.0f, 12);

//// The current configuration
//Configuration config = config_g;  // Default is a nice 3D tree
