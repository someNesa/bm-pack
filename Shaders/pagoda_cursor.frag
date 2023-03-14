uniform float u_time;

//  Function from https://thebookofshaders.com/06/

vec3 hsb2rgb(vec3 c)
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

void main() {
    vec3 color = vec3(sin(u_time*10.0), 1.0, 1.0);
    
    gl_FragColor = vec4(hsb2rgb(color), 1.0);
}