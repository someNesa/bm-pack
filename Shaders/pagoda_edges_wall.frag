uniform vec2 u_resolution;
uniform float u_rotation;
uniform float u_time;
uniform float u_skew;
uniform float u_bpm;

#define pi 3.141592653589793642848

//  Functions from https://thebookofshaders.com/06/
float impulse( float k, float x ){
    float h = k*x;
    return h*exp(1.0-h);
}

vec3 hsb2rgb( in vec3 c ){
    vec3 rgb = clamp(abs(mod(c.x*6.0+vec3(0.0,4.0,2.0),
                             6.0)-3.0)-1.0,
                     0.0,
                     1.0 );
    rgb = rgb*rgb*(3.0-2.0*rgb);
    return c.z * mix( vec3(1.0), rgb, c.y);
}

vec3 rgb2hsb( in vec3 c ){
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz),
                 vec4(c.gb, K.xy),
                 step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r),
                 vec4(c.r, p.yzx),
                 step(p.x, c.r));
    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)),
                d / (q.x + e),
                q.x);
}

void main() {
    vec2 st = gl_FragCoord.xy/u_resolution.y;
    st.y -= 0.5;
    float ratio = u_resolution.x/u_resolution.y;
    st.x -= 0.5*ratio;
    float s = sin(u_rotation);
    float c = cos(u_rotation);
    float skewmult = (1.0 / (u_skew + 1.0));
    mat2 rot = mat2(c, s / skewmult, -s, c / skewmult);
    st = st * rot;
	float satur = 1.0-impulse(12.0, mod(u_time, 60.0/u_bpm)/(60.0/u_bpm));
    vec3 color = vec3(0.0, 0.4549, 0.9098);
    color = rgb2hsb(color);
    color = vec3(color.x, satur, color.z);
    color = hsb2rgb(color);
    
    

    gl_FragColor = vec4(color,1.0);
}