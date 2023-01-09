// Author:
// Title:

#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;
uniform float u_rotation;
uniform float u_skew;
uniform int u_beat;

bool tolerance(float coord, float spacing, float tol) {
    return mod(coord+(tol/2.0), spacing) < tol;
}

//return nice gradient output of color brightness
vec3 normalDist(vec3 color, float dist, float k) {
    float pi = 3.141592653589793642;
    //log normal distribution 
    //https://www.itl.nist.gov/div898/handbook/eda/section3/eda3669.htm
    return color*exp(-1.0*(pow(log(dist),2.0)/(2.0*pow(k, 2.0))))/(dist*k*sqrt(pi*2.0));
}
float normalDist(float i, float dist, float k) {
    float pi = 3.141592653589793642;
    //thickness gradient
    return 4.0*k*sin(3.0*dist+(pi/2.0));
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

    float dist = mod(u_time, 60.0/140.0);
	
    float thickness = 2.0;
    float brightness = 4.9;
    
    vec3 beatColor = 1.0 + 0.5*cos(u_time*2.0+st.xyx+vec3(0,2,4));
    float tol1 = 0.0025;
    if(mod(float(u_beat), 3.0) == 2.0) {
        tol1 += normalDist(1.0, dist, thickness)/300.0;
    }
    if(tolerance(st.y,0.15,tol1)) {
        if(mod(float(u_beat), 3.0) == 2.0) {
            color = normalDist(beatColor, dist, brightness);
        }
        else {
            color = vec3(1.0, 1.0, 1.0);
        }
    }
    s = sin(pi/3.0);
    c = cos(pi/3.0);
    rot = mat2(c, s, -s, c);
    st = st * rot;
    float tol2 = 0.0025;
    if(mod(float(u_beat), 3.0) == 1.0) {
        tol2 += normalDist(1.0, dist, thickness)/300.0;
    }
    if(tolerance(st.y,0.15,tol2)) {
        if(mod(float(u_beat), 3.0) == 1.0) {
            color = normalDist(beatColor, dist, brightness);
        }
        else {
            color = vec3(1.0, 1.0, 1.0);
        }
    }
    s = sin(pi/3.0);
    c = cos(pi/3.0);
    rot = mat2(c, s, -s, c);
    st = st * rot;
    float tol3 = 0.0025;
    if(mod(float(u_beat), 3.0) == 0.0) {
        tol3 += normalDist(1.0, dist, thickness)/300.0;
    }
    if(tolerance(st.y,0.15,tol3)) {
        if(mod(float(u_beat), 3.0) == 0.0) {
            color = normalDist(beatColor, dist, brightness);
        }
        else {
            color = vec3(1.0, 1.0, 1.0);
        }
    }
    gl_FragColor = vec4(color, 1.0);
}