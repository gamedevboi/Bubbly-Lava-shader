shader_type canvas_item;

//uniform vec3 color = vec3(0.2, 0.2, 0.7);
uniform vec4 color1 : hint_color;
uniform vec4 color2 : hint_color;
uniform vec4 color_line : hint_color;
uniform int OCTAVES = 4;


float rand(vec2 coord){
	return fract(sin(dot(coord, vec2(56.78357373,78.66347858)) * 1000.0 ) * 1000.0);
}

float noise(vec2 coord){
	vec2 floored = floor(coord);
	vec2 fracted = fract(coord);
	
	float a = rand(floored);
	float b = rand(floored + vec2(1.0,0.0));
	float c = rand(floored + vec2(0.0,1.0));
	float d = rand(floored + vec2(1.0,1.0));
	
	vec2 cubic = fracted *fracted*(3.0 - 2.0* fracted) ;
	return mix(a,b,cubic.x) + (c - a) * cubic.y * (1.0 - cubic.x) + (d - b) * cubic.x * cubic.y;

}


float fbm(vec2 coord){
	float value = 0.0;
	float scale = 0.5;
	
	for(int i = 0; i<OCTAVES; i++){
		value += noise(coord)*scale;
		coord *= 1.90;
		scale *=0.5;
		
	}
	return value;
}

void fragment(){
	vec2 coord = UV * 10.0;
	vec2 motion = vec2(fbm(coord) + TIME * -0.3, fbm(coord + TIME * 0.9));
	vec2 motion2 = vec2(fbm(coord), fbm(coord + TIME * 0.99));
	vec2 motion3 = vec2(fbm(coord + TIME), fbm(coord + TIME * -0.99));
	float final = fbm(motion + motion2 + coord);
	COLOR.a = final;
	
	if(COLOR.a > 0.4){
		COLOR = color1;
		
	}
	else if (COLOR.a > 0.22){COLOR = color2;}
	else{COLOR = vec4(1.0,1.0,1.0,1.0);}
	
	float wavy_top = fbm(cos(2.0 * sin(coord +(3.1416* 3.1416*UV.x * UV.x * UV.x)) + TIME * 0.8 ) + TIME * -0.8 +  (3.1416* 3.1416*UV.x * UV.x * UV.x));
	//float bubbles =  fbm(sin(sinh(coord ) + TIME * 0.99))*fbm(sin(sinh(coord ) + TIME * 0.99))*3.15;
	float bubbles =  wavy_top*wavy_top*3.1416;
	if (UV.y < 0.11 * bubbles){
		COLOR = color_line;
	}
	
	if (UV.y < 0.1 * bubbles){
		
		COLOR.a =  0f;
	}	
	
}