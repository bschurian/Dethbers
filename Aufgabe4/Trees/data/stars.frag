//in vec4 color_;
in vec2 UV;

void main(void) {
    gl_FragColor = vec4(UV.x,UV.y,0,1);
}
