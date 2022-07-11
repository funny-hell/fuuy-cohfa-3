#version 110

uniform sampler2D framebuf;
varying vec2 screencoords;

#if COMPILING_VERTEX_PROGRAM
    void vert(){
        gl_FrontColor = vec4(1.0,1.0,1.0,1.0);
        gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
        screencoords = (gl_Position.xy+vec2(1.0, 1.0))*.5;
    } 
#elif COMPILING_FRAGMENT_PROGRAM
    void frag(){
        gl_FragColor = texture2D(framebuf, screencoords.xy);
    }
#endif
