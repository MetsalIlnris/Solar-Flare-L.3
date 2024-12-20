shader_type canvas_item;

global uniform sampler2D noise_texture;
global uniform int lead_emo;
global uniform int current_time;
global uniform bool light_on;

float _overlap(float color,float background_color,float strength){
	return (1.0 - (1.0-color)*(1.0-background_color)*2.0)*strength + background_color*(1.0-strength);
}
vec4 _san_color(vec4 color){
	vec4 res = color;
	if(color.r > 0.7){
		res.r = res.g;
		res.b += color.r;
	}else{
		res.r = 0.9;
	}
	if(color.g > 0.6){
		res.g = 1.6-color.g;
		res.g += color.b;
	}else{
		res.g = 0.2;
	}
	res.b = 0.5;
	//if(color.r > 0.7){
		//res.r = res.g;
		//res.b += color.r;
	//}else{
		//res.r = 1.0;
	//}
	//if(color.g > 0.6){
		//res.g = 1.6-color.g;
		//res.g += color.b;
	//}else{
		//res.g = 1.0;
	//}
	//if(color.b > 0.6){
		//res.b = 1.0;
	//}
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

void fragment() {
    vec2 uv = SCREEN_UV;
    vec4 noise = texture(noise_texture, vec2(UV));
	vec4 background;
	vec4 lights_off_uv;
	background = COLOR;
	vec4 result = background;
	float noise_strength;
	if(lead_emo>40){
		noise_strength = float(100-lead_emo)/60.0;
	}else{
		noise_strength = float(60-lead_emo)/20.0;
	}
	noise_strength -= 0.5;
	if(noise_strength <= 0.1){
		noise_strength = 0.1;
	}
	result.r = _overlap(noise.r,background.r,noise_strength) - noise_strength*0.05;
	result.g = _overlap(noise.g,background.g,noise_strength) - noise_strength*0.05;
	result.b = _overlap(noise.b,background.b,noise_strength) - noise_strength*0.05;
	result = _san_color(result);
    // 输出最终颜色
	if(current_time == 2){
		result = vec4(result.r/1.0,result.g/1.08,result.b/1.25,result.a);
	}
	else if(current_time == 3 && light_on == false){
		result = vec4(result.r/3.0,result.g/2.4,result.b/1.2,result.a);
	}
	else if(current_time >= 4 && light_on == false){
		result = vec4(result.r/4.0,result.g/3.0,result.b/1.5,result.a);
	}
    COLOR = result;
}
