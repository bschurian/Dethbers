
// Material properties
uniform vec3 color;

uniform vec3 lightAmbient[8];
uniform vec3 lightDiffuse[8];
uniform vec3 lightSpecular[8];

in vec4 specular_;
in float shininess_;

in vec3 normal_;
in vec3 light_;
in vec3 camera_;
in vec4 position_;

void main() {

  // Ambient light
  vec3 objectColor = lightAmbient[0] * color;

  // Receives directional light?
  vec3 n = normalize(normal_);
  float diffuseIntensity = dot(n, light_);
  if (diffuseIntensity > 0.0) {

    // Diffuse light
    objectColor += lightDiffuse[1] * diffuseIntensity * color;
  }

  gl_FragColor = vec4(objectColor, 1.0);
}
