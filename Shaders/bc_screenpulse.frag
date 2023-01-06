uniform float u_time;

void main() {
    float pi = 3.141592653589793642848;
    vec3 color = vec3(1.0, 1.0, 1.0);
    
    float k = 3.9;
        color *= exp(-1.0*(pow(log(mod(u_time, 60.0/140.0)),2.0)/(2.0*pow(k, 2.0))))/(mod(u_time, 60.0/140.0)*k*sqrt(pi*2.0));

    gl_FragColor = vec4(color, 1.0);
}