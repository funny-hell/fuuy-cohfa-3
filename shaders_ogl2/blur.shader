#version 110

uniform sampler2D palettetex;
uniform sampler2D framebuf;
uniform vec2 screensize;

varying vec2 screencoords;
varying vec2 ratio;

varying vec2 blurcoords[25];

#if COMPILING_VERTEX_PROGRAM

    void vert(){
        gl_FrontColor = vec4(1,1,1,1);
        gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;

        screencoords = (gl_Position.xy+vec2(1, 1))*.5;

        float scale_x = screensize.x / 1280.0;
        float scale_y = screensize.y / 720.0;
        float scale_min = min(scale_x, scale_y);
        ratio = vec2(scale_min / scale_x, scale_min / scale_y);
        ratio.y *= (1280.0/720.0);

        blurcoords[0] = screencoords.xy + vec2(-2.0,-2.0) * ratio * .0007;
        blurcoords[1] = screencoords.xy + vec2(-1.0,-2.0) * ratio * .0007;
        blurcoords[2] = screencoords.xy + vec2( 0.0,-2.0) * ratio * .0007;
        blurcoords[3] = screencoords.xy + vec2( 1.0,-2.0) * ratio * .0007;
        blurcoords[4] = screencoords.xy + vec2( 2.0,-2.0) * ratio * .0007;

        blurcoords[5] = screencoords.xy + vec2(-2.0,-1.0) * ratio * .0007;
        blurcoords[6] = screencoords.xy + vec2(-1.0,-1.0) * ratio * .0007;
        blurcoords[7] = screencoords.xy + vec2( 0.0,-1.0) * ratio * .0007;
        blurcoords[8] = screencoords.xy + vec2( 1.0,-1.0) * ratio * .0007;
        blurcoords[9] = screencoords.xy + vec2( 2.0,-1.0) * ratio * .0007;

        blurcoords[10] = screencoords.xy + vec2(-2.0, 0.0) * ratio * .0007;
        blurcoords[11] = screencoords.xy + vec2(-1.0, 0.0) * ratio * .0007;
        blurcoords[12] = screencoords.xy + vec2( 0.0, 0.0) * ratio * .0007;
        blurcoords[13] = screencoords.xy + vec2( 1.0, 0.0) * ratio * .0007;
        blurcoords[14] = screencoords.xy + vec2( 2.0, 0.0) * ratio * .0007;

        blurcoords[15] = screencoords.xy + vec2(-2.0, 1.0) * ratio * .0007;
        blurcoords[16] = screencoords.xy + vec2(-1.0, 1.0) * ratio * .0007;
        blurcoords[17] = screencoords.xy + vec2( 0.0, 1.0) * ratio * .0007;
        blurcoords[18] = screencoords.xy + vec2( 1.0, 1.0) * ratio * .0007;
        blurcoords[19] = screencoords.xy + vec2( 2.0, 1.0) * ratio * .0007;

        blurcoords[20] = screencoords.xy + vec2(-2.0, 2.0) * ratio * .0007;
        blurcoords[21] = screencoords.xy + vec2(-1.0, 2.0) * ratio * .0007;
        blurcoords[22] = screencoords.xy + vec2( 0.0, 2.0) * ratio * .0007;
        blurcoords[23] = screencoords.xy + vec2( 1.0, 2.0) * ratio * .0007;
        blurcoords[24] = screencoords.xy + vec2( 2.0, 2.0) * ratio * .0007;
    }
    
#elif COMPILING_FRAGMENT_PROGRAM

    void frag(){

        vec4 outcolor = vec4(0.0,0.0,0.0,0.0);
        /*
        //outcolor += texture2D(framebuf, blurcoords[0 ]) * 0.023528;
        outcolor += texture2D(framebuf, blurcoords[1 ]) * 0.033969;
        outcolor += texture2D(framebuf, blurcoords[2 ]) * 0.038393;
        outcolor += texture2D(framebuf, blurcoords[3 ]) * 0.033969;
        //outcolor += texture2D(framebuf, blurcoords[4 ]) * 0.023528;
                                                      
        outcolor += texture2D(framebuf, blurcoords[5 ]) * 0.033969;
        outcolor += texture2D(framebuf, blurcoords[6 ]) * 0.049045;
        outcolor += texture2D(framebuf, blurcoords[7 ]) * 0.055432;
        outcolor += texture2D(framebuf, blurcoords[8 ]) * 0.049045;
        outcolor += texture2D(framebuf, blurcoords[9 ]) * 0.033969;
                                                      
        outcolor += texture2D(framebuf, blurcoords[10]) * 0.038393;
        outcolor += texture2D(framebuf, blurcoords[11]) * 0.055432;
        outcolor += texture2D(framebuf, blurcoords[12]) * 0.062651;
        outcolor += texture2D(framebuf, blurcoords[13]) * 0.055432;
        outcolor += texture2D(framebuf, blurcoords[14]) * 0.038393;
                                                      
        outcolor += texture2D(framebuf, blurcoords[15]) * 0.033969;
        outcolor += texture2D(framebuf, blurcoords[16]) * 0.049045;
        outcolor += texture2D(framebuf, blurcoords[17]) * 0.055432;
        outcolor += texture2D(framebuf, blurcoords[18]) * 0.049045;
        outcolor += texture2D(framebuf, blurcoords[19]) * 0.033969;
                                                      
        //outcolor += texture2D(framebuf, blurcoords[20]) * 0.023528;
        outcolor += texture2D(framebuf, blurcoords[21]) * 0.033969;
        outcolor += texture2D(framebuf, blurcoords[22]) * 0.038393;
        outcolor += texture2D(framebuf, blurcoords[23]) * 0.033969;
        //outcolor += texture2D(framebuf, blurcoords[24]) * 0.023528;
        */

        //outcolor += texture2D(framebuf, blurcoords[0 ]) * 0.023528;
        outcolor += texture2D(framebuf, blurcoords[1 ]) * 4.0/252.0;
        outcolor += texture2D(framebuf, blurcoords[2 ]) * 6.0/252.0;
        outcolor += texture2D(framebuf, blurcoords[3 ]) * 4.0/252.0;
        //outcolor += texture2D(framebuf, blurcoords[4 ]) * 0.023528;

        outcolor += texture2D(framebuf, blurcoords[5 ]) * 4.0/252.0;
        outcolor += texture2D(framebuf, blurcoords[6 ]) * 16.0/252.0;
        outcolor += texture2D(framebuf, blurcoords[7 ]) * 24.0/252.0;
        outcolor += texture2D(framebuf, blurcoords[8 ]) * 16.0/252.0;
        outcolor += texture2D(framebuf, blurcoords[9 ]) * 4.0/252.0;

        outcolor += texture2D(framebuf, blurcoords[10]) * 6.0/252.0;
        outcolor += texture2D(framebuf, blurcoords[11]) * 24.0/252.0;
        outcolor += texture2D(framebuf, blurcoords[12]) * 36.0/252.0;
        outcolor += texture2D(framebuf, blurcoords[13]) * 24.0/252.0;
        outcolor += texture2D(framebuf, blurcoords[14]) * 6.0/252.0;

        outcolor += texture2D(framebuf, blurcoords[15]) * 4.0/252.0;
        outcolor += texture2D(framebuf, blurcoords[16]) * 16.0/252.0;
        outcolor += texture2D(framebuf, blurcoords[17]) * 24.0/252.0;
        outcolor += texture2D(framebuf, blurcoords[18]) * 16.0/252.0;
        outcolor += texture2D(framebuf, blurcoords[19]) * 4.0/252.0;

        //outcolor += texture2D(framebuf, blurcoords[20]) * 0.023528;
        outcolor += texture2D(framebuf, blurcoords[21]) * 4.0/252.0;
        outcolor += texture2D(framebuf, blurcoords[22]) * 6.0/252.0;
        outcolor += texture2D(framebuf, blurcoords[23]) * 4.0/252.0;
        //outcolor += texture2D(framebuf, blurcoords[24]) * 0.023528;


        //outcolor.a = 1.0;
        gl_FragColor = outcolor;//texture2D(framebuf, screencoords.xy);
    }
    
#endif
