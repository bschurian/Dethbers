// Material properties
uniform vec3 color;

uniform vec3 lightAmbient[8];
uniform vec3 lightDiffuse[8];
uniform vec3 lightSpecular[8];

in vec2 UV;

in vec4 specular_;
in float shininess_;

in vec3 normal_;  //n
in vec3 light_;  //l
in vec3 camera_;    //e
in vec4 position_;  //r ?



//Add von Tim

void main() {

  // Receives directional light?
  //Normalize light
  vec3 l = normalize(light_);
  vec3 e = normalize(camera_);
  vec3 n = normalize(normal_);

  vec3 ambient = vec3(0);
  vec3 diffuse = vec3(0);
  vec3 specular = vec3(0);

  // Ambient light
  ambient = lightAmbient[0];  //ambient

  float diffuseIntensity = dot(n, l);
  if (diffuseIntensity > 0.0) {
    diffuse = lightDiffuse[1] * diffuseIntensity;
  }
  
  vec3 r = normalize(reflect(l, n));
  float specularIntensity = pow(max( dot(r,-e), 0.0), shininess_);
  specular = lightSpecular[1] * specularIntensity;

  vec3 objectColor = (ambient + diffuse + specular) * color;
  
  //gl_FragColor = vec4(objectColor, 1.0);
  gl_FragColor = vec4(UV.x, UV.y, 0, 1.0);
}
