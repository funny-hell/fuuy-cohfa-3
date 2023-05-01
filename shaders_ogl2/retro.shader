#version 110

uniform mat4 color_xform;

uniform sampler2D framebuf;


uniform vec2 screensize;
uniform float timer;



#if COMPILING_VERTEX_PROGRAM

    void vert(){
        gl_FrontColor = vec4(1.0,1.0,1.0,1.0);
        gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
    }
    
#elif COMPILING_FRAGMENT_PROGRAM

    vec4 sample_screen(vec2 coords){
        vec4 outcolor = texture2D(framebuf, coords.xy);
        if(coords.x<0.0||coords.y<0.0||coords.x>1.0||coords.y>1.0) outcolor = vec4(0.0,0.0,0.0,1.0);

        if(fract(coords.y*50.0)<.25) outcolor *= 0.0;


        if(fract(coords.x*200.0)<.33) outcolor.gb = vec2(0.0,0.0);
        else if(fract(coords.x*200.0)>.66) outcolor.rg =vec2(0.0,0.0);
        else outcolor.rb = vec2(0.0,0.0);
        outcolor *= 3.0;

        return outcolor;
    }

    vec4 sample_screen2(vec2 coords){
        vec4 outcolor = texture2D(framebuf, coords.xy);
        if(coords.x<0.0||coords.y<0.0||coords.x>1.0||coords.y>1.0) outcolor = vec4(0.0,0.0,0.0,1.0);

        outcolor *= min(1.0, max(.3,(sin(coords.y*400.0 - timer * 20.0)) + 1.8));

        outcolor.r *= min(1.0, max(.8,(sin(coords.x*1000.0 )) + .2));
        outcolor.g *= min(1.0, max(.8,(sin(coords.x*1000.0+ 2.094)) + .2));
        outcolor.b *= min(1.0, max(.8,(sin(coords.x*1000.0+ 4.189)) + .2));
        outcolor *= 1.2;

        /*if(fract(coords.x*200.0)<.33) outcolor.gb = vec2(0.0,0.0);
        else if(fract(coords.x*200.0)>.66) outcolor.rg =vec2(0.0,0.0));
        else outcolor.rb = vec2(0.0,0.0);
        outcolor *= 3;*/

        return outcolor;
    }

    void frag(){
        vec4 screencoords = gl_FragCoord;

        screencoords.x /= screensize.x;
        screencoords.y /= screensize.y;

        
        float scale_x = screensize.x / 1280.0;
        float scale_y = screensize.y / 720.0;
        float scale_min = min(scale_x, scale_y);

        vec2 ratio = vec2(scale_min / scale_x, scale_min / scale_y);
        ratio.y *= (1280.0/720.0);

       // screencoords.xy *= ratio;

       // screencoords.x *= 1.33;
       // screencoords.x -= .166;

        screencoords.xy = (screencoords.xy - .5) * 2.0;
        screencoords.x *= 1.0+pow(abs(screencoords.y)/3.5, 2.0);//*ratio.x;
        screencoords.y *= 1.0+pow(abs(screencoords.x)/3.5, 2.0);//*ratio.y;

        screencoords.xy = (screencoords.xy * .5) + .5;

        vec4 outcolor = sample_screen2(screencoords.xy) * 3.0
            + sample_screen2(screencoords.xy + vec2( 1.0,0.0)/1200.0)*2.0
            + sample_screen2(screencoords.xy + vec2(-1.0,0.0)/1200.0)*2.0
            + sample_screen2(screencoords.xy + vec2( 2.0,0.0)/1200.0)*1.0
            + sample_screen2(screencoords.xy + vec2(-2.0,0.0)/1200.0)*1.0
        ;
        outcolor /= 9.0;
       // vec4 outcolor = sample_screen2(screencoords.xy);

        outcolor *= min(1.2, 1.0-pow(length(screencoords.xy - .5)*1.2, 2.0));

        outcolor.a = 1.0;
        gl_FragColor = outcolor;
    }
    
#endif