#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif
 
//uniform sampler2D texture;
uniform float rightBound;
uniform float leftBound;
uniform float upBound;
uniform float downBound;
<<<<<<< HEAD

=======
 
>>>>>>> Ben
varying vec4 vertColor;
varying vec4 vertTexCoord;
 
const vec4 lumcoeff = vec4(0.299, 0.587, 0.114, 0);
 
float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}
 
void main() {
  int maxIters = 200;
  rightBound;
  leftBound;
  upBound;
  downBound;
  float x = vertTexCoord.x;
  float y = vertTexCoord.y;
  float origRe = leftBound + x*abs(leftBound-rightBound);
  float origIm = downBound + y*abs(upBound-downBound);
<<<<<<< HEAD
	float re = origRe;
	float im = origIm;
	bool diverged = false;
	for(int i = 1; i <= maxIters; i++){
	float tempRe = re*re - im*im;
	float tempIm = 2.0*re*im;
	re = tempRe + origRe;
	im = tempIm + origIm;
	if (abs(re*re)+abs(im*im) > 4.0) {
	  diverged = true;
	  float grey = (float(i)/maxIters);
	  gl_FragColor = vec4(grey,grey,grey,1); 
	  break;
	  }
	}
	if(!diverged){
            gl_FragColor = vec4(0,0,0,1);
	}
=======
  float re = origRe;
  float im = origIm;
  bool diverged = false;
  for(int i = 1; i <= maxIters; i++){
  float tempRe = re*re - im*im;
  float tempIm = 2.0*re*im;
  re = tempRe + origRe;
  im = tempIm + origIm;
  if (abs(re*re)+abs(im*im) > 4.0) {
    diverged = true;
    float grey = (float(i)/maxIters);
    gl_FragColor = vec4(grey,grey,grey,1); 
    break;
    }
  }
  if(!diverged){
            gl_FragColor = vec4(0,0,0,1);
  }
>>>>>>> Ben
  //gl_FragColor = vec4(x,y,0,1);
}