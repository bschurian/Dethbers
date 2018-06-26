
// Supplied by Processing
uniform mat4 transform;
uniform mat4 modelview;
uniform mat3 normalMatrix;
uniform vec4 baseColor;

uniform vec3 lightNormal[];

// Calculated by update() method in the sketch
uniform mat4 shadowTransform;
uniform mat4 shadowTransform2;

// Supplied by Processing
in vec4 vertex; // position in model coordinates
//in vec4 color;  // color of the vertex
in vec3 normal; // vertex normal

// We do calculate these
//out vec4 color_;  // vertex color
out float lambert; // The "lambert term" - angle between light source and surface normal
out vec4 shadowMapCoordinates; //
out vec4 shadowMapCoordinates2; //


void main() {

    gl_Position = transform * vertex;

    vec3 n = normalize(normalMatrix * normal);// Get normal direction in model view space

    vec4 v = modelview * vertex;// Get vertex position in model view space
    v += vec4(n, 0.0);  // Apply normal bias removes "shadow acne"

    //color_ = color;
    shadowMapCoordinates = shadowTransform * v;
    shadowMapCoordinates2 = shadowTransform2 * v;
    //lambert = dot(-lightDirection, n);
    lambert = dot(n, lightNormal[0])*0.5+dot(n, lightNormal[1])*0.5;
}
