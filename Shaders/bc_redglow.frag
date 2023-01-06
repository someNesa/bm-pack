uniform vec2 u_resolution;
void main() {
    vec2 st = gl_FragCoord.xy/u_resolution.y;
    st.y -= 0.5;
    float ratio = u_resolution.x/u_resolution.y;
    st.x -= 0.5*ratio;
    vec3 color = vec3(1.0, 0.0, 0.0);
    color *= 1.0-sqrt(st.x*st.x + st.y*st.y)*2.0;

    gl_FragColor = vec4(color,1.0);
}