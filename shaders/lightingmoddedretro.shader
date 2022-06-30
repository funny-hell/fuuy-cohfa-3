#version 130

uniform mat2x4 color_xform;
uniform sampler2D palettetex;
uniform sampler2D framebuf;
uniform float palette;

uniform vec2 screensize;
uniform float timer;

uniform float level_param;

varying vec2 worldPos;

uniform vec2 playerPos;
uniform float waterheight;

uniform vec4 light0;
uniform vec4 light1;
uniform vec4 light2;
uniform vec4 light3;
uniform vec4 light4;
uniform vec4 light5;
uniform vec4 light6;
uniform vec4 light7;


const vec4 light_color = vec4(1.0, 1.0, 1.0, .5); //r, g, b, a. the gradient light that is above (and on top) of the water
const float light_distance = 1;                //less = farther distance
const float glow_strength = 1;
const float pxlt = 10;

#if COMPILING_VERTEX_PROGRAM

    void vert(){
        //gl_FrontColor = gl_Color * color_xform[0] + color_xform[1];
        vec4 outcolor = gl_Color * color_xform[0] + color_xform[1];
        gl_FrontColor = outcolor;
        gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
        worldPos = (gl_ModelViewMatrix * gl_Vertex).xy;
    }
    
#elif COMPILING_FRAGMENT_PROGRAM
    float hash(float x){
        return fract(sin(x)*43758.5453);
    }
    float noise( float u ){
        vec3 x = vec3(u, 0, 0);

        vec3 p = floor(x);
        vec3 f = fract(x);

        f       = f*f*(3.0-2.0*f);
        float n = p.x + p.y*57.0 + 113.0*p.z;

        return mix(mix(mix( hash(n+0.0), hash(n+1.0),f.x),
            mix( hash(n+57.0), hash(n+58.0),f.x),f.y),
            mix(mix( hash(n+113.0), hash(n+114.0),f.x),
                mix( hash(n+170.0), hash(n+171.0),f.x),f.y),f.z);
    }

    float lengthchoppy(vec2 fuck, vec2 shit){
        return length(floor(fuck/pxlt)*pxlt - floor(shit/pxlt)*pxlt);
    }

    float pixel(float n, float p){
        return floor(n*p)/p;
    }

    vec4 gblend(vec4 a, vec4 b){
        return 1.0-(1.0-a)*(1.0-b);
    }

    void frag(){
        vec4 screencoords = gl_FragCoord;

        screencoords.x /= screensize.x;
        screencoords.y /= screensize.y;

        vec4 outcolor = texture(framebuf, screencoords.xy);



        float d = lengthchoppy(playerPos, worldPos);

        float ambient_light = level_param*level_param;
        float l_p = min(1.0, 60.0/(d+50.0));
        float l_0 = min(1.0, light0.z / (lengthchoppy(light0.xy, worldPos) + pixel(light0.z*.75,pxlt)));
        float l_1 = min(1.0, light1.z / (lengthchoppy(light1.xy, worldPos) + pixel(light1.z*.75,pxlt)));
        float l_2 = min(1.0, light2.z / (lengthchoppy(light2.xy, worldPos) + pixel(light2.z*.75,pxlt)));
        float l_3 = min(1.0, light3.z / (lengthchoppy(light3.xy, worldPos) + pixel(light3.z*.75,pxlt)));
        float l_4 = min(1.0, light4.z / (lengthchoppy(light4.xy, worldPos) + pixel(light4.z*.75,pxlt)));
        float l_5 = min(1.0, light5.z / (lengthchoppy(light5.xy, worldPos) + pixel(light5.z*.75,pxlt)));
        float l_6 = min(1.0, light6.z / (lengthchoppy(light6.xy, worldPos) + pixel(light6.z*.75,pxlt)));
        float l_7 = min(1.0, light7.z / (lengthchoppy(light7.xy, worldPos) + pixel(light7.z*.75,pxlt)));

const float light_strength = 3;

        l_p = pixel(l_p,pxlt);
        l_0 = pixel(l_0*light_strength,pxlt);
        l_1 = pixel(l_1*light_strength,pxlt);
        l_2 = pixel(l_2*light_strength,pxlt);
        l_3 = pixel(l_3*light_strength,pxlt);
        l_4 = pixel(l_4*light_strength,pxlt);
        l_5 = pixel(l_5*light_strength,pxlt);
        l_6 = pixel(l_6*light_strength,pxlt);
        l_7 = pixel(l_7*light_strength,pxlt);


        float dy = floor((waterheight - worldPos.y)/pxlt)*pxlt-0.1;

        dy += floor(noise(floor(worldPos.x / 32.0/pxlt)*pxlt +floor(timer/pxlt)*pxlt  * 2)*6/pxlt)*pxlt;
        dy += floor(noise(floor(worldPos.x / 16.0/pxlt)*pxlt +floor(timer/pxlt)*pxlt  * -4.35)*3/pxlt)*pxlt;
        dy += floor(noise(floor(worldPos.x / 8.0/pxlt)*pxlt  +floor(timer/pxlt)*pxlt  * 1)*1.5/pxlt)*pxlt;

        float glowval = -(dy / 360.0/* * ratio.y*/);
        glowval = glowval*light_distance;
        glowval += 1;
        glowval = clamp(glowval, 0.0, 1.0);
        glowval = glowval*glow_strength;
        


        float lightval = l_p+l_0+l_1+l_2+l_3+l_4+l_5+l_6+l_7 + glowval;

        lightval = 1.0-(1.0-lightval)*(1.0-ambient_light);
	lightval = floor(pxlt*lightval)/pxlt;


       // vec4 out_sat = vec4((outcolor.r+outcolor.g+outcolor.b)/3.0);

      //  outcolor = mix(out_sat, outcolor, lightval);

        outcolor *= min(1.5, lightval);



        //outcolor = gblend(outcolor, mix(vec4(0.0), light_color * light_color.a, glowval));


        outcolor.a = gl_Color.a;
        gl_FragColor = outcolor;
    }
    
#endif
