uniform vec2 u_resolution;
uniform float u_time;
uniform float u_rotation;
uniform float u_skew;

bool tolerance(float coord, float spacing, float tol) {
    return mod(coord+(tol/2.0), spacing) < tol;
}

void main() {
    float pi = 3.141592653589793642848;
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

    s = sin(pi/6.0);
    c = cos(pi/6.0);
    rot = mat2(c, s, -s, c);
    st = st * rot;

    if(tolerance(st.y,0.15,0.0025)) {
        color = vec3(1.0, 1.0, 1.0);
    }
    s = sin(pi/3.0);
    c = cos(pi/3.0);
    rot = mat2(c, s, -s, c);
    st = st * rot;
    if(tolerance(st.y,0.15,0.0025)) {
        color = vec3(1.0, 1.0, 1.0);
    }
    s = sin(pi/3.0);
    c = cos(pi/3.0);
    rot = mat2(c, s, -s, c);
    st = st * rot;
    if(tolerance(st.y,0.15,0.0025)) {
        color = vec3(1.0, 1.0, 1.0);
    }
    gl_FragColor = vec4(color, 1.0);
}