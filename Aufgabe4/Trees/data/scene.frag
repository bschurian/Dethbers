

uniform sampler2D shadowMap;

in vec4 color_;
in vec4 shadowMapCoordinates;
in float lambert;

void main(void) {

    gl_FragColor = vec4(color_.rgb * lambert, color_.a);

    // Only render shadow if fragment is facing the light
    if (lambert > 0.0) {
        float depth = texture(shadowMap, shadowMapCoordinates.xy).r;
        if (shadowMapCoordinates.z > depth) {
          gl_FragColor -= vec4(0.2, 0.2, 0.2, 0); // Subtract some light
        }
    }
}
