uniform vec2 u_resolution;
uniform float u_time;
uniform float u_rotation;
uniform float u_skew;
uniform int u_hue;

void main() {
    float pi = 3.141592653589793642848;
    vec2 st = gl_FragCoord.xy/u_resolution.y;
    vec3 color = 1.0 + 0.5*sin(u_time+st.xyx+vec3(0,2,4));
    vec3 lascol = 1.0 + 0.5*sin(u_time+st.xyx+vec3(0,2,4)+(pi));;
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
    float theta = pi/24.0;
    float a = tan(theta);
    if(st.y>0.0) {
        theta = pi/24.0+(u_time);
        //quads 1-3
        for(int i = 0; i < 12; i++) {
            a = tan(theta);
            vec2 v = normalize(vec2(1, a));
            float d = length(v*dot(st, v) - st);
            if(d < 0.0015) {
                color = lascol;
                break;
            }
            theta += pi/24.0;
        }
        a = -0.2;
        //quads 2-4
        for(int i = 0; i < 12; i++) {
            a = tan(theta);
            vec2 v = normalize(vec2(1, a));
            float d = length(v*dot(st, v) - st);
            if(d < 0.0015) {
                color = lascol;
                break;
            }
            theta += pi/24.0;
        }
        
        st.x = u_resolution.x/u_resolution.y-st.x;

        theta = pi/24.0+(u_time);
        //quads 1-3
        for(int i = 0; i < 12; i++) {
            a = tan(theta);
            vec2 v = normalize(vec2(1, a));
            float d = length(v*dot(st, v) - st);
            if(d < 0.0015) {
                color = lascol;
                break;
            }
            theta += pi/24.0;
        }
        a = -0.2;
        //quads 2-4
        for(int i = 0; i < 12; i++) {
            a = tan(theta);
            vec2 v = normalize(vec2(1, a));
            float d = length(v*dot(st, v) - st);
            if(d < 0.0015) {
                color = lascol;
                break;
            }
            theta += pi/24.0;
        }
    }
    else {
        theta = pi/24.0-(u_time);
        //quads 1-3
        for(int i = 0; i < 12; i++) {
            a = tan(theta);
            vec2 v = normalize(vec2(1, a));
            float d = length(v*dot(st, v) - st);
            if(d < 0.0015) {
                color = lascol;
                break;
            }
            theta += pi/24.0;
        }
        a = -0.2;
        //quads 2-4
        for(int i = 0; i < 12; i++) {
            a = tan(theta);
            vec2 v = normalize(vec2(1, a));
            float d = length(v*dot(st, v) - st);
            if(d < 0.0015) {
                color = lascol;
                break;
            }
            theta += pi/24.0;
        }
        
        st.x = u_resolution.x/u_resolution.y-st.x;

        theta = pi/24.0-(u_time);
            //quads 1-3
        for(int i = 0; i < 12; i++) {
            a = tan(theta);
            vec2 v = normalize(vec2(1, a));
            float d = length(v*dot(st, v) - st);
            if(d < 0.0015) {
                color = lascol;
                break;
            }
            theta += pi/24.0;
        }
        a = -0.2;
        //quads 2-4
        for(int i = 0; i < 12; i++) {
            a = tan(theta);
            vec2 v = normalize(vec2(1, a));
            float d = length(v*dot(st, v) - st);
            if(d < 0.0015) {
                color = lascol;
                break;
            }
            theta += pi/24.0;
            }
    }
    gl_FragColor = vec4(color,1.0);
}