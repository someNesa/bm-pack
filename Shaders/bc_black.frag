uniform vec2 u_resolution;

void main() {
    vec2 st = gl_FragCoord.xy/u_resolution.y;
    st.y -= 0.5;
    float ratio = u_resolution.x/u_resolution.y;
    st.x -= 0.5*ratio;


    gl_FragColor = vec4(vec3(1.0-smoothstep(0.1, 0.9, sqrt(st.x*st.x + (st.y*st.y)))),1.0);
}