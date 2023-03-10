uniform vec2 u_resolution;
uniform float u_time;
uniform int u_hue;

//funny
float distribution(float x) {
    float e = 2.7182818284590452353602874713527;
    return pow(e, -1.0*pow((x/-0.2), 2.0)/2.0);
}

//brightness calculation
float brightness(vec3 color) {
    return (0.2126*color.x + 0.7152*color.y + 0.0722*color.z);
}

void main() {
    float pi = 3.141592653589793642848;
    vec2 st = gl_FragCoord.xy/u_resolution.y;
    vec3 color = 1.0 + 0.5*sin(u_time+st.xyx+vec3(0,2,4));
    color *= 0.1;
    vec3 lascol = 1.0 + 0.5*sin(u_time*15.0+st.xyx*5.0+vec3(0,2,4)+(pi))-0.4;
    st.x-=0.75;
    st.y-=0.55;
    if(u_hue == 5) {
        color = vec3(0.0, 0.1, 0.0);
        lascol = vec3(0.0, 1.0, 0.0);
    }
    else if(u_hue == 6) {
        color = vec3(0.1, 0.0, 0.0);
        lascol = vec3(1.0, 0.0, 0.0);
    }
    st.x+=0.0;
    st.y-=0.5;
    float theta = pi/6.0;
    float a = tan(theta);
    theta = pi/24.0+(u_time*2.0);
    //quads 1-3
    vec3 colorVals[6];
    for(int i = 0; i < 6; i++) {
        a = tan(theta);
        vec2 v = normalize(vec2(1, a));
        float d = length(v*dot(st, v) - st);
        if(d < 0.05) {
            d = d*20.0;
            colorVals[i] = lascol*distribution(d);
        }
        theta += pi/6.0;
    }
    for(int i = 0; i < 6; i++) {
        if(brightness(color)<brightness(colorVals[i])) {
            color = colorVals[i];
        }
    }
    gl_FragColor = vec4(color,1.0);
}