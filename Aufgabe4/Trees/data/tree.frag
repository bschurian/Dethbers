uniform vec4 baseColor;
uniform sampler2D shadowMap;
uniform sampler2D shadowMap2;

//in vec4 color_;
in vec4 shadowMapCoordinates;
in vec4 shadowMapCoordinates2;
in float lambert;

void main(void) {

    gl_FragColor = vec4(baseColor.rgb * lambert, baseColor.w);

    // Only render shadow if fragment is facing the light
    if (lambert > 0.0) {
        float depth = texture(shadowMap, shadowMapCoordinates.xy).r;
        float depth2 = texture(shadowMap2, shadowMapCoordinates2.xy).r;
        if (shadowMapCoordinates.z > depth) {
          gl_FragColor -= vec4(0.2, 0.2, 0.2, 0); // Subtract some light
        }
        if (shadowMapCoordinates.z > depth2) {
          gl_FragColor -= vec4(0.2, 0.2, 0.2, 0); // Subtract some light
        }
    }
}
