// Material properties
uniform vec3 color;

uniform vec3 lightAmbient[8];
uniform vec3 lightDiffuse[8];
uniform vec3 lightSpecular[8];

in vec4 specular_;
in float shininess_;


in vec3 normal_;  //n
in vec3 light_;  //l
in vec3 camera_;    //e
in vec4 position_;  //r ?



//Add von Tim
void main() {

  // Ambient light
  vec3 objectColor = lightAmbient[0] * color;  //ambient

  // Receives directional light?
  //Normalize light
  vec3 l = normalize(light_);
  vec3 e = normalize(camera_);
  vec3 n = normalize(normal_);
  vec3 h = normalize(e+l);

  vec3 diffuse = vec3(0);
  vec3 specular = vec3(0);
  vec3 ambient = vec3(0);


  float shininess = pow(dot(n, h));

  objectColor += lightSpecular[1] * shininess * color;

  float diffuseIntensity = dot(n, light_);
  if (diffuseIntensity > 0.0) {

    // Diffuse light
    objectColor += lightDiffuse[1] * diffuseIntensity * color;
  }


  gl_FragColor = vec4(normal_, 1.0);
}
