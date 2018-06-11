#define PROCESSING_LIGHT_SHADER

uniform mat4 modelview;
uniform mat4 transform;
uniform mat3 normalMatrix;

uniform vec3 lightNormal[8];

in vec4 specular;
in float shininess;

in vec4 position;
in vec3 normal;

out vec3 normal_;
out vec3 light_;
out vec3 camera_;
out vec4 position_;

out vec4 specular_;
out float shininess_;

void main() {
  gl_Position = transform * position;
  normal_ = normalMatrix * normal;
  //normal_ = normal;
  light_ = -lightNormal[1];
  //light_ = -vec3(0,1,0);
  camera_ = normalize(-vec3(modelview * position));
  position_ = position;

  specular_ = specular;
  shininess_ = shininess;
}
