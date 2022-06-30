#version 130

uniform sampler2D framebuf;
varying vec2 screencoords;

#if COMPILING_VERTEX_PROGRAM
    void vert(){
        gl_FrontColor = vec4(1,1,1,1);
        gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
        screencoords = (gl_Position.xy+vec2(1, 1))*.5;
    } 
#elif COMPILING_FRAGMENT_PROGRAM
    void frag(){
        gl_FragColor = texture(framebuf, screencoords.xy);
    }
#endif
