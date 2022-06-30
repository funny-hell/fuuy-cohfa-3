#version 130

uniform mat2x4 color_xform;
uniform sampler2D palettetex;
ivec2 ipalettesize;
vec2 palettesize;
uniform sampler2D framebuf;
uniform float palette;

uniform vec2 screensize;
uniform float timer;
uniform float waterheight;

varying vec2 worldPos;

#if COMPILING_VERTEX_PROGRAM

    void vert(){
        //gl_FrontColor = gl_Color * color_xform[0] + color_xform[1];
        vec4 outcolor = gl_Color * color_xform[0] + color_xform[1];
        ipalettesize = textureSize(palettetex, 0);
	palettesize = vec2(ipalettesize.x, ipalettesize.y);
        gl_FrontColor = vec4(texture(palettetex, vec2((outcolor.r*15.0+.5)/palettesize.x,(palette+.5)/palettesize.y)).rgb, outcolor.a);
        gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
        worldPos = (gl_ModelViewMatrix * gl_Vertex).xy;
    }
    
#elif COMPILING_FRAGMENT_PROGRAM

float hash(float x)
{
    return fract(sin(x)*43758.5453);
}

float noise(float u)
{
    vec3 x = vec3(u, 0, 0);

    vec3 p = floor(x);
    vec3 f = fract(x);

    f = f * f * (3.0 - 2.0 * f);
    float n = p.x + p.y * 57.0 + 113.0 * p.z;

    return mix(mix(mix(hash(n + 0.0), hash(n + 1.0),   f.x),
           mix(hash(n + 57.0), hash(n + 58.0), f.x),   f.y),
           mix(mix(hash(n + 113.0), hash(n + 114.0),   f.x),
           mix(hash(n + 170.0), hash(n + 171.0), f.x), f.y),
           f.z);
}

    void frag(){
        vec4 screencoords = gl_FragCoord;

        screencoords.x /= screensize.x;
        screencoords.y /= screensize.y;

        
        float scale_x = screensize.x / 1280.0;
        float scale_y = screensize.y / 720.0;
        float scale_min = min(scale_x, scale_y);

        vec2 ratio = vec2(scale_min / scale_x, scale_min / scale_y);
        
        vec4 basecolor = texture(framebuf, screencoords.xy);
       

float deviance = 0; //(noise(worldPos.x/32.0-timer*2)+noise(noise(worldPos.y/32)-timer))/3;
float xsplit = worldPos.y/1080+worldPos.x/1920+timer+deviance;
const float mul = 4;
const float bright = 0.75;
vec4 light_color = vec4(sin(mul*xsplit)+bright, sin(mul*xsplit+2.09439510239)+bright, sin(mul*xsplit+4.18879020479)+bright, 1); // r, g, b, a. the gradient light that is above (and on top) of the water
        

        //reflections
        float dy = waterheight - worldPos.y + 0.156;

        vec2 reflectionval = vec2(0.0, dy / 360.0) * ratio;
       // reflectionval += vec2(sin(-timer*20+worldPos.y / 1.0) * .001 * ratio.x, 0.0); //ripple distortion

        vec4 reflection = texture(framebuf, screencoords.xy - reflectionval);

        float ripple_alpha = 0.5;
        float ripple_fadedown = 0.2;

        float ripple_a = min(1.0, max(0.0, reflectionval.y * -ripple_fadedown/ratio.y));
        ripple_a = ripple_a*ripple_alpha+1.0-ripple_alpha;

        vec4 outcolor = basecolor*ripple_a + reflection*(1.0-ripple_a);


        outcolor = outcolor*(1.0-gl_Color.a) + gl_Color*gl_Color.a;

        outcolor.a = 1.0;

	outcolor.r += light_color.r/5;
	outcolor.g += light_color.g/5;
	outcolor.b += light_color.b/5;
        
	gl_FragColor = outcolor;
    }
    
#endif
