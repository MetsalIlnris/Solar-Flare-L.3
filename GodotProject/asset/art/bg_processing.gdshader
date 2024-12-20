shader_type canvas_item;

global uniform sampler2D noise_texture;
global uniform int lead_emo;
global uniform int current_time;
uniform sampler2D background_texture;
uniform sampler2D background_texture_night;

float _overlap(float color,float background_color,float strength){
	if(background_color>128.0){
		return (color * background_color/2.0)*strength + background_color*(1.0-strength);
	}else{
		return (1.0 - (1.0-color)*(1.0-background_color)*2.0)*strength + background_color*(1.0-strength);
	}
}

void fragment() {
    vec2 uv = SCREEN_UV;
    vec4 noise = texture(noise_texture, vec2(UV));
	vec4 lights_off_uv;
	vec4 result;
	if(current_time < 3){
		result = texture(background_texture, vec2(UV));
	}
    else{
		result = texture(background_texture_night, vec2(UV));
	}
	float noise_strength;
	if(lead_emo>40){
		noise_strength = float(100-lead_emo)/60.0;
	}else if(lead_emo>10){
		noise_strength = float(60-lead_emo)/20.0;
	}else{
		noise_strength = float(15-lead_emo)/2.0;
	}
	noise_strength -= 0.2;
	if(noise_strength <= 0.1){
		noise_strength = 0.1;
	}
	result.r = _overlap(noise.r,result.r,noise_strength)+noise_strength*0.01;
	result.g = _overlap(noise.g,result.g,noise_strength)-noise_strength*0.1;
	result.b = _overlap(noise.b,result.b,noise_strength)-noise_strength*0.06;

    // 输出最终颜色
	if(current_time == 0 ){
		result = vec4(result.r/1.1,result.g/1.1,result.b/1.08,result.a);
	}
    COLOR = result;
	
}
