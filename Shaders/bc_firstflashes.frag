uniform vec2 u_resolution;
uniform float u_rotation;
uniform float u_skew;
uniform float u_time;
uniform int u_beat;

//return nice gradient output of color brightness
vec3 normalDist(vec3 color, float dist, float k) {
    float pi = 3.141592653589793642;
    //log normal distribution 
    //https://www.itl.nist.gov/div898/handbook/eda/section3/eda3669.htm
    return color*exp(-1.0*(pow(log(dist),2.0)/(2.0*pow(k, 2.0))))/(dist*k*sqrt(pi*2.0));
}

void main() {
    float pi = 3.141592653589793642;
    
    vec2 st = gl_FragCoord.xy/u_resolution.y;
    st.y -= 0.5;
    float ratio = u_resolution.x/u_resolution.y;
    st.x -= 0.5*ratio;
    float skewmult = (1.0 / (u_skew + 1.0));

    float s = sin(u_rotation);
    float c = cos(u_rotation);
    mat2 rot = mat2(c, s / skewmult, -s, c / skewmult);
    st = st * rot;
    
    
    vec3 color = vec3(1.0, 1.0, 1.0);
    float theta = atan(st.y, st.x)+(2.0*pi) + u_time;
    theta += pi/6.0;
	int sector = int(theta/(pi/3.0));
    float stheta = float(sector)*pi/6.0;
    
    //pseudorandom color pick
    float colorCount = 6.0;
    int huePick = int(dot(vec2(u_beat), vec2(47.0)));
    if(mod(float(huePick), colorCount) == 0.0) {
        color = vec3(0.0, 0.0, 1.0);
    }
    else if(mod(float(huePick), colorCount) == 1.0) {
        color = vec3(0.0, 1.0, 0.0);
    }
    else if(mod(float(huePick), colorCount) == 2.0) {
        color = vec3(0.0, 1.0, 1.0);
    }
    else if(mod(float(huePick), colorCount) == 3.0) {
        color = vec3(1.0, 0.0, 0.0);
    }
    else if(mod(float(huePick), colorCount) == 4.0) {
        color = vec3(1.0, 0.0, 1.0);
    }
    else {
        color = vec3(1.0, 1.0, 0.0);
    }
    
    
    float patternCount = 2.0;
    //pseudorandom pattern pick
    int patPick = u_beat;
	float k = 1.9;
    //ring out
    if(mod(float(patPick), patternCount) == 10.0) {
        float dist = mod(u_time, 60.0/140.0)*18.0+1.0-(4.0*sqrt(st.x*st.x+st.y*st.y))-1.0;
        //log normal distribution
        color *= exp(-1.0*(pow(log(dist),2.0)/(2.0*pow(k, 2.0))))/(dist*k*sqrt(pi*2.0));
    }
    //ring in ?????
    if(mod(float(u_beat), patternCount) == 10.0) {
        float dist = (mod(u_time, 60.0/140.0)*18.0)+(4.0*sqrt(st.x*st.x+st.y*st.y))-4.0;
        //log normal distribution
        color *= exp(-1.0*(pow(log(dist),2.0)/(2.0*pow(k, 2.0))))/(dist*k*sqrt(pi*2.0));
    }
    
    //swipe left
    if(mod(float(patPick), patternCount) == 0.000) {
        float dist = st.x+(mod(u_time, 60.0/140.0)*9.0)-0.5;
        if(st.x<0.0){
            dist = 999999999999999999999999.9;
        }
        float dist2 = -st.x+(mod(u_time, 60.0/140.0)*9.0)-0.5;
        if(st.x>=0.0){
            dist2 = 999999999999999999999999.9;
        }
        //log normal distribution
        color = max(normalDist(color, dist, k) , normalDist(color, dist2, k));
    }
    //swipe down
    if(mod(float(patPick), patternCount) == 1.000) {
        float dist = st.y+(mod(u_time, 60.0/140.0)*9.0)-0.5;
        if(st.y<0.0){
            dist = 999999999999999999999999.9;
        }
        float dist2 = -st.y+(mod(u_time, 60.0/140.0)*9.0)-0.5;
        if(st.y>=0.0){
            dist2 = 999999999999999999999999.9;
        }
        //log normal distribution
        color = max(normalDist(color, dist, k) , normalDist(color, dist2, k));
    }
    
    
    //idk

    gl_FragColor = vec4(color, 1.0);
}