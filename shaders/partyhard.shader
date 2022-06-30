#version 130

uniform mat2x4 color_xform;
uniform sampler2D palettetex;
ivec2 ipalettesize;
vec2 palettesize;
uniform sampler2D framebuf;
uniform float palette;
uniform vec2 screensize;
uniform float timer;

varying vec2 worldPos;

const vec4  pulse_color = vec4(1,0.0,1,1); // the color to pulse to
const float pulse_speed = 20.0;           // the speed at which to pulse (lower = slower)
const float max_color_intensity = 0.1;  // how close to the desired color the pulse will get
const float speed = 15.0;                 // the speed at which to shake the screen (lower = slower)
const vec2  intensity = vec2(0.05, 0.35); // the intensity of the screen shake in the x and y directions

#if COMPILING_VERTEX_PROGRAM

void vert()
{
    vec4 outcolor = gl_Color * color_xform[0] + color_xform[1];
    gl_FrontColor = vec4(texture(palettetex, vec2((outcolor.r * 15.0 + 0.5) / 16.0, (palette + 0.5) / palettesize.y)).rgb, outcolor.a);

    gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
    worldPos = (gl_ModelViewMatrix * gl_Vertex).xy;
}

#elif COMPILING_FRAGMENT_PROGRAM

float sin_range(float _min, float _max, float _t)
{
    float half_range = (_max - _min) / 2;
    return _min + half_range + sin(_t) * half_range;
}

void frag()
{
    vec4 screencoords = gl_FragCoord;

    screencoords.x /= screensize.x;
    screencoords.y /= screensize.y;

    float time_value = -timer * pulse_speed;
    float mix_value = sin_range(0, max_color_intensity, time_value);
	
    float scale_x = screensize.x / 1280.0, scale_y = screensize.y / 720.0;
    float scale_min = min(scale_x, scale_y);

    vec2 ratio = vec2(scale_min / scale_x, scale_min / scale_y);
    float time_value2 = -timer * speed;

	vec2 rippleval = vec2(floor(sin(timer*5+worldPos.y / 5.0)) * .005*cos(timer*0.5), floor(sin(timer*10+worldPos.y / 10.0)) * .01*5*cos(timer*0.5)) * ratio;

    vec2 screen_offset = vec2(sin_range(0, intensity.x, time_value2), sin_range(0, intensity.y, time_value2)) * ratio * 0.015;
    vec2 shaken_screencoords = screencoords.xy + screen_offset;

    vec4 outcolora = mix(texture(framebuf, shaken_screencoords), pulse_color, mix_value);
    vec4 outcolorb = mix(texture(framebuf, shaken_screencoords + rippleval), pulse_color, mix_value);
    vec4 outcolor = mix(outcolora, outcolorb, 1);
	
	outcolor.a = 1.0;
    gl_FragColor = outcolor;
}

#endif