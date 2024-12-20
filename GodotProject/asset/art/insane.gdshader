shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture;
global uniform int lead_emo;
global uniform int lead_san;
global uniform int current_time;
global uniform bool light_on;
//uniform sampler2D background_texture;
//uniform sampler2D background_texture_night;
const int bayer_matrix[64] = {
    0, 48, 12, 60, 3, 51, 15, 63,
    32, 16, 44, 28, 35, 19, 47, 31,
    8, 56, 4, 52, 11, 59, 7, 55,
    40, 24, 36, 20, 43, 27, 39, 23,
    2, 50, 14, 62, 1, 49, 13, 61,
    34, 18, 46, 30, 33, 17, 45, 29,
    10, 58, 6, 54, 9, 57, 5, 53,
    42, 26, 38, 22, 41, 25, 37, 21
};
float _overlap(float color,float background_color,float strength){
	return (1.0 - (1.0-color)*(1.0-background_color)*2.0)*strength + background_color*(1.0-strength);
}

vec4 _san_color(vec4 color){
	vec4 res = color;
	if(color.r > 0.7){
		res.r = res.g;
		res.g += color.r;
	}
	if(color.g > 0.6){
		res.g += color.b;
	}else{
		res.g = 0.7;
	}
	res.b = 1.0;
	if(color.r*color.g*color.b>0.9){
		res.r = 1.0;
		res.g = 1.0;
		res.b = 1.0;
	}else if(color.r*color.g*color.b<0.05){
		res.r = 0.9;
		res.g = 0.0;
		res.b = 1.0;
	}
	return res;
}

vec4 _bayer_print(vec2 uv,vec4 result){
    float bayer_index = float(bayer_matrix[int(uv.x)/4%8*8+int(uv.y)/4%8]) / 64.0;
	float th = (result.r+result.b+result.g-2.0);
	result.r  = step(bayer_index, result.r);
	result.g  = step(bayer_index, result.g);
	result.b  = step(bayer_index, result.b);
	return result;
}

void fragment() {
	vec4 background= texture(screen_texture, vec2(SCREEN_UV));
	vec4 result = background;
	result = _san_color(result);
    COLOR = result;
}
