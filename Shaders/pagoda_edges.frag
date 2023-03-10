uniform vec2 u_resolution;
uniform float u_rotation;
uniform float u_skew;

#define pi 3.141592653589793642848

void main() {
    vec2 st = gl_FragCoord.xy/u_resolution.y;
    st.y -= 0.5;
    float ratio = u_resolution.x/u_resolution.y;
    st.x -= 0.5*ratio;
    float fader = 1.0-log(1.6+sqrt(st.x*st.x + (st.y*st.y)));
    float s = sin(u_rotation);
    float c = cos(u_rotation);
    float skewmult = (1.0 / (u_skew + 1.0));
    mat2 rot = mat2(c, s / skewmult, -s, c / skewmult);
    st = st * rot;
	
    vec3 color = vec3(0.000,0.366,0.725);
    
    float theta = atan(st.y, st.x)+(pi/6.0);
    if(mod(theta, pi*2.0/3.0) < pi/3.0) {
    	color = vec3(0.000,0.212,0.420);
    }
    

    gl_FragColor = vec4(color*fader,1.0);
}