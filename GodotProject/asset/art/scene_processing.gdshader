shader_type canvas_item;

global uniform sampler2D noise_texture;
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
		res.b += color.r;
	}else{
		res.r = 1.0;
	}
	if(color.g > 0.6){
		res.g = 1.6-color.g;
		res.g += color.b;
	}else{
		res.g = 1.0;
	}
	if(color.b > 0.6){
		res.b = 1.0;
	}
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
	result.r  = step(bayer_index, th);
	result.g  = step(bayer_index, th);
	result.b  = step(bayer_index, th);
	return result;
}

void fragment() {

    vec2 uv = vec2(UV);
    vec4 noise = texture(noise_texture, vec2(UV));
	vec4 background= COLOR;
	vec4 lights_off_uv;
	//if(current_time < 2){
		 //background = texture(background_texture, vec2(UV));
	//}
    //else{
		//background = texture(background_texture_night, vec2(UV));
	//}
	vec4 result = background;
	float noise_strength;
	float blink_speed;
	if(lead_emo>40){
		noise_strength = float(100-lead_emo)/60.0;
	}else if(lead_emo>10){
		noise_strength = float(60-lead_emo)/20.0;
	}else{
		noise_strength = float(15-lead_emo)/2.0;
	}
	noise_strength -= 0.2;
	blink_speed = float(60-lead_emo)/80.0;
	if(blink_speed<0.0){
		blink_speed = 0.0;
	}
	noise_strength += sin(TIME * 1.0)*blink_speed;
	if(noise_strength <= 0.1){
		noise_strength = 0.1;
	}
	result.r = _overlap(noise.r,background.r,noise_strength);
	result.g = _overlap(noise.g,background.g,noise_strength)-noise_strength*0.02;
	result.b = _overlap(noise.b,background.b,noise_strength)-noise_strength*0.01;

	//result = _san_color(result);


    // 输出最终颜色
	if(current_time == 0){
		result = vec4(result.r/1.07,result.g/1.07,result.b/1.05,result.a);
	}
	else if(current_time == 2){
		result = vec4(result.r/1.0,result.g/1.3,result.b/2.0,result.a);
	}
	else if(current_time == 3 && light_on == false){
		result = vec4(result.r/6.0,result.g/5.0,result.b/2.4,result.a);
	}
	else if(current_time >= 4 && light_on == false){
		result = vec4(result.r/20.0,result.g/16.0,result.b/3.0,result.a);
	}
	else if(current_time >= 4 && light_on == true){
		result = vec4(result.r/1.08,result.g/1.08,result.b/1.08,result.a);
	}
	//uv = vec2(UV)* vec2(1920, 1080);
	//result += _bayer_print(uv,result) * sin(TIME * 0.3)*blink_speed;

    COLOR = result;

}
