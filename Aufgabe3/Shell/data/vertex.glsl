#define PROCESSING_LIGHT_SHADER

uniform mat4 modelview;
uniform mat4 transform;
uniform mat3 normalMatrix;

uniform vec3 lightNormal[8];

in vec4 specular;
in float shininess;
uniform float plasmaratio;
uniform float plasmazoomout;

in vec4 position;
in vec3 normal;
in vec2 texCoord;

out vec2 UV;

out vec3 normal_;
out vec3 light_;
out vec3 camera_;
out vec4 position_;

out vec4 specular_;
out float shininess_;
out float plasmaratio_;
out float plasmazoomout_;

void main() {


  gl_Position = transform * position;
  
  UV = texCoord;
  
  normal_ = normalMatrix * normal;
  //normal_ = normal;
  light_ = -lightNormal[1];
  //light_ = -vec3(0,1,0);
  camera_ = normalize(-vec3(modelview * position));
  position_ = position;

  specular_ = specular;
  shininess_ = shininess;
  plasmaratio_ = plasmaratio;
  plasmazoomout_ = plasmazoomout;
}
