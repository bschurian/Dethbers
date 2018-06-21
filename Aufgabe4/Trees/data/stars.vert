
// Supplied by Processing
uniform mat4 transform;
uniform mat4 modelview;
uniform mat3 normalMatrix;


// Supplied by Processing
in vec4 vertex; // position in model coordinates
//in vec4 color;  // color of the vertex
in vec3 normal; // vertex normal
in vec2 texCoord;

out vec2 UV;

// We do calculate these
out vec4 color_;  // vertex color



void main() {

    gl_Position = transform * vertex;

    vec3 n = normalize(normalMatrix * normal);// Get normal direction in model view space

    vec4 v = modelview * vertex;// Get vertex position in model view space
    v += vec4(n, 0.0);  // Apply normal bias removes "shadow acne"

  //  color_ = color;

    UV = texCoord;

}
