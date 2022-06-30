#version 130

uniform mat2x4 color_xform;
uniform sampler2D palettetex;
ivec2 ipalettesize;
vec2 palettesize;
uniform float palette;
uniform float level_param;
uniform float timer;

const float pulse_speed = 1.2;           // the speed at which to pulse (lower = slower)


#if COMPILING_VERTEX_PROGRAM

    void vert(){
        //gl_FrontColor = gl_Color * color_xform[0] + color_xform[1];
        vec4 outcolor = gl_Color * color_xform[0] + color_xform[1];
	ipalettesize = textureSize(palettetex, 0);
	palettesize = vec2(ipalettesize.x, ipalettesize.y);
        gl_FrontColor = vec4(texture(palettetex, vec2((outcolor.r*15.0+.5)/palettesize.x,(level_param+.5)/palettesize.y)).rgb, outcolor.a);
        gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
    }
    
#elif COMPILING_FRAGMENT_PROGRAM
	float sin_range(float _min, float _max, float _t)
	{
		float half_range = (_max - _min) / 2;
		return _min + half_range + sin(_t) * half_range;
	}
	
    void frag(){
		float time_value = timer * pulse_speed;
		float mix_value = 0.3+sin_range(0, 0.6, time_value);
        gl_FragColor = gl_Color*mix_value;
    }
    
#endif
