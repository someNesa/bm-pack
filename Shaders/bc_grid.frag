uniform vec2 u_resolution;
uniform float u_rotation;
uniform float u_skew;

void main() {
    vec2 st = gl_FragCoord.xy/u_resolution.y;
    st.y -= 0.5;
    float ratio = u_resolution.x/u_resolution.y;
    st.x -= 0.5*ratio;
    float skewmult = (1.0 / (u_skew + 1.0));
    
    
    float s = sin(u_rotation);
    float c = cos(u_rotation);
    mat2 rot = mat2(c, s / skewmult, -s, c / skewmult);
    st = st * rot;
    
    vec3 color = vec3(0, 0, 0);

    if(mod(st.x+0.005,0.15) < 0.01 || mod(st.y+0.005,0.15) < 0.01) {
        color = vec3(0.3725, 0.0588, 1.0);
    }
    
    gl_FragColor = vec4(color, 1.0);
}