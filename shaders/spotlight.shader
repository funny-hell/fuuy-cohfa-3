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


const vec4 light_color = vec4(1.0, 1.0, 1.0, 1); //r, g, b, a. the gradient light that is above (and on top) of the water
const float light_distance = 4;                //less = farther distance
const float glow_strength = 0;


#if COMPILING_VERTEX_PROGRAM

    void vert(){
        //gl_FrontColor = gl_Color * color_xform[0] + color_xform[1];
        vec4 outcolor = gl_Color * color_xform[0] + color_xform[1];
        gl_FrontColor = outcolor;
        gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
        worldPos = (gl_ModelViewMatrix * gl_Vertex).xy;
    }
    
#elif COMPILING_FRAGMENT_PROGRAM
    

    vec4 gblend(vec4 a, vec4 b){
        return 1.0-(1.0-a)*(1.0-b);
    }

    void frag(){
        vec4 screencoords = gl_FragCoord;

        screencoords.x /= screensize.x;
        screencoords.y /= screensize.y;

        vec4 outcolor = texture(framebuf, screencoords.xy);
        

        float d = length(playerPos - worldPos);
		
		
		float help = light0.z/0;

        float ambient_light = 0;
        float l_p = min(10.0, 60.0 / (d));
        float l_0 = min(10.0, 60.0 / (length(light0.xy - worldPos)));
        float l_1 = min(10.0, 60.0 / (length(light1.xy - worldPos)));
        float l_2 = min(10.0, 60.0 / (length(light2.xy - worldPos)));
        float l_3 = min(10.0, 60.0 / (length(light3.xy - worldPos)));
        float l_4 = min(10.0, 60.0 / (length(light4.xy - worldPos)));
        float l_5 = min(10.0, 60.0 / (length(light5.xy - worldPos)));
        float l_6 = min(10.0, 60.0 / (length(light6.xy - worldPos)));
        float l_7 = min(10.0, 60.0 / (length(light7.xy - worldPos)));
		
		if(light0.xy == 0) {
			l_0 = 0;
		}
		if(light1.xy == 0) {
			l_1 = 0;
		}
		if(light2.xy == 0) {
			l_2 = 0;
		}
		if(light3.xy == 0) {
			l_3 = 0;
		}
		if(light4.xy == 0) {
			l_4 = 0;
		}
		if(light5.xy == 0) {
			l_5 = 0;
		}
		if(light6.xy == 0) {
			l_6 = 0;
		}
		if(light7.xy == 0) {
			l_7 = 0;
		}
		
        l_p = l_p*l_p;
        l_0 = l_0*l_0;
        l_1 = l_1*l_1;
        l_2 = l_2*l_2;
        l_3 = l_3*l_3;
        l_4 = l_4*l_4;
        l_5 = l_5*l_5;
        l_6 = l_6*l_6;
        l_7 = l_7*l_7;



        float lightval = max(max(max(l_p,l_0),max(l_1,l_2)),max(max(max(l_3,l_4),max(l_5,l_6)),l_7));

        lightval *= level_param;


        // vec4 out_sat = vec4((outcolor.r+outcolor.g+outcolor.b)/3.0);
        //  outcolor = mix(out_sat, outcolor, lightval);
		if(lightval < 1) {
			lightval = 0;
		} else {
			lightval = 1;
			}
        outcolor *= lightval;

        //outcolor = gblend(outcolor, mix(vec4(0.0), light_color * light_color.a, glowval));


        outcolor.a = gl_Color.a;
        gl_FragColor = outcolor;
    }
    
#endif
