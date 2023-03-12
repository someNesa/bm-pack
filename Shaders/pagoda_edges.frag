#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;
uniform float u_rotation;
uniform float u_skew;

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
    
    //radial scan lines
    float theta = pi/3.0;
    float angComp = floor((atan(st.y / st.x)) / theta) * theta + (pi/6.0);
    vec2 v = normalize(vec2(1, tan(angComp)));
    float d = length(v*dot(st, v) - st);
    v = normalize(vec2(1, tan(angComp + theta)));
    d = min(d, length(v*dot(st, v) - st));
    
    float tolerance = 0.003;
    vec3 radialColor = 1.0 + 0.5*sin(u_time*15.0+st.xyx*5.0+vec3(0,2,4)+(pi))-0.5;
    
    d = min(d, abs(st.x)); //checks line where tan() is undefined
    
    color += squareVec3(radialColor*(step(d, tolerance)) * (radialColor, beatTime, 5.0));
    effectCounter += step(d, tolerance); //adds 1 if the effect is applied
    
    
    //background triangles
	vec3 bgTris = vec3(0.000,0.366,0.725);
    
    theta = atan(st.y, st.x)+(pi/6.0);
    if(mod(theta, pi*2.0/3.0) < pi/3.0) {
    	bgTris = vec3(0.000,0.212,0.420);
    }
    bgTris *= 1.0-log(0.7+distance(st));
    color += bgTris;
    
    effectCounter += 1.0; //this effect will always be applied
    
    
    vec3 pulseColor = vec3(0.466,0.610,0.725);
    
    //side light pulses
    float sideDist = 0.5*ratio - abs(sts.x);
    color += pulseColor * beatToggle * pow(expStep(beatTime, 1.0, 1.0) * expStep(sideDist, 2.0, 1.0), 2.0);
    effectCounter += 1.0 * beatToggle; //adds 1 if the effect is applied
    
    //top and bottom light pulses
    float vertDist = 0.5 - abs(sts.y);
    color += pulseColor * nBeatToggle * pow(expStep(beatTime, 1.0, 1.0) * expStep(vertDist, 5.0, 1.0), 2.0);
    effectCounter += 1.0 * nBeatToggle; //adds 1 if the effect is applied
    
    
    
    //add all effects together
    gl_FragColor = vec4(sqrt(color/effectCounter),1.0);
}