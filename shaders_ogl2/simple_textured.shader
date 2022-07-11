#version 110

uniform mat4 color_xform;
uniform sampler2D tex;
varying vec4 texcoord;

#if COMPILING_VERTEX_PROGRAM

    void vert(){
        gl_FrontColor = gl_Color * color_xform[0] + color_xform[1];
        gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
        texcoord = gl_MultiTexCoord0;
    }
    
#elif COMPILING_FRAGMENT_PROGRAM

    void frag(){
        gl_FragColor = gl_Color * texture2D(tex, texcoord.xy);
    }
    
#endif
