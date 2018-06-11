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

  // Receives directional light?
  //Normalize light
  vec3 l = normalize(light_);
  vec3 e = normalize(camera_);
  vec3 n = normalize(normal_);

  vec3 ambient = vec3(0);
  vec3 diffuse = vec3(0);
  vec3 specular = vec3(0);

  // Ambient light
  ambient = lightAmbient[0] * color;  //ambient

  float diffuseIntensity = dot(n, l);
  if (diffuseIntensity > 0.0) {
    diffuse = lightDiffuse[1] * diffuseIntensity * color;
  }
  
  vec3 r = normalize(reflect(l, n));
  float specularIntensity = pow(max( dot(r,-e), 0.0), shininess_);
  specular = lightSpecular[1] * specularIntensity * color;

  vec3 objectColor = ambient + diffuse + specular;

  //gl_FragColor = vec4(specularIntensity,0,0, 1.0);
  //gl_FragColor = vec4(l, 1.0);
  //gl_FragColor = vec4(lightSpecular[1] * specularIntensity, 1.0);
  gl_FragColor = vec4(objectColor, 1.0);
}
