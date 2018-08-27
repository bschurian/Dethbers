#version 410

uniform mat4 transformMatrix;
uniform mat4 modelviewMatrix;
uniform mat4 viewMatrix;
uniform mat3 normalMatrix;

uniform vec3 lightPosition;

in vec4 position;
in vec3 normal;
in vec4 color;

out vec3 camera;
out vec3 normal_;
out vec3 light;
out vec3 positionInModel;

out vec4 materialColor;

void main( void ) {

    positionInModel = vec3(position);

    // Project the vertex
    gl_Position = transformMatrix * position;

    // Direction of camera from vertex in view space
    vec3 position = vec3(modelviewMatrix * position);
    camera = normalize(-position); // Camera is at origin of view space

    // Normal of vertex in view space
    normal_ = normalize(normalMatrix * normal);

    // Direction of light source (sun) in view space
    vec4 lightPositionInView = viewMatrix * vec4(lightPosition, 0.0);
    light = normalize(vec3(lightPositionInView.xyz) - position);

    // Color of the vertex
    materialColor = color;
}
