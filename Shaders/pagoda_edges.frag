#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;
uniform float u_rotation;
uniform float u_skew;
uniform float u_player;

const float pi = 3.141592653589793642848;

float distance (vec2 st) {
    return sqrt(pow(st.x, 2.0) + pow(st.y, 2.0));
}

vec3 normalBrightness (vec3 color, float beatTime, float k) { // k is intensity
        //log normal distribution
    	//https://www.itl.nist.gov/div898/handbook/eda/section3/eda3669.htm
        return color *= exp(-1.0*(pow(log(beatTime),2.0)/(2.0*pow(k, 2.0))))/(beatTime*k*sqrt(pi*2.0));
}

vec3 squareVec3(vec3 c) {
    return vec3(pow(c.x, 2.0), pow(c.y, 2.0), pow(c.z, 2.0));
}

//  Function from Iñigo Quiles
//  www.iquilezles.org/www/articles/functions/functions.htm
float expStep( float x, float k, float n ){
    return exp( -k*pow(x,n) );
}

//  Functions from https://thebookofshaders.com/06/
vec3 rgb2hsb(vec3 c)
{
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

vec3 hsb2rgb(vec3 c)
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

void main() {
    vec2 st = gl_FragCoord.xy/u_resolution.y;
    st.y -= 0.5;
    float ratio = u_resolution.x/u_resolution.y;
    st.x -= 0.5*ratio;
    float skewmult = (1.0 / (u_skew + 1.0));

    float s = sin(u_rotation);
    float c = cos(u_rotation);
    mat2 rot = mat2(c, s / skewmult, -s, c / skewmult);
    vec2 sts = st;
    st = st * rot;
    vec3 color = vec3(0.0);
    
    //one beat is 0.5 seconds
    float beatTime = mod(u_time, 0.5) / 0.5; //returns normalized time relative to the current beat from 0-1
    
    float beatToggle = step(sign(mod(u_time, 1.0) - 0.5) * 1.0, 0.0); //returns 1 or 0 depending on whether the beat is even or odd
    float nBeatToggle = step(sign(mod(u_time, 1.0) - 0.5) * -1.0, 0.0); //returns 1 or 0 depending on whether the beat is even or odd
    
    float effectCounter = 0.0; // counts the number of effects to be averaged out in the end
    
    //the hue to base effects on (based on the default hue cycle in shadertoy)
    vec3 hue = vec3(0.5) + 0.5*cos(u_time+vec3(0.0, 2.0, 4.0));

    //radial scan lines
    float theta = pi/3.0;
    float angComp = floor((atan(st.y / st.x)) / theta) * theta + (pi/6.0);
    vec2 v = normalize(vec2(1, tan(angComp)));
    float d = length(v*dot(st, v) - st);
    v = normalize(vec2(1, tan(angComp + theta)));
    d = min(d, length(v*dot(st, v) - st));
    
    float tolerance = 0.003;
    vec3 radialColor = vec3(1.0, 1.0, 1.0);
    
    d = min(d, abs(st.x)); //checks line where tan() is undefined
    
    //color += squareVec3(radialColor * (step(d, tolerance)) * (radialColor, beatTime, 5.0));
    //effectCounter += step(d, tolerance); //adds 1 if the effect is applied
    
    
    //background triangles
	vec3 bgTris = hue;
    
    theta = atan(st.y, st.x)+(pi/6.0);
    if(mod(theta, pi*2.0/3.0) < pi/3.0) {
        bgTris = rgb2hsb(bgTris);
    	bgTris = vec3(bgTris.x, bgTris.y, bgTris.z*0.2);
        bgTris = hsb2rgb(bgTris);
    }
    bgTris *= 1.0-log(0.7+distance(st));
    color += bgTris;
    
    effectCounter += 1.0; //this effect will always be applied
    
    
    vec3 pulseColor = vec3(1.0,1.0,1.0);
    
    //side light pulses
    float sideDist = 0.5*ratio - abs(sts.x);
    color += squareVec3(pulseColor) * beatToggle * pow(expStep(beatTime, 1.0, 1.0) * expStep(sideDist, 2.0, 1.0), 2.0);
    effectCounter += 1.0 * beatToggle; //adds 1 if the effect is applied
    
    //top and bottom light pulses
    float vertDist = 0.5 - abs(sts.y);
    color += squareVec3(pulseColor) * nBeatToggle * pow(expStep(beatTime, 1.0, 1.0) * expStep(vertDist, 5.0, 1.0), 2.0);
    effectCounter += 1.0 * nBeatToggle; //adds 1 if the effect is applied
    

    
    //add all effects together
    gl_FragColor = vec4(sqrt(color/effectCounter),1.0);
}