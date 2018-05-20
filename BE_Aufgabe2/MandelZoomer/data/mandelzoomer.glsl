#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

//uniform sampler2D texture;

varying vec4 vertColor;
varying vec4 vertTexCoord;

const vec4 lumcoeff = vec4(0.299, 0.587, 0.114, 0);

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

void main() {
  int maxIters = 200;
  //for(){}
  gl_FragColor = vec4(rand(vec2(vertTexCoord)));
}