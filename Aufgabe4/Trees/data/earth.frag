uniform vec3 baseColor;
uniform float alpha;
uniform sampler2D shadowMap;

//in vec4 color_;
in vec4 shadowMapCoordinates;
in float lambert;
in vec2 UV;
in float height_;


void main(void) {

    if(height_ < 0.2){
        gl_FragColor = vec4(baseColor.rgb * lambert, alpha);
    }else{
        gl_FragColor = vec4(0.45,0.92,0.92,0.4*alpha);
    }

    // Only render shadow if fragment is facing the light
    if (lambert > 0.0) {
        float depth = texture(shadowMap, shadowMapCoordinates.xy).r;
        if (shadowMapCoordinates.z > depth) {
          gl_FragColor -= vec4(0.2, 0.2, 0.2, -1); // Subtract some light
        }
    }
}
