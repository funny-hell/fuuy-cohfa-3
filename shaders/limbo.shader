#version 130

uniform mat2x4 color_xform;

uniform sampler2D framebuf;


uniform vec2 screensize;
uniform float timer;



#if COMPILING_VERTEX_PROGRAM

    void vert(){
        gl_FrontColor = vec4(1,1,1,1);
        gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
    }
    
#elif COMPILING_FRAGMENT_PROGRAM

    vec4 sample_screen(vec2 coords){
        vec4 outcolor = texture(framebuf, coords.xy);
        if(coords.x<0||coords.y<0||coords.x>1||coords.y>1) outcolor = vec4(0,0,0,1);

        if(fract(coords.y*50)<.25) outcolor *= 0;


        if(fract(coords.x*200)<.33) outcolor.gb = vec2(0,0);
        else if(fract(coords.x*200)>.66) outcolor.rg =vec2(0,0);
        else outcolor.rb = vec2(0,0);
        outcolor *= 3;

        return outcolor;
    }

    vec4 sample_screen2(vec2 coords){
        vec4 outcolor = texture(framebuf, coords.xy);
        if(coords.x<0||coords.y<0||coords.x>1||coords.y>1) outcolor = vec4(0,0,0,1);

        outcolor *= min(1, max(.3,(sin(coords.y*400 - timer * 20)) + 1.8));

        outcolor.r *= min(1, max(.8,(sin(coords.x*1000 )) + .2));
        outcolor.g *= min(1, max(.8,(sin(coords.x*1000+ 2.094)) + .2));
        outcolor.b *= min(1, max(.8,(sin(coords.x*1000+ 4.189)) + .2));
        outcolor *= 1.2;

        /*if(fract(coords.x*200)<.33) outcolor.gb = vec2(0,0);
        else if(fract(coords.x*200)>.66) outcolor.rg =vec2(0,0);
        else outcolor.rb = vec2(0,0);
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
        screencoords.x *= 1+pow(abs(screencoords.y)/3.5, 2.0);//*ratio.x;
        screencoords.y *= 1+pow(abs(screencoords.x)/3.5, 2.0);//*ratio.y;

        screencoords.xy = (screencoords.xy * .5) + .5;

        vec4 outcolor = sample_screen2(screencoords.xy) * 3
            + sample_screen2(screencoords.xy + vec2( 1,0)/1200.0)*2 
            + sample_screen2(screencoords.xy + vec2(-1,0)/1200.0)*2
            + sample_screen2(screencoords.xy + vec2( 2,0)/1200.0)*1
            + sample_screen2(screencoords.xy + vec2(-2,0)/1200.0)*1
        ;
        outcolor /= 9;
       // vec4 outcolor = sample_screen2(screencoords.xy);

        outcolor *= min(1.2, 1.0-pow(length(screencoords.xy - .5)*1.2, 2));

        outcolor.a = 1.0;
        outcolor.g *= 1.25;
        outcolor.b *= 2;
        gl_FragColor = outcolor;
    }
    
#endif
